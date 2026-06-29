import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../lista_de_la_compra_backend.dart';

class RamHouseProvider extends HouseProvider with VoidEventSourceMixin {}

abstract class HouseProvider implements VoidEventSource {
  Future<String> addHouse(String name, String enviromentId, {int color = 0xFFF44336}) async {
    final database = AppDatabaseSingleton.instance;
    String id = Uuid().v7();

    await database.into(database.houses).insert(HousesCompanion(
      id: Value(id),
      name: Value(name),
      enviromentId: Value(enviromentId),
      updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      color: Value(color),
    ));

    notifyListeners();
    return id;
  }

  Future<List<House>> getHouseList(String enviromentId) async {
    final database = AppDatabaseSingleton.instance;
    return await (database.select(database.houses)
          ..where((table) => table.deletedAt.isNull())
          ..where((table) => table.enviromentId.equals(enviromentId)))
        .get();
  }

  Future<List<House>> getSyncHouseList(String enviromentId) async {
    final database = AppDatabaseSingleton.instance;
    var query = database.select(database.houses);
    query.where((table) => table.enviromentId.equals(enviromentId));
    query.orderBy([(u) => OrderingTerm(expression: u.updatedAt, mode: OrderingMode.desc)]);
    return await query.get();
  }

  Future<House?> getHouseById(String id) async {
    final database = AppDatabaseSingleton.instance;
    return await (database.select(database.houses)
          ..where((table) => table.id.equals(id))
          ..where((table) => table.deletedAt.isNull()))
        .getSingleOrNull();
  }

  Future<void> setName(String id, String name) async {
    final database = AppDatabaseSingleton.instance;
    await (database.update(database.houses)..where((table) => table.id.equals(id))).write(
      HousesCompanion(name: Value(name), updatedAt: Value(DateTime.now().millisecondsSinceEpoch)),
    );
    notifyListeners();
  }

  Future<void> setColor(String id, int color) async {
    final database = AppDatabaseSingleton.instance;
    await (database.update(database.houses)..where((table) => table.id.equals(id))).write(
      HousesCompanion(color: Value(color), updatedAt: Value(DateTime.now().millisecondsSinceEpoch)),
    );
    notifyListeners();
  }

  Future<void> setNameAndColor(String id, String name, int color) async {
    final database = AppDatabaseSingleton.instance;
    await (database.update(database.houses)..where((table) => table.id.equals(id))).write(
      HousesCompanion(
        name: Value(name),
        color: Value(color),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
    notifyListeners();
  }

  Future<void> deleteById(String id) async {
    final database = AppDatabaseSingleton.instance;
    await (database.update(database.houses)..where((table) => table.id.equals(id)))
        .write(HousesCompanion(deletedAt: Value(DateTime.now().millisecondsSinceEpoch)));
    notifyListeners();
  }

  Future<void> syncAddHouse(Map<String, dynamic> serialized) async {
    final database = AppDatabaseSingleton.instance;
    await database.into(database.houses).insert(HousesCompanion(
      id: Value(serialized["id"]),
      name: Value(serialized["name"]),
      enviromentId: Value(serialized["enviromentId"]),
      updatedAt: Value(serialized["updatedAt"]),
      deletedAt: Value(serialized["deletedAt"]),
      color: Value((serialized["color"] as int?) ?? 0xFFF44336),
    ));
    notifyListeners();
  }

  Future<void> syncSetDeleted(String id, int deletedAt) async {
    final database = AppDatabaseSingleton.instance;
    await (database.update(database.houses)..where((table) => table.id.equals(id)))
        .write(HousesCompanion(deletedAt: Value(deletedAt)));
    notifyListeners();
  }

  Future<void> syncOveride(String id, Map<String, dynamic> serialized) async {
    final database = AppDatabaseSingleton.instance;
    await (database.update(database.houses)..where((table) => table.id.equals(id))).write(
      HousesCompanion(
        id: Value(serialized["id"]),
        name: Value(serialized["name"]),
        updatedAt: Value(serialized["updatedAt"]),
        deletedAt: Value(serialized["deletedAt"]),
        color: Value((serialized["color"] as int?) ?? 0xFFF44336),
      ),
    );
    notifyListeners();
  }
}
