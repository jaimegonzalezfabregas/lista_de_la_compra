import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:jhopping_list/common/Product.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class AppState extends ChangeNotifier {
  static bool inited = false;

  Future<Database> getDb() async {
    if (!inited) {
      inited = true;
      sqfliteFfiInit();
    }
    var databaseFactory = databaseFactoryFfi;

    final io.Directory appDocumentsDir =
        await getApplicationDocumentsDirectory();
    String dbPath = path.join(
      appDocumentsDir.path,
      "JhoppingList",
      "persistence.db",
    );

    return await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (Database db, int _) async {
          await db.execute(
            'CREATE TABLE Product (id INTEGER PRIMARY KEY, name TEXT UNIQUE, needed BOOLEAN)',
          );
        },
      ),
    );
  }

  Future cacheInvalidation() async {
    await updateProductListCache();
    notifyListeners();
  }

  Future addProduct(String name, bool needed) async {
    // Init ffi loader if needed.
    var db = await getDb();
    try {
      await db.insert('Product', <String, Object?>{
        'name': name,
        'needed': needed ? "true" : "false",
      });
    } catch (err) {
      print(err);
    }
    await db.close();

    cacheInvalidation();
  }

  Future setProductNeededness(int id, bool needed) async {
    var db = await getDb();
    await db.update(
      "Product",
      {"needed": needed ? "true" : "false"},
      where: "id = ?",
      whereArgs: [id],
    );
    await db.close();

    cacheInvalidation();
  }

  List<Product>? _productListPreview;

  Future updateProductListCache() async {
    var db = await getDb();

    List<Map> results = await db.query('Product');

    await db.close();

    var ret =
        results.map((row) {
          return Product(row["id"], row["name"], row["needed"] == "true");
        }).toList();

    _productListPreview = ret;
  }

  List<Product>? getProductList() {
    return _productListPreview;
  }

  String _productFilter = "";

  void setProductFilter(String filter) {
    _productFilter = filter;
    notifyListeners();
  }

  String getProductFilter() {
    return _productFilter;
  }
}
