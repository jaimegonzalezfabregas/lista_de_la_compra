import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:jhopping_list/db/database.dart';

class PairingProvider extends ChangeNotifier {
  Future<void> addHttpServerToRemoteTerminal(String id, String host, int port, String token, String nick) async {
    final database = AppDatabaseSingleton.instance;

    await database
        .into(database.remoteTerminals)
        .insertOnConflictUpdate(
          RemoteTerminalsCompanion(
            id: Value(id),
            nick: Value(nick),
            http_host: Value(host),
            http_port: Value(port.toString()),
            http_cookie: Value(token),
            isHttpServer: const Value(true),
          ),
        );

    notifyListeners();
  }

  Future<void> addHttpClientToRemoteTerminal(String id, String nick, String token) async {
    final database = AppDatabaseSingleton.instance;

    await database
        .into(database.remoteTerminals)
        .insertOnConflictUpdate(
          RemoteTerminalsCompanion(id: Value(id), nick: Value(nick), http_cookie: Value(token), isHttpClient: const Value(true)),
        );

    notifyListeners();
  }

  Future<List<RemoteTerminal>> getRemoteTerminals() async {
    final database = AppDatabaseSingleton.instance;

    return await database.select(database.remoteTerminals).get();
  }

  Future<void> deleteRemoteTerminalById(String id) async {
    final database = AppDatabaseSingleton.instance;
    await (database.delete(database.remoteTerminals)..where((table) => table.id.equals(id))).go();
    notifyListeners();
  }

  Future<RemoteTerminal> getRemoteTerminalById(String id) async {
    final database = AppDatabaseSingleton.instance;
    return await (database.select(database.remoteTerminals)..where((table) => table.id.equals(id))).getSingle();
  }
}
