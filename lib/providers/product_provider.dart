import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:jhopping_list/db/database.dart';

class ProductProvider extends ChangeNotifier {
  Future addProduct(String name, bool needed) async {
    final database = AppDatabaseSingleton.instance;

    database.into(database.products).insert(ProductsCompanion(name: Value(name), needed: Value(needed)));
    notifyListeners();
  }

  Future deleteProductById(String id) async {
    final database = AppDatabaseSingleton.instance;

    await (database.delete(database.products)..where((table) => table.id.equals(id))).go();
  }

  Future setProductNeededness(String id, bool needed) async {
    final database = AppDatabaseSingleton.instance;
    await (database.update(database.products)..where((table) => table.id.equals(id))).write(ProductsCompanion(needed: Value(needed)));

    notifyListeners();
  }

  Future setProductName(String id, String name) async {
    final database = AppDatabaseSingleton.instance;
    await (database.update(database.products)..where((table) => table.id.equals(id))).write(ProductsCompanion(name: Value(name)));

    notifyListeners();
  }

  Future<Product?> getProductById(String id) async {
    final database = AppDatabaseSingleton.instance;

    return await (database.select(database.products)..where((table) => table.id.equals(id))).getSingleOrNull();
  }

  Future<List<Product>> getProductList() async {
    final database = AppDatabaseSingleton.instance;

    return await database.select(database.products).get();
  }

  
}
