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
      ),
    );

    notifyListeners();
  }

  Future<List<ProductAisle>> getDisplayProductAisleList(String enviromentId) async {
    final database = AppDatabaseSingleton.instance;
    // Join ProductAisles -> Aisles -> SuperMarkets and filter by the SuperMarket.enviromentId
    final joined = database.select(database.productAisles).join([
      innerJoin(database.aisles, database.aisles.id.equalsExp(database.productAisles.aisleId)),
      innerJoin(database.superMarkets, database.superMarkets.id.equalsExp(database.aisles.marketId)),
    ]);

    // Only non-deleted product-aisles, and supermarket must belong to requested environment
    joined.where(database.productAisles.deletedAt.isNull());
    joined.where(database.superMarkets.enviromentId.equals(enviromentId));

    final rows = await joined.get();
    return rows.map((r) => r.readTable(database.productAisles)).toList();
  }

  Future<List<ProductAisle>> getSyncProductAisleList(String enviromentId) async {
    final database = AppDatabaseSingleton.instance;
    // Join ProductAisles -> Aisles -> SuperMarkets and filter by the SuperMarket.enviromentId
    final joined = database.select(database.productAisles).join([
      innerJoin(database.aisles, database.aisles.id.equalsExp(database.productAisles.aisleId)),
      innerJoin(database.superMarkets, database.superMarkets.id.equalsExp(database.aisles.marketId)),
    ]);

    joined.where(database.superMarkets.enviromentId.equals(enviromentId));
    joined.orderBy([OrderingTerm(expression: database.productAisles.updatedAt, mode: OrderingMode.desc)]);

    final rows = await joined.get();
    return rows.map((r) => r.readTable(database.productAisles)).toList();
  }

  Future<String> addProductAisle(String productId, String aisleId, String enviromentId) async {
    final database = AppDatabaseSingleton.instance;
    final String id = Uuid().v7();

    // Ensure product exists and is not deleted
    final product = await (database.select(database.products)
          ..where((p) => p.id.equals(productId))
          ..where((p) => p.deletedAt.isNull()))
        .getSingleOrNull();

    if (product == null) {
      throw Exception('Product not found or deleted');
    }

    // Load aisle and its supermarket to check environment
    final joined = database.select(database.aisles).join([
      innerJoin(database.superMarkets, database.superMarkets.id.equalsExp(database.aisles.marketId)),
    ])..where(database.aisles.id.equals(aisleId));

    final rows = await joined.get();
    if (rows.isEmpty) {
      throw Exception('Aisle not found');
    }

  final supermarket = rows.first.readTable(database.superMarkets);

    // Verify supermarket environment matches product environment
    if (supermarket.enviromentId != product.enviromentId) {
      throw Exception('Aisle marketplace environment (${supermarket.enviromentId}) does not match product environment (${product.enviromentId})');
    }

    await database.into(database.productAisles).insert(
          ProductAislesCompanion(
            id: Value(id),
            productId: Value(productId),
            aisleId: Value(aisleId),
            updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
          ),
        );

    notifyListeners();
    return id;
  }

  Future<List<Product>> getProductsByAisle(String aisleId) async {
    final database = AppDatabaseSingleton.instance;

    final query = database.select(database.productAisles).join([
      innerJoin(database.products, database.products.id.equalsExp(database.productAisles.productId)),
    ]);

    query.where(database.productAisles.aisleId.equals(aisleId));
    query.where(database.productAisles.deletedAt.isNull());
    query.where(database.products.deletedAt.isNull());

    final rows = await query.get();
    return rows.map((r) => r.readTable(database.products)).toList();
  }

  /// Add or remove a product from an aisle.
  /// If [present] is true, this will create a ProductAisle entry (respecting environment checks).
  /// If [present] is false, this will mark existing ProductAisle rows as deleted.
  Future<void> setProductInAisle(String productId, String aisleId, bool present) async {
    final database = AppDatabaseSingleton.instance;

    if (present) {
      // Need product env id to call addProductAisle
      final product = await (database.select(database.products)
            ..where((p) => p.id.equals(productId))
            ..where((p) => p.deletedAt.isNull()))
          .getSingleOrNull();

      if (product == null) {
        throw Exception('Product not found or deleted');
      }

      await addProductAisle(productId, aisleId, product.enviromentId);
      return;
    }

    // Mark any existing non-deleted ProductAisle rows as deleted
    final existing = await (database.select(database.productAisles)
          ..where((pa) => pa.productId.equals(productId))
          ..where((pa) => pa.aisleId.equals(aisleId))
          ..where((pa) => pa.deletedAt.isNull()))
        .get();

    final now = DateTime.now().millisecondsSinceEpoch;
    for (final row in existing) {
      await (database.update(database.productAisles)..where((tbl) => tbl.id.equals(row.id)))
          .write(ProductAislesCompanion(deletedAt: Value(now)));
    }

    notifyListeners();
  }
}
