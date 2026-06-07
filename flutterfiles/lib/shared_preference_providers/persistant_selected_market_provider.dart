import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';

// TODO transform this to a ram provider, like temp_route_provider

class PersistantSelectedMarketProvider extends SelectedMarketProvider with ChangeNotifier {
  BuildContext? context;

  PersistantSelectedMarketProvider(this.context);
 
  @override
  Future<void> setSelectedSupermarket(String enviromentId, String supermarketId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("selectedSupermarket_$enviromentId", supermarketId);
    notifyListeners();
  }

  @override
  Future<void> clearSelectedSupermarket(String enviromentId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("selectedSupermarket_$enviromentId");
    notifyListeners();
  }

  @override
  Future<String?> getSelectedSupermarket(String enviromentId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("selectedSupermarket_$enviromentId");
  }
}
