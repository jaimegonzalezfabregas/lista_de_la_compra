import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:jhopping_list/db/database.dart';
import 'package:jhopping_list/providers/open_conection_provider.dart';
import 'package:jhopping_list/providers/pairing_provider.dart';
import 'package:jhopping_list/providers/product_provider.dart';
import 'package:jhopping_list/providers/recipe_provider.dart';
import 'package:jhopping_list/providers/schedule_provider.dart';
import 'package:jhopping_list/providers/shared_preferences_provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class OpenConnection {
  final String terminalId;
  final String nick;
  final Function cascadeTriggerSyncPull;
  final Function cascadeTriggerSyncPush;

  DateTime lastContact = DateTime.now();

  OpenConnection(this.terminalId, this.nick, this.cascadeTriggerSyncPull, this.cascadeTriggerSyncPush);

  void triggerSyncPull() {
    // print("triggering sync with $nick");
    cascadeTriggerSyncPull();
  }

  void triggerSyncPush() {
    // print("triggering syncwithme with $nick");
    cascadeTriggerSyncPush();
  }

  void updateLastContact() {
    lastContact = DateTime.now();
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
            print("overriding $selfItem with $otherItem");
            syncOverideCallback(selfItem.id, otherItem);
          }
        }

        if (otherItem["deletedAt"] != null) {
          if (selfItem.deletedAt == null || selfItem.deletedAt > otherItem["deletedAt"]) {
            print("deleting $selfItem because of $otherItem");

            syncSetDeletedCallback(selfItem.id, otherItem["deletedAt"]);
          }
        }
      }
    }

    if (!found) {
      print("adding $otherItem");

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

  final Enviroment enviroment;

  void tryConnectingToHttpServer(String host, int port) {
    var textUrl = "ws://$host:$port";
    try {
      WebSocketChannel channel = WebSocketChannel.connect(Uri.parse(textUrl));

      socketManage(channel, (terminalId, nick) {
        pairingProvider.addHttpServerToRemoteTerminal(terminalId, host, port, nick, enviroment.id);
      });
    } catch (e) {}
  }

  void triggerSyncPush() async {
    for (var openConnection in openConnectionProvider.openConnections) {
      openConnection.triggerSyncPush();
    }
  }

  OpenConnectionManager(
    this.pairingProvider,
    this.openConnectionProvider,
    this.productProvider,
    this.recipeProvider,
    this.scheduleProvider,
    this.sharedPreferencesProvider,
    this.enviroment,
  ) {
    Timer.periodic(const Duration(seconds: 60), (timer) {
      for (OpenConnection conection in openConnectionProvider.openConnections) {
        conection.triggerSyncPull();
      }
    });

    Timer.periodic(const Duration(seconds: 2), (timer) async {
      for (var peer in await pairingProvider.getRemoteTerminals(enviroment.id)) {
        if (openConnectionProvider.isOpenConnection(peer.terminalId)) {
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
  }

  Future<Map<String, dynamic>> getState() async {
    return {
      "products": await productProvider.getSyncProductList(enviroment.id),
      "recipes": await recipeProvider.getSyncRecipeList(enviroment.id),
      "products_recipies": await recipeProvider.getSyncRecipeProductList(enviroment.id),
      "schedule": await scheduleProvider.getSyncEntryList(enviroment.id),
    };
  }

  Future<String> getStateDigest(int salt) async {
    Uint8List bytes = utf8.encode(jsonEncode(await getState())); // data being hashed
    var saltedBytes = bytes + utf8.encode(salt.toString());
    return sha512256.convert(saltedBytes).toString().substring(0, 4);
  }

  void socketManage(WebSocketChannel ws, Function(String, String) afterHandshakeCb) async {
    String? terminalId;
    String? nick;

    void send(msg) {
      // print("sending to $nick   : $msg");
      ws.sink.add(msg);
    }

    Future<void> triggerSyncPull() async {
      int salt = math.Random().nextInt(1000);

      send(jsonEncode({"type": "send_digest", "salt": salt, "digest": await getStateDigest(salt)}));
    }

    ws.stream.listen(
      (message) async {
        if (message is String) {
          if (terminalId != null) {
            openConnectionProvider.refreshOpenConnection(terminalId!);
          }

          Map<String, dynamic> data = jsonDecode(message);

          // print("recieved from $nick: $data");

          switch (data["type"]) {
            case "handshake":
              terminalId = data["id"];
              nick = data["nick"];

              afterHandshakeCb(terminalId!, nick!);

              openConnectionProvider.addOpenConnection(
                terminalId!,
                nick!,
                () async => triggerSyncPull(),
                () async => send(jsonEncode({"type": "sync_push"})),
              );
              openConnectionProvider.refreshOpenConnection(terminalId!);
              triggerSyncPull();
              break;

            case "sync_push":
              triggerSyncPull();

              break;

            case "send_digest":
              String ownDigest = await getStateDigest(data["salt"]);
              if (data["digest"] == ownDigest) {
                pairingProvider.setAsSynced(terminalId!);
                send(jsonEncode({"type": "sync_up_to_date"}));
              } else {
                send(jsonEncode({"type": "send_state", "state": await getState()}));
              }
              break;
            case "sync_up_to_date":
              pairingProvider.setAsSynced(terminalId!);

            case "send_state":
              Map<String, dynamic> state = data["state"];

              List<dynamic> otherProducts = state["products"]!;
              List<dynamic> otherRecipes = state["recipes"]!;
              List<dynamic> otherProductsRecipies = state["products_recipies"]!;
              List<dynamic> otherSchedule = state["schedule"]!;

              var selfProducts = productProvider.getSyncProductList(enviroment.id);
              var selfRecipes = recipeProvider.getSyncRecipeList(enviroment.id);
              var selfProductsRecipes = recipeProvider.getSyncRecipeProductList(enviroment.id);
              var selfSchedule = scheduleProvider.getSyncEntryList(enviroment.id);

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
        }
      },
      onDone: () {
        openConnectionProvider.removeOpenConnection(terminalId!);
      },
    );

    send(
      jsonEncode({
        "type": "handshake",
        "id": await sharedPreferencesProvider.getTerminalId(),
        "nick": await sharedPreferencesProvider.getLocalNick(),
      }),
    );
  }
}
