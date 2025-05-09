import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:jhopping_list/db/database.dart';
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

  Future<void> updateNick(String id, String nick) async {
    final database = AppDatabaseSingleton.instance;

    await (database.update(database.remoteTerminals)..where((table) => table.id.equals(id))).write(RemoteTerminalsCompanion(nick: Value(nick)));

    notifyListeners();
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

  Future<String?> getRoomKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('RoomKey');
  }

  Future<void> setRoomKey(String nick) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('RoomKey', nick);

    notifyListeners();
  }
}
