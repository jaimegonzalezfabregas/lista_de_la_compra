import 'package:device_marketing_names/device_marketing_names.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class SharedPreferencesProvider extends ChangeNotifier {
  Future<String> getTerminalId() async {
    final prefs = await SharedPreferences.getInstance();
    var ret = prefs.getString('TerminalId');
    if (ret == null) {
      ret = Uuid().v7();
      await prefs.setString('TerminalId', ret);
    }
    return ret;
  }

  Future<String> getLocalNick() async {
    final prefs = await SharedPreferences.getInstance();
    final deviceNames = DeviceMarketingNames();

    return prefs.getString('LocalNick') ?? await deviceNames.getSingleName();
  }

  Future<void> setLocalNick(String nick) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('LocalNick', nick);

    notifyListeners();
  }

  Future<void> setSelectedEnviroment(String enviromentId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("selectedEnviroment", enviromentId);
    notifyListeners();
  }

  Future<void> clearSelectedEnviroment() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("selectedEnviroment");
    notifyListeners();
  }

  Future<String?> getSelectedEnviroment() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("selectedEnviroment");
  }
}
