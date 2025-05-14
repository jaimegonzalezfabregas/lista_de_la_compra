import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:crypto/crypto.dart';
import 'package:jhopping_list/providers/open_conection_provider.dart';
import 'package:jhopping_list/providers/pairing_provider.dart';
import 'package:jhopping_list/providers/product_provider.dart';
import 'package:jhopping_list/providers/recipe_provider.dart';
import 'package:jhopping_list/providers/schedule_provider.dart';
import 'package:jhopping_list/providers/shared_preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

Future<void> syncItems(
  List<Map<String, dynamic>> otherItems,
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

        if (selfItem.deletedAt != null && otherItem["deletedAt"] != null) {
          if (selfItem.updatedAt < otherItem["updatedAt"]) {
            syncOverideCallback(selfItem.id, otherItem);
          }
        } else {
          syncSetDeletedCallback(selfItem.id, math.min(selfItem.deletedAt ?? otherItem["deletedAt"], otherItem["deletedAt"] ?? selfItem.deletedAt));
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

  Future<void> tryConnectingToHttpServer(String host, int port) async {
    var textUrl = "ws://$host:$port";
    print("textUrl: $textUrl");

    WebSocketChannel channel = WebSocketChannel.connect(Uri.parse(textUrl));

    socketManage(channel, (terminalId, nick) {
      pairingProvider.addHttpServerToRemoteTerminal(terminalId, host, port, nick);
    });
  }

  OpenConnectionManager(
    this.pairingProvider,
    this.openConnectionProvider,
    this.productProvider,
    this.recipeProvider,
    this.scheduleProvider,
    this.sharedPreferencesProvider,
  ) {
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      for (var peer in await pairingProvider.getRemoteTerminals()) {
        if (openConnectionProvider.isOpenConnection(peer.terminalId)) {
          continue;
        }

        if (peer.httpHost != null && peer.httpPort != null) {
          tryConnectingToHttpServer(peer.httpHost!, peer.httpPort!);
        }
      }

      for (OpenConnection conection in openConnectionProvider.openConnections) {
        conection.triggerSync();
      }
    });
  }

  Future<String> getState() async {
    return jsonEncode({
      "products": await productProvider.getSyncProductList(),
      "recipes": await recipeProvider.getSyncRecipeList(),
      "products_recipies": await recipeProvider.getSyncRecipeProductList(),
      "schedule": await scheduleProvider.getSyncEntryList(),
    });
  }

  Future<String> getStateDigest() async {
    var bytes = utf8.encode(await getState()); // data being hashed
    return sha512256.convert(bytes).toString();
  }

  void socketManage(WebSocketChannel ws, Function(String, String) afterHandshakeCb) async {
    print("a new socket apeared");

    String? terminalId;
    String? nick;

    void send(msg) {
      print("sending to $nick   : $msg");
      ws.sink.add(msg);
    }

    ws.stream.listen((message) async {
      if (message is String) {
        if (terminalId != null) {
          openConnectionProvider.refreshOpenConnection(terminalId!);
        }

        Map<String, dynamic> data = jsonDecode(message);

        print("recieved from $nick: $data");

        switch (data["type"]) {
          case "handshake":
            terminalId = data["id"];
            nick = data["nick"];

            afterHandshakeCb(terminalId!, nick!);

            openConnectionProvider.addOpenConnection(
              terminalId!,
              nick!,
              () async => send(jsonEncode({"type": "send_digest", "digest": await getStateDigest()})),
            );
            openConnectionProvider.refreshOpenConnection(terminalId!);

            break;

          case "send_digest":
            String ownDigest = await getStateDigest();
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
            var state = data["state"];
            var otherProducts = state["products"];
            var otherRecipes = state["recipes"];
            var otherProductsRecipies = state["products_recipies"];
            var otherSchedule = state["schedule"];

            var selfProducts = productProvider.getSyncProductList();
            var selfRecipes = recipeProvider.getSyncRecipeList();
            var selfProductsRecipes = recipeProvider.getSyncRecipeProductList();
            var selfSchedule = scheduleProvider.getSyncEntryList();

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
    });

    send(
      jsonEncode({
        "type": "handshake",
        "id": await sharedPreferencesProvider.getTerminalId(),
        "nick": await sharedPreferencesProvider.getLocalNick(),
      }),
    );
  }
}
