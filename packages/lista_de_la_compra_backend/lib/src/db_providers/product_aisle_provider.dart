import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../lista_de_la_compra_backend.dart';


class RamProductAisleProvider extends ProductAisleProvider with VoidEventSourceMixin {}

abstract class ProductAisleProvider implements VoidEventSource {
  Future<void> syncAddProductAisle(Map<String, dynamic> serialized) async {
    final database = AppDatabaseSingleton.instance;

    await database.into(database.productAisles).insert(
      ProductAislesCompanion(
        id: Value(serialized["id"]),
        productId: Value(serialized["productId"]),
        aisleId: Value(serialized["aisleId"]),
        updatedAt: Value(serialized["updatedAt"]),
        deletedAt: Value(serialized["deletedAt"]),
        enviromentId: Value(serialized["enviromentId"]),
      ),
    );

    notifyListeners();
  }

  Future<void> syncSetDeletedProductAisle(String id, int? deletedAt) async {
    final database = AppDatabaseSingleton.instance;

    await (database.update(database.productAisles)..where((tbl) => tbl.id.equals(id))).write(ProductAislesCompanion(deletedAt: Value(deletedAt)));
    notifyListeners();
  }

  Future<void> syncOverideProductAisle(String id, Map<String, dynamic> serialized) async {
    final database = AppDatabaseSingleton.instance;

    await (database.update(database.productAisles)..where((tbl) => tbl.id.equals(id))).write(
      ProductAislesCompanion(
        id: Value(serialized["id"]),
        productId: Value(serialized["productId"]),
        aisleId: Value(serialized["aisleId"]),
        updatedAt: Value(serialized["updatedAt"]),
        deletedAt: Value(serialized["deletedAt"]),
        enviromentId: Value(serialized["enviromentId"]),
      ),
    );

    notifyListeners();
  }

  Future<List<ProductAisle>> getDisplayProductAisleList(String enviromentId) async {
    final database = AppDatabaseSingleton.instance;

    return await (database.select(database.productAisles)
          ..where((t) => t.deletedAt.isNull())
          ..where((t) => t.enviromentId.equals(enviromentId)))
        .get();
  }

  Future<List<ProductAisle>> getSyncProductAisleList(String enviromentId) async {
    final database = AppDatabaseSingleton.instance;

    var q = database.select(database.productAisles);
    q.where((t) => t.enviromentId.equals(enviromentId));
    q.orderBy([(u) => OrderingTerm(expression: u.updatedAt, mode: OrderingMode.desc)]);

    return await q.get();
  }

  Future<String> addProductAisle(String productId, String aisleId, String enviromentId) async {
    final database = AppDatabaseSingleton.instance;
    final String id = Uuid().v7();

    await database.into(database.productAisles).insert(
          ProductAislesCompanion(
            id: Value(id),
            productId: Value(productId),
            aisleId: Value(aisleId),
            enviromentId: Value(enviromentId),
            updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
          ),
        );

    notifyListeners();
    return id;
  }
}
