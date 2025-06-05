import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:lista_de_la_compra/db/database.dart';
import 'package:lista_de_la_compra/enviroment_serializer.dart';
import 'package:lista_de_la_compra/providers/enviroment_provider.dart';
import 'package:lista_de_la_compra/providers/open_conection_provider.dart';
import 'package:lista_de_la_compra/providers/pairing_provider.dart';
import 'package:lista_de_la_compra/providers/product_provider.dart';
import 'package:lista_de_la_compra/providers/recipe_provider.dart';
import 'package:lista_de_la_compra/providers/schedule_provider.dart';
import 'package:lista_de_la_compra/providers/shared_preferences_provider.dart';
import 'package:lista_de_la_compra/sync/open_connection.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

Future<void> syncItems(
  List<dynamic> otherItems,
  List<dynamic> selfItems,
  Function(String, Map<String, dynamic>) syncOverideCallback,
  Function(String, int) syncSetDeletedCallback,
  Function(Map<String, dynamic>) syncAddProductCallback,
) async {
  for (var otherItem in otherItems) {
    var found = false;
    for (var selfItem in selfItems) {
      if (selfItem.id == otherItem["id"]) {
        found = true;

        if (selfItem.deletedAt == null && otherItem["deletedAt"] == null) {
          if (selfItem.updatedAt < otherItem["updatedAt"]) {
            syncOverideCallback(selfItem.id, otherItem);
          }
        }

        if (otherItem["deletedAt"] != null) {
          if (selfItem.deletedAt == null || selfItem.deletedAt > otherItem["deletedAt"]) {
            syncSetDeletedCallback(selfItem.id, otherItem["deletedAt"]);
          }
        }
      }
    }

    if (!found) {
      syncAddProductCallback(otherItem);
    }
  }
}

class OpenConnectionManager {
  final ProductProvider productProvider;
  final RecipeProvider recipeProvider;
  final ScheduleProvider scheduleProvider;
  final PairingProvider pairingProvider;
  final OpenConnectionProvider openConnectionProvider;
  final SharedPreferencesProvider sharedPreferencesProvider;
  final EnviromentProvider enviromentProvider;

  Future<void> tryConnectingToHttpServer(String host, int port) async {
    var textUrl = "ws://$host:$port";

    try {
      WebSocketChannel channel = WebSocketChannel.connect(Uri.parse(textUrl));

      await channel.ready;

      socketManage(channel, (terminalId, nick) {
        pairingProvider.addHttpServerToRemoteTerminal(terminalId, host, port, nick);
      });
    } catch (e) {
      print("cant reach $textUrl: $e");
    }
  }

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

  Future<void> connectionRound() async {
    List<Future<void>> connectionFutures = [];
    for (var peer in await pairingProvider.getRemoteTerminals()) {
      if (openConnectionProvider.isConnected(peer.terminalId)) {
        continue;
      }

      if (peer.httpHost != null && peer.httpPort != null) {
        connectionFutures.add(tryConnectingToHttpServer(peer.httpHost!, peer.httpPort!));
      }
    }
    await Future.wait(connectionFutures);
  }

  void connectionRoundLoop() async {
    // TODO toggle this cyclic routine
    while (true) {
      await connectionRound();
      await Future.delayed(Duration(seconds: 2));
    }
  }

  OpenConnectionManager(
    this.pairingProvider,
    this.openConnectionProvider,
    this.productProvider,
    this.recipeProvider,
    this.scheduleProvider,
    this.sharedPreferencesProvider,
    this.enviromentProvider,
  ) {
    // Timer.periodic(const Duration(seconds: 60), (timer) {
    //   triggerSyncPull();
    // });

    productProvider.addListener(triggerSyncPush);
    recipeProvider.addListener(triggerSyncPush);
    scheduleProvider.addListener(triggerSyncPush);

    enviromentProvider.addListener(triggerHandshakePush);
    sharedPreferencesProvider.addListener(triggerHandshakePush);

    connectionRoundLoop();
  }

  Map<String, dynamic> getPing() {
    return {"type": "ping", "nonce": math.Random().nextInt(1000), "ping_t": DateTime.now().millisecondsSinceEpoch};
  }

  Future<String> getStateDigest(int salt, String enviromentId) async {
    Uint8List bytes = utf8.encode(
      jsonEncode(await serializeEnviroment(enviromentId, enviromentProvider, productProvider, recipeProvider, scheduleProvider)),
    ); // data being hashed
    var saltedBytes = bytes + utf8.encode(salt.toString());
    return sha512256.convert(saltedBytes).toString();
  }

  Future<Map<String, dynamic>> getHandshake() async {
    return {
      "type": "handshake",
      "id": await sharedPreferencesProvider.getTerminalId(),
      "nick": await sharedPreferencesProvider.getLocalNick(),
      "env_list": await enviromentProvider.getEnviromentList(),
    };
  }

