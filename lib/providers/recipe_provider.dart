import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:jhopping_list/db/database.dart';

class RecipeProvider extends ChangeNotifier {
  Future<Recipe?> getRecipeById(String id) async {
    final database = AppDatabaseSingleton.instance;

    return await (database.select(database.recipes)
      ..where((table) => table.id.equals(id))).getSingleOrNull();
  }

  Future deleteRecipeById(String id) async {
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
    String recipeId,
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
    String recipeId,
    String productId,
    bool value,
  ) async {
    final database = AppDatabaseSingleton.instance;

    Recipe recipe = await (database.select(database.recipes)
          ..where((table) => table.id.equals(recipeId)))
        .getSingle();

    if (value) {
      await database
          .into(database.recipeProducts)
          .insert(
            RecipeProductsCompanion(
              recipeId: Value(recipeId),
              productId: Value(productId),
              amount: Value("como para un(a) ${recipe.name}"),
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

  Future<List<(RecipeProduct, Recipe)>> getRecepiesOfProductById(String productId) async {
    final database = AppDatabaseSingleton.instance;
    return await (database.select(database.recipeProducts)..where((table) => table.productId.equals(productId)))
        .join([
          innerJoin(database.products, database.products.id.equalsExp(database.recipeProducts.productId)),
          innerJoin(database.recipes, database.recipes.id.equalsExp(database.recipeProducts.recipeId)),
        ])
        .map((row) => (row.readTable(database.recipeProducts), row.readTable(database.recipes)))
        .get();
  }

  Future<void> setIngredientAmountOfRecipeById(
    String recipeId,
    String productId,
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
