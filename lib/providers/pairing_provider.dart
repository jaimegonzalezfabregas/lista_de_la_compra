import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:jhopping_list/db/database.dart';

class PairingProvider extends ChangeNotifier {
  Future<void> addHttpServerToRemoteTerminal(String terminalId, String host, int port, String nick) async {
    final database = AppDatabaseSingleton.instance;

    await database
        .into(database.remoteTerminals)
        .insertOnConflictUpdate(
          RemoteTerminalsCompanion(
            terminalId: Value(terminalId),
            nick: Value(nick),
            httpHost: Value(host),
            httpPort: Value(port),
            isHttpServer: const Value(true),
          ),
        );

    notifyListeners();
  }

  Future<void> addHttpClientToRemoteTerminal(String terminalId, String nick) async {
    final database = AppDatabaseSingleton.instance;

    await database
        .into(database.remoteTerminals)
        .insertOnConflictUpdate(RemoteTerminalsCompanion(terminalId: Value(terminalId), nick: Value(nick), isHttpClient: const Value(true)));

    notifyListeners();
  }

  Future<List<RemoteTerminal>> getRemoteTerminals() async {
    final database = AppDatabaseSingleton.instance;

    var query = database.select(database.remoteTerminals);

    return await query.get();
  }

  Future<void> deleteRemoteTerminalById(String terminalId) async {
    final database = AppDatabaseSingleton.instance;

    await (database.delete(database.remoteTerminals)..where((table) => table.terminalId.equals(terminalId))).go();

    notifyListeners();
  }

  Future<RemoteTerminal> getRemoteTerminalById(String terminalId) async {
    final database = AppDatabaseSingleton.instance;
    return await (database.select(database.remoteTerminals)..where((table) => table.terminalId.equals(terminalId))).getSingle();
  }

  Future<void> setNickOf(String terminalId, String nick) async {
    final database = AppDatabaseSingleton.instance;

    var query = database.update(database.remoteTerminals);
    query.where((tbl) => tbl.terminalId.equals(terminalId));
    query.write(RemoteTerminalsCompanion(nick: Value(nick)));

    // TODO do not notify when no change was made
    notifyListeners();
  }
}