  Future<void> recieveState(data) async {
    Enviroment remoteEnviroment = Enviroment.fromJson(data["state"]["enviroment"]);
    Enviroment? currentEnviroment = await enviromentProvider.getEnviromentById(remoteEnviroment.id);
    if (currentEnviroment == null) {
      return;
    }

    if (currentEnviroment.updatedAt < remoteEnviroment.updatedAt) {
      if (currentEnviroment.name != remoteEnviroment.name) {
        enviromentProvider.setName(currentEnviroment.id, remoteEnviroment.name);
      }
    }

    Map<String, dynamic> state = data["state"];

    List<dynamic> otherProducts = state["products"]!;
    List<dynamic> otherRecipes = state["recipes"]!;
    List<dynamic> otherProductsRecipies = state["products_recipies"]!;
    List<dynamic> otherSchedule = state["schedule"]!;

    var selfProducts = productProvider.getSyncProductList(remoteEnviroment.id);
    var selfRecipes = recipeProvider.getSyncRecipeList(remoteEnviroment.id);
    var selfProductsRecipes = recipeProvider.getSyncRecipeProductList(remoteEnviroment.id);
    var selfSchedule = scheduleProvider.getSyncEntryList(remoteEnviroment.id);

    await syncItems(
      otherProducts,
      await selfProducts,
      (id, item) => productProvider.syncOveride(id, item),
      (id, deletedAt) => productProvider.syncSetDeleted(id, deletedAt),
      (item) => productProvider.syncAddProduct(item),
    );

    await syncItems(
      otherRecipes,
      await selfRecipes,
      (id, item) => recipeProvider.syncOverideRecipe(id, item),
      (id, deletedAt) => recipeProvider.syncSetDeletedRecipe(id, deletedAt),
      (item) => recipeProvider.syncAddRecipe(item),
    );

    await syncItems(
      otherProductsRecipies,
      await selfProductsRecipes,
      (id, item) => recipeProvider.syncOverideRecipeProduct(id, item),
      (id, deletedAt) => recipeProvider.syncSetDeletedRecipeProduct(id, deletedAt),
      (item) => recipeProvider.syncAddRecipeProduct(item),
    );

    await syncItems(
      otherSchedule,
      await selfSchedule,
      (id, item) => scheduleProvider.syncOveride(id, item),
      (id, deletedAt) => scheduleProvider.syncSetDeleted(id, deletedAt),
      (item) => scheduleProvider.syncAddEntry(item),
    );
  }

  void socketManage(WebSocketChannel ws, Function(String, String) afterHandshakeCb) async {
    String? terminalId;
    String? nick;

    void send(msg) {
      ws.sink.add(msg);
    }

    Future<void> triggerSyncPull() async {
      for (Enviroment env in await enviromentProvider.getEnviromentList()) {
        int salt = math.Random().nextInt(1000);
        send(jsonEncode({"type": "send_digest", "salt": salt, "enviroment": env, "digest": await getStateDigest(salt, env.id)}));
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

          // print("recieved from $nick: $data");

          switch (data["type"]) {
            case "ping":
              send(jsonEncode({"type": "pong", "nonce": data["nonce"], "ping_t": data["ping_t"], "pong_t": DateTime.now().millisecondsSinceEpoch}));
              break;
            case "pong":
              responsivenessTimeout?.cancel();
              responsivenessTimeout = Timer(Duration(seconds: 1), checkResponsiveness);
              num latency = DateTime.now().millisecondsSinceEpoch - data["ping_t"];
              if (terminalId != null) {
                openConnectionProvider.setLatency(terminalId!, latency);
              }

              break;
            case "handshake":
              terminalId = data["id"];
              nick = data["nick"];

              pairingProvider.setNickOf(data["id"], data["nick"]);

              afterHandshakeCb(terminalId!, nick!);

              List<Enviroment> envList = [];

              for (var jsonEnv in data["env_list"]) {
                envList.add(Enviroment.fromJson(jsonEnv));
              }

              openConnectionProvider.addOpenConnection(
                terminalId!,
                nick!,
                () async => await triggerSyncPull(),
                () => send(jsonEncode({"type": "sync_push"})),
                () async => send(jsonEncode(await getHandshake())),
                () => (ws.sink.close(4001, "Errased Peer")),
                envList,
              );
              triggerSyncPull();

              responsivenessTimeout?.cancel();
              checkResponsiveness();
              break;

            case "sync_push":
              triggerSyncPull();

              break;

            case "send_digest":
              Enviroment remoteEnviroment = Enviroment.fromJson(data["enviroment"]);
              Enviroment? currentEnviroment = await enviromentProvider.getEnviromentById(remoteEnviroment.id);
              if (currentEnviroment == null) {
                break;
              }

              if (currentEnviroment.updatedAt < remoteEnviroment.updatedAt) {
                if (currentEnviroment.name != remoteEnviroment.name) {
                  enviromentProvider.setName(currentEnviroment.id, remoteEnviroment.name);
                }
              }

              String ownDigest = await getStateDigest(data["salt"], remoteEnviroment.id);

              if (data["digest"] == ownDigest) {
                send(jsonEncode({"type": "sync_up_to_date"}));
              } else {
                send(
                  jsonEncode({
                    "type": "send_state",
                    "state": await serializeEnviroment(remoteEnviroment.id, enviromentProvider, productProvider, recipeProvider, scheduleProvider),
                  }),
                );
              }
              break;

            case "send_state":
              recieveState(data);

              break;
          }
        }
      },
      onDone: () {
        responsivenessTimeout?.cancel();
        if (terminalId != null) {
          openConnectionProvider.removeOpenConnection(terminalId!);
        }
      },
    );

    send(jsonEncode(await getHandshake()));
  }
}
