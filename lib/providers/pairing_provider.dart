import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:jhopping_list/db/database.dart';

class PairingProvider extends ChangeNotifier {
  Future<void> addHttpServerToRemoteTerminal(String terminalId, String host, int port, String nick, String enviromentId) async {
    final database = AppDatabaseSingleton.instance;

    await database
        .into(database.remoteTerminalEnviroments)
        .insert(RemoteTerminalEnviromentsCompanion(terminalId: Value(terminalId), enviromentId: Value(enviromentId)));

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

  Future<void> addHttpClientToRemoteTerminal(String terminalId, String nick, String enviromentId) async {
    final database = AppDatabaseSingleton.instance;

    await database
        .into(database.remoteTerminalEnviroments)
        .insert(RemoteTerminalEnviromentsCompanion(terminalId: Value(terminalId), enviromentId: Value(enviromentId)));

    await database
        .into(database.remoteTerminals)
        .insertOnConflictUpdate(RemoteTerminalsCompanion(terminalId: Value(terminalId), nick: Value(nick), isHttpClient: const Value(true)));

    notifyListeners();
  }

  Future<List<RemoteTerminal>> getRemoteTerminals(String enviromentId) async {
    final database = AppDatabaseSingleton.instance;

    var query = database.select(database.remoteTerminals).join([
      innerJoin(database.remoteTerminalEnviroments, database.remoteTerminalEnviroments.terminalId.equalsExp(database.remoteTerminals.terminalId)),
    ]);

    query.where(database.remoteTerminalEnviroments.enviromentId.equals(enviromentId));

    return await query.map((u) => u.readTable(database.remoteTerminals)).get();
  }

  Future<void> deleteRemoteTerminalById(String terminalId, String enviromentId) async {
    final database = AppDatabaseSingleton.instance;

    await (database.delete(database.remoteTerminalEnviroments)
      ..where((table) => table.terminalId.equals(terminalId) & table.enviromentId.equals(enviromentId))).go();

    if ((await (database.select(database.remoteTerminalEnviroments)..where((table) => table.terminalId.equals(terminalId))).get()).isEmpty) {
      await (database.delete(database.remoteTerminals)..where((table) => table.terminalId.equals(terminalId))).go();
    }

    notifyListeners();
  }

  Future<RemoteTerminal> getRemoteTerminalById(String terminalId) async {
    final database = AppDatabaseSingleton.instance;
    return await (database.select(database.remoteTerminals)..where((table) => table.terminalId.equals(terminalId))).getSingle();
  }

  Future<void> setAsSynced(String terminalId) async {
    final database = AppDatabaseSingleton.instance;

    await (database.update(database.remoteTerminals)
      ..where((table) => table.terminalId.equals(terminalId))).write(RemoteTerminalsCompanion(lastSync: Value(DateTime.now().toString())));
    notifyListeners();
  }

  Future<void> setAsEnviromentNotFound(String terminalId) async {
    // TODO
  }
}
