import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../lista_de_la_compra_backend.dart';


class RamAisleProvider extends AisleProvider with VoidEventSourceMixin {}

abstract class AisleProvider implements VoidEventSource {
  Future<void> syncAddAisle(Map<String, dynamic> serialized) async {
    final database = AppDatabaseSingleton.instance;

    await database.into(database.aisles).insert(
      AislesCompanion(
        id: Value(serialized["id"]),
        name: Value(serialized["name"]),
        marketId: Value(serialized["marketId"]),
        updatedAt: Value(serialized["updatedAt"]),
        deletedAt: Value(serialized["deletedAt"]),
        enviromentId: Value(serialized["enviromentId"]),
      ),
    );

    notifyListeners();
  }

  Future<void> syncSetDeletedAisle(String id, int? deletedAt) async {
    final database = AppDatabaseSingleton.instance;

    await (database.update(database.aisles)..where((tbl) => tbl.id.equals(id))).write(AislesCompanion(deletedAt: Value(deletedAt)));
    notifyListeners();
  }

  Future<void> syncOverideAisle(String id, Map<String, dynamic> serialized) async {
    final database = AppDatabaseSingleton.instance;

    await (database.update(database.aisles)..where((tbl) => tbl.id.equals(id))).write(
      AislesCompanion(
        id: Value(serialized["id"]),
        name: Value(serialized["name"]),
        marketId: Value(serialized["marketId"]),
        updatedAt: Value(serialized["updatedAt"]),
        deletedAt: Value(serialized["deletedAt"]),
        enviromentId: Value(serialized["enviromentId"]),
      ),
    );

    notifyListeners();
  }

  Future<List<Aisle>> getDisplayAisleList(String enviromentId) async {
    final database = AppDatabaseSingleton.instance;

    return await (database.select(database.aisles)
          ..where((t) => t.deletedAt.isNull())
          ..where((t) => t.enviromentId.equals(enviromentId)))
        .get();
  }

  Future<List<Aisle>> getSyncAisleList(String enviromentId) async {
    final database = AppDatabaseSingleton.instance;

    var q = database.select(database.aisles);
    q.where((t) => t.enviromentId.equals(enviromentId));
    q.orderBy([(u) => OrderingTerm(expression: u.updatedAt, mode: OrderingMode.desc)]);

    return await q.get();
  }

  Future<String> addAisle(String name, String marketId, String enviromentId) async {
    final database = AppDatabaseSingleton.instance;
    final String id = Uuid().v7();

    await database.into(database.aisles).insert(
          AislesCompanion(
            id: Value(id),
            name: Value(name),
            marketId: Value(marketId),
            enviromentId: Value(enviromentId),
            updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
          ),
        );

    notifyListeners();
    return id;
  }
}
