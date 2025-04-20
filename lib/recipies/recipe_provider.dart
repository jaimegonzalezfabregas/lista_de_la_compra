import 'package:flutter/material.dart';
import 'package:jhopping_list/db_singleton.dart';

class Recipe {
  final int id;
  final String name;

  const Recipe(this.id, this.name);
}

class Ingredient {
  final int id;
  final String name;
  final String amount;

  const Ingredient({
    required this.id,
    required this.name,
    required this.amount,
  });
}

class RecipeProvider extends ChangeNotifier {
  List<Recipe> _recipeListPreview = [];

  Recipe? getRecipeById(int id) {
    if (_recipeListPreview.any((p) => p.id == id)) {
      return _recipeListPreview.firstWhere((p) => p.id == id);
    }

    return null;
  }

  Future deleteRecipeById(int id) async {
    var db = await DbStatic.getDb();
    await db.delete('Recipes', where: "id = ?", whereArgs: [id]);

    await db.close();

    cacheInvalidation();
  }

  Future cacheInvalidation() async {
    var db = await DbStatic.getDb();

    List<Map> results = await db.query('Recipes');

    await db.close();

    var ret =
        results.map((row) {
          return Recipe(row["id"], row["name"]);
        }).toList();

    _recipeListPreview = ret;

    notifyListeners();
  }

  List<Recipe> getRecipeList() {
    return _recipeListPreview;
  }

  Future addRecipe(String name) async {
    var db = await DbStatic.getDb();
    await db.insert('Recipes', <String, Object?>{'name': name});

    await db.close();

    cacheInvalidation();
  }

  Future<List<Ingredient>> getIngredientsOfRecipeById(int recipeId) async {
    final db = await DbStatic.getDb();
    var results = [];
    // Use parameterized query to avoid SQL injection.
    try {
      results = await db.rawQuery(
        '''
    SELECT *
    FROM RecipeProduct
    JOIN Products ON RecipeProduct.product_id = Products.id
    WHERE RecipeProduct.recipe_id = ?
    ''',
        [recipeId],
      );
    } catch (err) {
      print("getIngredientsOfRecipeById");
      print(err);
    } finally {
      await db.close();
    }

    // Close the database (if you wish to do so here; be sure to manage connections appropriately)

    // Map each row to a Product (assuming Product constructor accepts id, name, and needed)
    return results.map((row) {
      return Ingredient(
        id: row["id"] as int,
        name: row["name"] as String,
        amount: row["amount"] as String,
      );
    }).toList();
  }

  Future setIngrecientsOfRecipeById(
    int recipeId,
    int productId,
    bool value,
  ) async {
    final db = await DbStatic.getDb();

    try {
      if (value) {
        await db.rawInsert(
          '''
        INSERT OR IGNORE INTO RecipeProduct (recipe_id, product_id, amount)
        VALUES (?, ?, ?)
        ''',
          [recipeId, productId, ''],
        );
      } else {
        await db.rawDelete(
          '''
        DELETE FROM RecipeProduct
        WHERE recipe_id = ? AND product_id = ?
        ''',
          [recipeId, productId],
        );
      }
    } catch (e) {
      rethrow;
    } finally {
      await db.close();
      cacheInvalidation();
    }
  }

  Future<void> setIngrecientAmountOfRecipeById(
    int recipeId,
    int productId,
    String amount,
  ) async {
    // Get the database instance
    final db = await DbStatic.getDb();

    try {
      // First, attempt to update the record if it exists.
      await db.rawUpdate(
        '''
      UPDATE RecipeProduct
      SET amount = ?
      WHERE recipe_id = ? AND product_id = ?
      ''',
        [amount, recipeId, productId],
      );
    } catch (e) {
      rethrow;
    } finally {
      cacheInvalidation();
      await db.close();
    }
  }
}
