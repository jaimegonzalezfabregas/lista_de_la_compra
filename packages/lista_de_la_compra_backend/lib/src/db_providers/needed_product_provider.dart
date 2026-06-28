import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../lista_de_la_compra_backend.dart';

class RamNeededProductProvider extends NeededProductProvider with VoidEventSourceMixin {}

abstract class NeededProductProvider implements VoidEventSource {
  Future<void> setNeeded(String houseId, String productId, bool needed) async {
    final database = AppDatabaseSingleton.instance;

    var existing = await (database.select(database.neededProducts)
          ..where((table) => table.houseId.equals(houseId))
          ..where((table) => table.productId.equals(productId))
          ..where((table) => table.deletedAt.isNull()))
        .getSingleOrNull();

    if (needed && existing == null) {
      await database.into(database.neededProducts).insert(NeededProductsCompanion(
        id: Value(Uuid().v7()),
        houseId: Value(houseId),
        productId: Value(productId),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ));
    } else if (!needed && existing != null) {
      await (database.update(database.neededProducts)..where((table) => table.id.equals(existing.id)))
          .write(NeededProductsCompanion(deletedAt: Value(DateTime.now().millisecondsSinceEpoch)));
    }

    notifyListeners();
  }

  Future<bool> isNeeded(String houseId, String productId) async {
    final database = AppDatabaseSingleton.instance;
    var existing = await (database.select(database.neededProducts)
          ..where((table) => table.houseId.equals(houseId))
          ..where((table) => table.productId.equals(productId))
          ..where((table) => table.deletedAt.isNull()))
        .getSingleOrNull();
    return existing != null;
  }

  Future<Set<String>> getNeededProductIds(String enviromentId, List<String> houseIds) async {
    if (houseIds.isEmpty) return {};
    final database = AppDatabaseSingleton.instance;

    var query = database.select(database.neededProducts)
      ..where((table) => table.deletedAt.isNull())
      ..where((table) => table.houseId.isIn(houseIds));

    var rows = await query.get();
    return rows.map((r) => r.productId).toSet();
  }

  Future<List<NeededProduct>> getNeededProductsForHouse(String houseId) async {
    final database = AppDatabaseSingleton.instance;
    return await (database.select(database.neededProducts)
          ..where((table) => table.houseId.equals(houseId))
          ..where((table) => table.deletedAt.isNull()))
        .get();
  }

  Future<List<NeededProduct>> getSyncNeededProductList(String enviromentId) async {
    final database = AppDatabaseSingleton.instance;

    var houseIds = await (database.select(database.houses)
          ..where((t) => t.enviromentId.equals(enviromentId))
          ..where((t) => t.deletedAt.isNull()))
        .get()
        .then((houses) => houses.map((h) => h.id).toList());

    if (houseIds.isEmpty) return [];

    var query = database.select(database.neededProducts);
    query.where((table) => table.houseId.isIn(houseIds));
    query.orderBy([(u) => OrderingTerm(expression: u.updatedAt, mode: OrderingMode.desc)]);
    return await query.get();
  }

  Future<void> syncAddNeededProduct(Map<String, dynamic> serialized) async {
    final database = AppDatabaseSingleton.instance;
    await database.into(database.neededProducts).insert(NeededProductsCompanion(
      id: Value(serialized["id"]),
      houseId: Value(serialized["houseId"]),
      productId: Value(serialized["productId"]),
      updatedAt: Value(serialized["updatedAt"]),
      deletedAt: Value(serialized["deletedAt"]),
    ));
    notifyListeners();
  }

  Future<void> syncSetDeleted(String id, int deletedAt) async {
    final database = AppDatabaseSingleton.instance;
    await (database.update(database.neededProducts)..where((table) => table.id.equals(id)))
        .write(NeededProductsCompanion(deletedAt: Value(deletedAt)));
    notifyListeners();
  }

  Future<void> syncOveride(String id, Map<String, dynamic> serialized) async {
    final database = AppDatabaseSingleton.instance;
    await (database.update(database.neededProducts)..where((table) => table.id.equals(id))).write(
      NeededProductsCompanion(
        id: Value(serialized["id"]),
        houseId: Value(serialized["houseId"]),
        productId: Value(serialized["productId"]),
        updatedAt: Value(serialized["updatedAt"]),
        deletedAt: Value(serialized["deletedAt"]),
      ),
    );
    notifyListeners();
  }
}
