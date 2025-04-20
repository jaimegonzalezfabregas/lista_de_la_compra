import 'package:flutter/material.dart';
import 'package:jhopping_list/db_singleton.dart';

class Product {
  final bool needed;
  final int id;
  final String name;

  Product({required this.id, required this.name, required this.needed});
}

class RecipesOfProduct {
  final int id;
  final String name;

  RecipesOfProduct({required this.id, required this.name});
}

class ProductProvider extends ChangeNotifier {
  List<Product> _productListPreview = [];

  Future cacheInvalidation() async {
    var db = await DbStatic.getDb();

    List<Map> results = await db.query('Products');

    await db.close();

    var ret =
        results.map((row) {
          return Product(
            id: row["id"],
            name: row["name"],
            needed: row["needed"] == "true",
          );
        }).toList();

    _productListPreview = ret;

    notifyListeners();
  }

  Future addProduct(String name, bool needed) async {
    var db = await DbStatic.getDb();

    await db.insert('Products', <String, Object?>{
      'name': name,
      'needed': needed ? "true" : "false",
    });

    await db.close();

    cacheInvalidation();
  }

  Future deleteProductById(int id) async {
    var db = await DbStatic.getDb();
    await db.delete('Products', where: "id = ?", whereArgs: [id]);

    await db.close();

    cacheInvalidation();
  }

  Future setProductNeededness(int id, bool needed) async {
    var db = await DbStatic.getDb();
    await db.update(
      "Products",
      {"needed": needed ? "true" : "false"},
      where: "id = ?",
      whereArgs: [id],
    );
    await db.close();

    cacheInvalidation();
  }

  Future setProductName(int id, String name) async {
    var db = await DbStatic.getDb();
    await db.update(
      "Products",
      {"name": name},
      where: "id = ?",
      whereArgs: [id],
    );
    await db.close();

    cacheInvalidation();
  }

  Product? getProductById(int id) {
    if (_productListPreview.any((p) => p.id == id)) {
      return _productListPreview.firstWhere((p) => p.id == id);
    }

    return null;
  }

  List<Product> getProductList() {
    return _productListPreview;
  }

  Future<List<RecipesOfProduct>> getRecepiesOfProductById(int productId) async {
    // Get the database instance.
    final db = await DbStatic.getDb();

    try {
      // Query to select recipes related to the given productId using a JOIN.
      final results = await db.rawQuery(
        '''
      SELECT r.id, r.name
      FROM RecipeProduct rp
      JOIN Recipes r ON rp.recipe_id = r.id
      WHERE rp.product_id = ?
      ''',
        [productId],
      );

      // Map the query results to a list of RecipesOfProduct.
      return results.map((row) {
        return RecipesOfProduct(
          id: row['id'] as int,
          name: row['name'] as String,
        );
      }).toList();
    } catch (e) {
      // Handle errors or rethrow.
      rethrow;
    } finally {
      // Adjust database closure according to your app's connection management.
      await db.close();
    }
  }
}
