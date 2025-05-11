import 'dart:convert';
import 'dart:math' as math;

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:jhopping_list/db/database.dart';
import 'package:jhopping_list/providers/pairing_provider.dart';
import 'package:jhopping_list/providers/product_provider.dart';
import 'package:jhopping_list/providers/recipe_provider.dart';
import 'package:jhopping_list/providers/schedule_provider.dart';
import 'package:jhopping_list/providers/shared_preferences_provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class OpenConnection {
  final String terminalId;
  final String nick;
  final Function triggerSync;

  DateTime lastContact = DateTime.now();

  OpenConnection(this.terminalId, this.nick, this.triggerSync);

  void updateLastContact() {
    lastContact = DateTime.now();
  }
}



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

class OpenConnectionProvider extends ChangeNotifier {
  final ProductProvider productProvider;
  final RecipeProvider recipeProvider;
  final ScheduleProvider scheduleProvider;
  final SharedPreferencesProvider sharedPreferencesProvider;
  final PairingProvider pairingProvider;

  final List<OpenConnection> _openConnections = [];

  OpenConnectionProvider(this.productProvider, this.recipeProvider, this.scheduleProvider, this.sharedPreferencesProvider, this.pairingProvider);

  List<OpenConnection> get openConnections => _openConnections;

  void addOpenConnection(String terminalId, String nick, Function triggerSync) {
    _openConnections.add(OpenConnection(terminalId, nick, triggerSync));
    notifyListeners();
  }

  void refreshOpenConnection(String terminalId) {
    final connection = _openConnections.firstWhere((connection) => connection.terminalId == terminalId);
    connection.updateLastContact();
    notifyListeners();
  }

  void removeOpenConnection(String terminalId) {
    _openConnections.removeWhere((connection) => connection.terminalId == terminalId);
    notifyListeners();
  }

  bool isOpenConnection(String terminalId) {
    return _openConnections.any((connection) => connection.terminalId == terminalId);
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
    String? terminalId;

    ws.stream.listen((message) async {
      if (message is String) {
        if (terminalId != null) {
          refreshOpenConnection(terminalId!);
        }

        Map<String, dynamic> data = jsonDecode(message);

        switch (data["type"]) {
          case "handshake":
            terminalId = data["id"];
            String nick = data["nick"];

            afterHandshakeCb(terminalId!, nick);

            addOpenConnection(terminalId!, nick, () async => ws.sink.add(jsonEncode({"type": "send_digest", "digest": await getStateDigest()})));
            refreshOpenConnection(terminalId!);

            break;

          case "send_digest":
            String ownDigest = await getStateDigest();
            if (data["digest"] == ownDigest) {
              pairingProvider.setAsSynced(terminalId!);
              ws.sink.add(jsonEncode({"type": "sync_up_to_date"}));
            } else {
              ws.sink.add(jsonEncode({"type": "send_state", "state": await getState()}));
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

    ws.sink.add(
      jsonEncode({
        "type": "handshake",
        "id": await sharedPreferencesProvider.getTerminalId(),
        "nick": await sharedPreferencesProvider.getLocalNick(),
      }),
    );
  }
}
