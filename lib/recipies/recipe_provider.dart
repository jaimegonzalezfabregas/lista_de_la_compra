import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:jhopping_list/db/database.dart';

class RecipeProvider extends ChangeNotifier {
  Future<Recipe?> getRecipeById(int id) async {
    final database = AppDatabaseSingleton.instance;

    return await (database.select(database.recipes)
      ..where((table) => table.id.equals(id))).getSingleOrNull();
  }

  Future deleteRecipeById(int id) async {
    final database = AppDatabaseSingleton.instance;

    await (database.delete(database.recipes)
      ..where((table) => table.id.equals(id))).go();

    notifyListeners();
  }

  Future<List<Recipe>> getRecipeList() async {
    final database = AppDatabaseSingleton.instance;
    return await database.select(database.recipes).get();
  }

  Future addRecipe(String name) async {
    final database = AppDatabaseSingleton.instance;

    database.into(database.recipes).insert(RecipesCompanion(name: Value(name)));
    notifyListeners();
  }

  Future<List<(RecipeProduct, Product)>> getProductsOfRecipeById(
    int recipeId,
  ) async {
    final database = AppDatabaseSingleton.instance;

    return await (database.select(database.recipeProducts)
          ..where((table) => table.recipeId.equals(recipeId)))
        .join([
          innerJoin(
            database.products,
            database.products.id.equalsExp(database.recipeProducts.productId),
          ),
        ])
        .map(
          (row) => (
            row.readTable(database.recipeProducts),
            row.readTable(database.products),
          ),
        )
        .get();
  }

  Future setIngredientOfRecipeById(
    int recipeId,
    int productId,
    bool value,
  ) async {
    final database = AppDatabaseSingleton.instance;

    if (value) {
      await database
          .into(database.recipeProducts)
          .insert(
            RecipeProductsCompanion(
              recipeId: Value(recipeId),
              productId: Value(productId),
              amount: Value("sin definir"),
            ),
          );
    } else {
      await (database.delete(database.recipeProducts)..where(
        (table) =>
            table.recipeId.equals(recipeId) & table.productId.equals(productId),
      )).go();
    }

    notifyListeners();
  }

  Future<void> setIngredientAmountOfRecipeById(
    int recipeId,
    int productId,
    String amount,
  ) async {

    final database = AppDatabaseSingleton.instance;
    await (database.update(database.recipeProducts)..where(
      (table) =>
          table.recipeId.equals(recipeId) & table.productId.equals(productId),
    )).write(RecipeProductsCompanion(amount: Value(amount)));

    notifyListeners();
  }
}
