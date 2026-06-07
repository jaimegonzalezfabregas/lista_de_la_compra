import 'package:drift/drift.dart';

import '../../lista_de_la_compra_backend.dart';


class RamEnvironmentProvider extends EnvironmentProvider with VoidEventSourceMixin {
}


abstract class EnvironmentProvider  implements VoidEventSource{
  Future<Environment?> getEnvironmentById(String id) async {
    final database = AppDatabaseSingleton.instance;

    return await (database.select(database.enviroments)..where((table) => table.id.equals(id))).getSingleOrNull();
  }

  Future<List<Environment>> getEnvironmentList() async {
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

  Future<void> addEmptyEnvironment(String name) async {
    final database = AppDatabaseSingleton.instance;

    await database
        .into(database.enviroments)
        .insert(EnviromentsCompanion(name: Value(name), updatedAt: Value(DateTime.now().millisecondsSinceEpoch)));
    notifyListeners();
  }

  Future<void> upsertEnvironment(Environment env) async {
    final database = AppDatabaseSingleton.instance;

    await database.into(database.enviroments).insertOnConflictUpdate(env);
    notifyListeners();
  }

  Future<void> deleteById(String id) async {
    final database = AppDatabaseSingleton.instance;

    await (database.delete(database.enviroments)..where((tbl) => tbl.id.equals(id))).go();

    notifyListeners();
  }
}
