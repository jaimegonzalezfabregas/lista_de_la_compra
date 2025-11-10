import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../lista_de_la_compra_backend.dart';

class RamAisleProvider extends AisleProvider with VoidEventSourceMixin {}

abstract class AisleProvider implements VoidEventSource {
  Future<void> syncAddAisle(Map<String, dynamic> serialized) async {
    final database = AppDatabaseSingleton.instance;

    await database
        .into(database.aisles)
        .insert(
          AislesCompanion(
            id: Value(serialized["id"]),
            name: Value(serialized["name"]),
            marketId: Value(serialized["marketId"]),
            updatedAt: Value(serialized["updatedAt"]),
            deletedAt: Value(serialized["deletedAt"]),
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
      ),
    );

    notifyListeners();
  }

  Future<List<Aisle>> getDisplayAisleList(String enviromentId) async {
    final database = AppDatabaseSingleton.instance;
    // Join Aisles -> SuperMarkets and filter by the SuperMarket.enviromentId
    final joined = database.select(database.aisles).join([
      innerJoin(database.superMarkets, database.superMarkets.id.equalsExp(database.aisles.marketId)),
    ]);

    // Only non-deleted aisles, and supermarket must belong to the requested environment
    joined.where(database.aisles.deletedAt.isNull());
    joined.where(database.superMarkets.enviromentId.equals(enviromentId));

    final rows = await joined.get();
    return rows.map((r) => r.readTable(database.aisles)).toList();
  }

  Future<List<Aisle>> getSyncAisleList(String enviromentId) async {
    final database = AppDatabaseSingleton.instance;
    // Join through SuperMarkets to filter by environment, include deleted rows for sync
    final joined = database.select(database.aisles).join([
      innerJoin(database.superMarkets, database.superMarkets.id.equalsExp(database.aisles.marketId)),
    ]);

    joined.where(database.superMarkets.enviromentId.equals(enviromentId));
    joined.orderBy([OrderingTerm(expression: database.aisles.updatedAt, mode: OrderingMode.desc)]);

    final rows = await joined.get();
    return rows.map((r) => r.readTable(database.aisles)).toList();
  }

  Future<String> addAisle(String name, String marketId) async {
    final database = AppDatabaseSingleton.instance;
    final String id = Uuid().v7();

    await database
        .into(database.aisles)
        .insert(
          AislesCompanion(id: Value(id), name: Value(name), marketId: Value(marketId), updatedAt: Value(DateTime.now().millisecondsSinceEpoch)),
        );

    notifyListeners();
    return id;
  }

  Future<List<Aisle>> getAislesBySupermarket(String marketId) async {
    final database = AppDatabaseSingleton.instance;

    final q = database.select(database.aisles)..where((t) => t.marketId.equals(marketId));
    q.where((t) => t.deletedAt.isNull());
    q.orderBy([(u) => OrderingTerm(expression: u.name, mode: OrderingMode.asc)]);

    return await q.get();
  }

  Future<void> deleteById(String supermarketId) async {
    final database = AppDatabaseSingleton.instance;

    var q = database.update(database.aisles);

    q.where((tbl) => tbl.id.equals(supermarketId));

    q.write(AislesCompanion(deletedAt: Value(DateTime.now().millisecondsSinceEpoch)));

    notifyListeners();
  }

  Future<Aisle?> getAisleById(String aisleId) {
    final database = AppDatabaseSingleton.instance;

    var q = database.select(database.aisles);
    q.where((t) => t.id.equals(aisleId));

    return q.getSingleOrNull();
  }

  Future<bool> isProductInAisle(String aisleId, String id) async {
    final database = AppDatabaseSingleton.instance;

    final countQuery = database.selectOnly(database.productAisles)
      ..addColumns([database.productAisles.id])
      ..where(database.productAisles.aisleId.equals(aisleId))
      ..where(database.productAisles.productId.equals(id))
      ..where(database.productAisles.deletedAt.isNull());

    final count = await countQuery.get();

    return count.isNotEmpty;
  }
}
