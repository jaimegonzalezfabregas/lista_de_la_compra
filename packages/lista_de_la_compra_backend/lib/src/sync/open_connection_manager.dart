import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../lista_de_la_compra_backend.dart';
import 'environment_serializer.dart';

class OpenConnectionManager {
  final ProductProvider productProvider;
  final RecipeProvider recipeProvider;
  final ScheduleProvider scheduleProvider;
  final OpenConnectionProvider openConnectionProvider;
  final SharedPreferencesProvider sharedPreferencesProvider;
  final EnvironmentProvider environmentProvider;

  final bool downloadAllEnvironments;

  void triggerSyncPull() async {
    for (OpenConnection conection in openConnectionProvider.openConnections.values) {
      conection.triggerSyncPull();
    }
  }

  void triggerSyncPush() async {
    for (var openConnection in openConnectionProvider.openConnections.values) {
      openConnection.triggerSyncPush();
    }
  }

  void triggerHandshakePush() async {
    for (var openConnection in openConnectionProvider.openConnections.values) {
      openConnection.triggerHandshakePush();
    }
  }

  OpenConnectionManager(
    this.openConnectionProvider,
    this.productProvider,
    this.recipeProvider,
    this.scheduleProvider,
    this.sharedPreferencesProvider,
    this.environmentProvider, {
    this.downloadAllEnvironments = false,
  }) {
    productProvider.addListener(triggerSyncPush);
    recipeProvider.addListener(triggerSyncPush);
    scheduleProvider.addListener(triggerSyncPush);

    environmentProvider.addListener(triggerHandshakePush);
    sharedPreferencesProvider.addListener(triggerHandshakePush);
  }

  Map<String, dynamic> getPing() {
    return {"type": "ping", "nonce": math.Random().nextInt(1000), "ping_t": DateTime.now().millisecondsSinceEpoch};
  }

  Future<String> getStateDigest(int salt, String enviromentId) async {
    Uint8List bytes = utf8.encode(
      jsonEncode(await serializeEnvironment(enviromentId, environmentProvider, productProvider, recipeProvider, scheduleProvider)),
    ); // data being hashed
    var saltedBytes = bytes + utf8.encode(salt.toString());
    return sha512256.convert(saltedBytes).toString();
  }

  Future<Map<String, dynamic>> getHandshake() async {
    return {
      "type": "handshake",
      "id": await sharedPreferencesProvider.getTerminalId(),
      "nick": await sharedPreferencesProvider.getLocalNick(),
      "env_list": await environmentProvider.getEnvironmentList(),
    };
  }

  void socketManage(
    WebSocketChannel ws,
    String? connectionSourceId,
    String userNote, {
    Function(String)? afterHandshakeNickCb,
    Function? abortCb,
  }) async {
    print("socketManage");

    String? terminalId;
    String? openConnectionId;
    String? nick;

    void send(msg) {
      ws.sink.add(msg);
    }

    Future<void> triggerSyncPull() async {
      for (Environment env in await environmentProvider.getEnvironmentList()) {
        int salt = math.Random().nextInt(1000);
        send(jsonEncode({"type": "send_digest", "salt": salt, "environment": env, "digest": await getStateDigest(salt, env.id)}));
      }
    }

    Timer? responsivenessTimeout;

    void checkResponsiveness() {
      responsivenessTimeout?.cancel();
      responsivenessTimeout = Timer(Duration(seconds: 10), () => ws.sink.close());
      send(jsonEncode(getPing()));
    }

    ws.stream.listen(
      (message) async {
        if (message is String) {
          Map<String, dynamic> data = jsonDecode(message);

          switch (data["type"]) {
            case "ping":
              send(jsonEncode({"type": "pong", "nonce": data["nonce"], "ping_t": data["ping_t"], "pong_t": DateTime.now().millisecondsSinceEpoch}));
              break;
            case "pong":
              responsivenessTimeout?.cancel();
              responsivenessTimeout = Timer(Duration(seconds: 1), checkResponsiveness);
              num latency = DateTime.now().millisecondsSinceEpoch - data["ping_t"];
              if (terminalId != null) {
                openConnectionProvider.setLatency(openConnectionId!, latency);
              }

              break;
            case "handshake":
              terminalId = data["id"];
              nick = data["nick"];

              if (afterHandshakeNickCb != null && nick != null) {
                afterHandshakeNickCb(nick!);
              }

              List<Environment> envList = [];

              for (var jsonEnv in data["env_list"]) {
                envList.add(Environment.fromJson(jsonEnv));
              }

              if (openConnectionId == null) {
                openConnectionId = openConnectionProvider.addOpenConnection(
                  terminalId!,
                  connectionSourceId,
                  nick!,
                  () async => await triggerSyncPull(),
                  () => send(jsonEncode({"type": "sync_push"})),
                  () async => send(jsonEncode(await getHandshake())),
                  () => (ws.sink.close(4001, "Errased Peer")),
                  envList,
                  userNote,
                );
              } else {
                openConnectionProvider.setNick(openConnectionId!, nick!);
              }

              if (downloadAllEnvironments) {


                for (var env in envList) {
                  environmentProvider.upsertEnvironment(env);
                }
              }

              triggerSyncPull();

              responsivenessTimeout?.cancel();
              checkResponsiveness();
              break;

            case "sync_push":
              triggerSyncPull();

              break;

            case "send_digest":
              Environment remoteEnvironment = Environment.fromJson(data["environment"]);
              Environment? currentEnvironment = await environmentProvider.getEnvironmentById(remoteEnvironment.id);
              if (currentEnvironment == null) {
                break;
              }

              if (currentEnvironment.updatedAt < remoteEnvironment.updatedAt) {
                if (currentEnvironment.name != remoteEnvironment.name) {
                  environmentProvider.setName(currentEnvironment.id, remoteEnvironment.name);
                }
              }

              String ownDigest = await getStateDigest(data["salt"], remoteEnvironment.id);

              if (data["digest"] == ownDigest) {
                send(jsonEncode({"type": "sync_up_to_date"}));
              } else {
                send(
                  jsonEncode({
                    "type": "send_state",
                    "state": await serializeEnvironment(remoteEnvironment.id, environmentProvider, productProvider, recipeProvider, scheduleProvider),
                  }),
                );
              }
              break;

            case "send_state":
              recieveState(data["state"], environmentProvider, productProvider, recipeProvider, scheduleProvider);

              break;
          }
        }
      },
      onDone: () {
        print("ondone");
        responsivenessTimeout?.cancel();
        if (openConnectionId != null) {
          openConnectionProvider.removeOpenConnection(openConnectionId!);
        }
      },
    );

    send(jsonEncode(await getHandshake()));
  }
}
