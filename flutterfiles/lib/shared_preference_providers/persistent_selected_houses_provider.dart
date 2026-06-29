import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';

class PersistentSelectedHousesProvider extends SelectedHousesProvider with ChangeNotifier {
  @override
  Future<List<String>> getSelectedHouses(String enviromentId) async {
    final prefs = await SharedPreferences.getInstance();
    var raw = prefs.getString("selected_houses_$enviromentId");
    if (raw == null || raw.isEmpty) return [];
    return (jsonDecode(raw) as List).cast<String>();
  }

  @override
  Future<void> setSelectedHouses(String enviromentId, List<String> houseIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("selected_houses_$enviromentId", jsonEncode(houseIds));
    notifyListeners();
  }
}
