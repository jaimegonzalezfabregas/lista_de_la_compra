import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:jopping_list/product.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class AppPersistence extends ChangeNotifier {
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
      "databases",
      "persistence.db",
    );

    return await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (Database db, int _) async {
          await db.execute(
            'CREATE TABLE Product (id INTEGER PRIMARY KEY, name TEXT, needed BOOLEAN)',
          );
        },
      ),
    );
  }

  
  Future  cacheInvalidation() async {
    await updateProductListCache();
    notifyListeners();
  }

  Future addProduct(name, needed) async {
    // Init ffi loader if needed.
    var db = await getDb();
    await db.insert('Product', <String, Object?>{
      'name': name,
      'needed': needed ? "true" : "false",
    });
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

  List<Product>? productListPreview;

  Future updateProductListCache() async {
    var db = await getDb();

    List<Map> results = await db.query('Product');

    await db.close();

    var ret =
        results.map((row) {
          return Product(row["id"], row["name"], row["needed"] == "true");
        }).toList();

    productListPreview = ret;
  }

  List<Product>? getProductList() {
    return productListPreview;
  }
}
