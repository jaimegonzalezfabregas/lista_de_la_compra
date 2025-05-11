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


  Future<String?> getLocalNick() async {
    final prefs = await SharedPreferences.getInstance();
    var ret = prefs.getString('LocalNick');
    return ret;
  }

  Future<void> setLocalNick(String nick) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('LocalNick', nick);

    notifyListeners();
  }
}
