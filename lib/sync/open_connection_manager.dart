import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:jhopping_list/db/database.dart';
import 'package:jhopping_list/providers/enviroment_provider.dart';
import 'package:jhopping_list/providers/open_conection_provider.dart';
import 'package:jhopping_list/providers/pairing_provider.dart';
import 'package:jhopping_list/providers/product_provider.dart';
import 'package:jhopping_list/providers/recipe_provider.dart';
import 'package:jhopping_list/providers/schedule_provider.dart';
import 'package:jhopping_list/providers/shared_preferences_provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class OpenConnection {
  final String terminalId;
  String nick;
  final Function cascadeTriggerSyncPull;
  final Function cascadeTriggerSyncPush;
  final Function cascadeTriggerHandshakePush;
  final List<Enviroment> enviromentList;

  OpenConnection(
    this.terminalId,
    this.nick,
    this.cascadeTriggerSyncPull,
    this.cascadeTriggerSyncPush,
    this.cascadeTriggerHandshakePush,
    this.enviromentList,
  );

  void triggerSyncPull() {
    // print("triggering sync with $nick");
    cascadeTriggerSyncPull();
  }

  void triggerSyncPush() {
    // print("triggering syncwithme with $nick");
    cascadeTriggerSyncPush();
  }

  void setNick(String nick) {
    this.nick = nick;
  }

  void triggerHandshakePush() {
    cascadeTriggerHandshakePush();
  }
}

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

  void tryConnectingToHttpServer(String host, int port) {
    var textUrl = "ws://$host:$port";
    try {
      WebSocketChannel channel = WebSocketChannel.connect(Uri.parse(textUrl));

      socketManage(channel, (terminalId, nick) {
        pairingProvider.addHttpServerToRemoteTerminal(terminalId, host, port, nick);
      });
    } catch (e) {
      print("cant reach $textUrl: $e");
    }
  }

  void triggerSyncPull() async {
    for (OpenConnection conection in openConnectionProvider.openConnections) {
      conection.triggerSyncPull();
    }
  }

  void triggerSyncPush() async {
    for (var openConnection in openConnectionProvider.openConnections) {
      openConnection.triggerSyncPush();
    }
  }

  void triggerHandshakePush() async {
    for (var openConnection in openConnectionProvider.openConnections) {
      openConnection.triggerHandshakePush();
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

    Timer.periodic(const Duration(seconds: 2), (timer) async {
      for (var peer in await pairingProvider.getRemoteTerminals()) {
        if (openConnectionProvider.isConnected(peer.terminalId)) {
          continue;
        }

        if (peer.httpHost != null && peer.httpPort != null) {
          tryConnectingToHttpServer(peer.httpHost!, peer.httpPort!);
        }
      }
    });

    productProvider.addListener(triggerSyncPush);
    recipeProvider.addListener(triggerSyncPush);
    scheduleProvider.addListener(triggerSyncPush);

    enviromentProvider.addListener(triggerHandshakePush);
    sharedPreferencesProvider.addListener(triggerHandshakePush);
  }

  Future<Map<String, dynamic>> getState(String enviromentId) async {
    Enviroment enviroment = (await enviromentProvider.getEnviromentById(enviromentId))!;

    return {
      "enviroment": enviroment,
      "products": await productProvider.getSyncProductList(enviromentId),
      "recipes": await recipeProvider.getSyncRecipeList(enviromentId),
      "products_recipies": await recipeProvider.getSyncRecipeProductList(enviromentId),
      "schedule": await scheduleProvider.getSyncEntryList(enviromentId),
    };
  }

  Future<String> getStateDigest(int salt, String enviromentId) async {
    Uint8List bytes = utf8.encode(jsonEncode(await getState(enviromentId))); // data being hashed
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

    ws.stream.listen(
      (message) async {
        if (message is String) {
          Map<String, dynamic> data = jsonDecode(message);

          print("recieved from $nick: $data");

          switch (data["type"]) {
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
                envList,
              );
              triggerSyncPull();

              break;

            case "sync_push":
              triggerSyncPull();

              break;

            case "send_digest":
              Enviroment remoteEnviroment = Enviroment.fromJson(data["enviroment"]);
              Enviroment? currentEnviroment = await enviromentProvider.getEnviromentById(remoteEnviroment.id);
              if (currentEnviroment == null) {
                send(jsonEncode({"type": "enviroment_not_found"}));
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
                send(jsonEncode({"type": "send_state", "state": await getState(remoteEnviroment.id)}));
              }
              break;

            case "enviroment_not_found":
              pairingProvider.setAsEnviromentNotFound(terminalId!);
              break;

            case "send_state":
              Enviroment remoteEnviroment = Enviroment.fromJson(data["state"]["enviroment"]);
              Enviroment? currentEnviroment = await enviromentProvider.getEnviromentById(remoteEnviroment.id);
              if (currentEnviroment == null) {
                send(jsonEncode({"type": "enviroment_not_found"}));
                break;
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

              break;
          }
        }
      },
      onDone: () {
        if (terminalId != null) {
          openConnectionProvider.removeOpenConnection(terminalId!);
        }
      },
    );

    send(jsonEncode(await getHandshake()));
  }
}
