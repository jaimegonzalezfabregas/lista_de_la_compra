// TODO: Put public facing types in this file.

import 'package:drift/drift.dart';

import 'db/database.dart';

typedef VoidCallback = void Function();


abstract class VoidEventSource {

  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const VoidEventSource();

  /// Register a closure to be called when the object notifies its listeners.
  void addListener(VoidCallback listener);

  /// Remove a previously registered closure from the list of closures that the
  /// object notifies.
  void removeListener(VoidCallback listener);

  void notifyListeners();
}

mixin class VoidEventSourceMixin implements VoidEventSource {

  final _growableList = <VoidCallback>[];

  @override
  void addListener(VoidCallback listener) {
    _growableList.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _growableList.remove(listener);
  }

  @override
  void notifyListeners(){
    _growableList.forEach( (listener)=> listener() );
  }
}

class RamEnviromentProvider extends EnviromentProvider with VoidEventSourceMixin {
}


abstract class EnviromentProvider  implements VoidEventSource{
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

  Future<void> addEmptyEnviroment(String name) async {
    final database = AppDatabaseSingleton.instance;

    await database
        .into(database.enviroments)
        .insert(EnviromentsCompanion(name: Value(name), updatedAt: Value(DateTime.now().millisecondsSinceEpoch)));
    notifyListeners();
  }

  Future<void> upsertEnviroment(Enviroment env) async {
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
