import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

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

  Future<String> addEmptyEnvironment(String name) async {
    final database = AppDatabaseSingleton.instance;
    String envId = Uuid().v7();

    await database
        .into(database.enviroments)
        .insert(EnviromentsCompanion(id: Value(envId), name: Value(name), updatedAt: Value(DateTime.now().millisecondsSinceEpoch)));

    // Create a default house for the new environment
    await database.into(database.houses).insert(HousesCompanion(
      id: Value(Uuid().v7()),
      name: Value('rename_me'),
      enviromentId: Value(envId),
      updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
    ));

    notifyListeners();
    return envId;
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
