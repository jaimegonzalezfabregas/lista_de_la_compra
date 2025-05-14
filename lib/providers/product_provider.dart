import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:jhopping_list/db/database.dart';

class ProductProvider extends ChangeNotifier {
  Future addProduct(String name, bool needed) async {
    final database = AppDatabaseSingleton.instance;

    database
        .into(database.products)
        .insert(ProductsCompanion(name: Value(name), needed: Value(needed), updatedAt: Value(DateTime.now().millisecondsSinceEpoch)));
    notifyListeners();
  }

  Future<void> syncAddProduct(Map<String, dynamic> serializedProduct) async {
    final database = AppDatabaseSingleton.instance;

    await database
        .into(database.products)
        .insert(
          ProductsCompanion(
            id: Value(serializedProduct["id"]),
            name: Value(serializedProduct["name"]),
            needed: Value(serializedProduct["needed"]),
            updatedAt: Value(serializedProduct["updatedAt"]),
            deletedAt: Value(serializedProduct["deletedAt"]),
          ),
        );
    notifyListeners();
  }

  Future<void> syncSetDeleted(String id, int deletedAt) async {
    final database = AppDatabaseSingleton.instance;

    await (database.update(database.products)..where((table) => table.id.equals(id))).write(ProductsCompanion(deletedAt: Value(deletedAt)));
    notifyListeners();
  }

  Future<void> syncOveride(String id, Map<String, dynamic> serializedProduct) async {
    final database = AppDatabaseSingleton.instance;

    await (database.update(database.products)..where((table) => table.id.equals(id))).write(
      ProductsCompanion(
        id: Value(serializedProduct["id"]),
        name: Value(serializedProduct["name"]),
        needed: Value(serializedProduct["needed"]),
        updatedAt: Value(serializedProduct["updatedAt"]),
        deletedAt: Value(serializedProduct["deletedAt"]),
      ),
    );

    notifyListeners();
  }

  Future deleteProductById(String id) async {
    final database = AppDatabaseSingleton.instance;

    await (database.update(database.products)
      ..where((table) => table.id.equals(id))).write(ProductsCompanion(deletedAt: Value(DateTime.now().millisecondsSinceEpoch)));

    notifyListeners();
  }

  Future setProductNeededness(String id, bool needed) async {
    final database = AppDatabaseSingleton.instance;
    await (database.update(database.products)..where(
      (table) => table.id.equals(id),
    )).write(ProductsCompanion(needed: Value(needed), updatedAt: Value(DateTime.now().millisecondsSinceEpoch)));

    notifyListeners();
  }

  Future setProductName(String id, String name) async {
    final database = AppDatabaseSingleton.instance;
    await (database.update(database.products)
      ..where((table) => table.id.equals(id))).write(ProductsCompanion(name: Value(name), updatedAt: Value(DateTime.now().millisecondsSinceEpoch)));

    notifyListeners();
  }

  Future<Product?> getProductById(String id) async {
    final database = AppDatabaseSingleton.instance;

    return await (database.select(database.products)
          ..where((table) => table.id.equals(id))
          ..where((table) => table.deletedAt.isNull()))
        .getSingleOrNull();
  }

  Future<List<Product>> getDisplayProductList() async {
    final database = AppDatabaseSingleton.instance;

    return await (database.select(database.products)..where((table) => table.deletedAt.isNull())).get();
  }

  Future<List<Product>> getSyncProductList() async {
    final database = AppDatabaseSingleton.instance;

    var query = database.select(database.products);
    query.orderBy([(u) => OrderingTerm(expression: u.updatedAt, mode: OrderingMode.desc)]);

    return await query.get();
  }
}
