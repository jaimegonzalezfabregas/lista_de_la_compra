import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/db/database.dart';
import 'package:lista_de_la_compra_http_server/lista_de_la_compra_http_server.dart';

class FlutterHttpServerProvider extends HttpServerProvider with ChangeNotifier{}


class RamHttpServerProvider extends HttpServerProvider with VoidEventSourceMixin {}



abstract class HttpServerProvider  implements VoidEventSource{
  Future<void> addHttpServer(String host, int port) async {
    final database = AppDatabaseSingleton.instance;

    if (!(await getHttpServers()).any((s) {
      return s.httpHost == host && s.httpPort == port;
    })) {
      await database.into(database.httpServer).insertOnConflictUpdate(HttpServerCompanion(httpHost: Value(host), httpPort: Value(port)));
    }
    notifyListeners();
  }

  Future<List<HttpServerData>> getHttpServers() async {
    final database = AppDatabaseSingleton.instance;

    var query = database.select(database.httpServer);

    return await query.get();
  }

  Future<void> deleteHttpServer(String id) async {
    final database = AppDatabaseSingleton.instance;

    await (database.delete(database.httpServer)..where((table) => table.id.equals(id))).go();

    notifyListeners();
  }

  Future<void> setNick(String id, String nick) async {
    final database = AppDatabaseSingleton.instance;

    await (database.update(database.httpServer)..where((table) => table.id.equals(id))).write(HttpServerCompanion(nick: Value(nick)));

    notifyListeners();
  }
}
