import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/db/database.dart';
import 'package:uuid/uuid.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

class ProductProvider extends ChangeNotifier {
  Future<String> addProduct(String rawName, bool needed, String enviromentId) async {
    final database = AppDatabaseSingleton.instance;

    String id = Uuid().v7();

    String name = rawName.trim().capitalize();

    database
        .into(database.products)
        .insert(
          ProductsCompanion(
            id : Value(id),
            name: Value(name),
            needed: Value(needed),
            enviromentId: Value(enviromentId),
            updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
          ),
        );
    notifyListeners();

    return id;
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
            enviromentId: Value(serializedProduct["enviromentId"]),
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

    // check it there is a difference

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

  Future<List<Product>> getDisplayProductList(String enviromentId) async {
    final database = AppDatabaseSingleton.instance;

    return await (database.select(database.products)
          ..where((table) => table.deletedAt.isNull())
          ..where((table) => table.enviromentId.equals(enviromentId)))
        .get();
  }

  Future<List<Product>> getSyncProductList(String enviromentId) async {
    final database = AppDatabaseSingleton.instance;

    var query = database.select(database.products);
    query.where((table) => table.enviromentId.equals(enviromentId));
    query.orderBy([(u) => OrderingTerm(expression: u.updatedAt, mode: OrderingMode.desc)]);

    return await query.get();
  }
}
