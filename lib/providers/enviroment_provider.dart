import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:jhopping_list/db/database.dart';

class EnviromentProvider extends ChangeNotifier {
  Future<Enviroment?> getEnviromentById(String id) async {
    final database = AppDatabaseSingleton.instance;

    return await (database.select(database.enviroments)..where((table) => table.id.equals(id))).getSingleOrNull();
  }

  Future<List<Enviroment>> getEnviromentList() async {
    final database = AppDatabaseSingleton.instance;

    return await (database.select(database.enviroments)).get();
  }

  Future<void> setName(String id, String newName) async {
    final database = AppDatabaseSingleton.instance;

    await (database.update(database.enviroments)..where(
      (table) => table.id.equals(id),
    )).write(EnviromentsCompanion(name: Value(newName), updatedAt: Value(DateTime.now().millisecondsSinceEpoch)));

    notifyListeners();
  }

  Future<void> addEnviroment(String name) async {
    final database = AppDatabaseSingleton.instance;

    await database
        .into(database.enviroments)
        .insert(EnviromentsCompanion(name: Value(name), updatedAt: Value(DateTime.now().millisecondsSinceEpoch)));
    notifyListeners();
  }
}
