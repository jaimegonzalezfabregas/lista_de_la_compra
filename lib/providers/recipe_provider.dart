import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:jhopping_list/db/database.dart';

class RecipeProvider extends ChangeNotifier {
  Future<Recipe?> getRecipeById(String id) async {
    final database = AppDatabaseSingleton.instance;

    return await (database.select(database.recipes)
          ..where((table) => table.id.equals(id))
          ..where((table) => table.deletedAt.isNull()))
        .getSingleOrNull();
  }

  Future<void> syncAddRecipe(Map<String, dynamic> serializedRecipe) async {
    final database = AppDatabaseSingleton.instance;

    database
        .into(database.recipes)
        .insert(
          RecipesCompanion(
            id: Value(serializedRecipe["id"]),
            name: Value(serializedRecipe["name"]),
            updatedAt: Value(serializedRecipe["updatedAt"]),
            deletedAt: Value(serializedRecipe["deletedAt"]),
          ),
        );
    notifyListeners();
  }

  Future<void> syncSetDeletedRecipe(String id, int? deletedAt) async {
    final database = AppDatabaseSingleton.instance;

    await (database.update(database.recipes)..where((table) => table.id.equals(id))).write(RecipesCompanion(deletedAt: Value(deletedAt)));
    notifyListeners();
  }

  Future<void> syncOverideRecipe(String id, Map<String, dynamic> serializedRecipe) async {
    final database = AppDatabaseSingleton.instance;

    await (database.update(database.recipes)..where((table) => table.id.equals(id))).write(
      RecipesCompanion(
        id: Value(serializedRecipe["id"]),
        name: Value(serializedRecipe["name"]),
        updatedAt: Value(serializedRecipe["updatedAt"]),
        deletedAt: Value(serializedRecipe["deletedAt"]),
      ),
    );
    notifyListeners();
  }

  Future<void> syncSetDeletedRecipeProduct(String recipeProductId, int? deletedAt) async {
    final database = AppDatabaseSingleton.instance;

    await (database.update(database.recipeProducts)
      ..where((table) => table.id.equals(recipeProductId))).write(RecipeProductsCompanion(deletedAt: Value(deletedAt)));
    notifyListeners();
  }

  Future<void> syncOverideRecipeProduct(String recipeProductId, Map<String, dynamic> serializedRecipeProduct) async {
    final database = AppDatabaseSingleton.instance;

    await (database.update(database.recipeProducts)..where((table) => table.recipeId.equals(recipeProductId))).write(
      RecipeProductsCompanion(
        id: Value(serializedRecipeProduct["id"]),
        recipeId: Value(serializedRecipeProduct["recipeId"]),
        productId: Value(serializedRecipeProduct["productId"]),
        amount: Value(serializedRecipeProduct["amount"]),
        updatedAt: Value(serializedRecipeProduct["updatedAt"]),
        deletedAt: Value(serializedRecipeProduct["deletedAt"]),
      ),
    );
    notifyListeners();
  }

  Future<void> syncAddRecipeProduct(Map<String, dynamic> serializedRecipeProduct) async {
    final database = AppDatabaseSingleton.instance;

    database
        .into(database.recipeProducts)
        .insert(
          RecipeProductsCompanion(
            id: Value(serializedRecipeProduct["id"]),
            recipeId: Value(serializedRecipeProduct["recipeId"]),
            productId: Value(serializedRecipeProduct["productId"]),
            amount: Value(serializedRecipeProduct["amount"]),
            updatedAt: Value(serializedRecipeProduct["updatedAt"]),
            deletedAt: Value(serializedRecipeProduct["deletedAt"]),
          ),
        );
    notifyListeners();
  }

  Future deleteRecipeById(String id) async {
    final database = AppDatabaseSingleton.instance;

    await (database.update(database.recipes)
      ..where((table) => table.id.equals(id))).write(RecipesCompanion(deletedAt: Value(DateTime.now().millisecondsSinceEpoch)));

    notifyListeners();
  }

  Future<List<Recipe>> getDisplayRecipeList() async {
    final database = AppDatabaseSingleton.instance;
    return await (database.select(database.recipes)..where((table) => table.deletedAt.isNull())).get();
  }

  Future addRecipe(String name) async {
    final database = AppDatabaseSingleton.instance;

    database.into(database.recipes).insert(RecipesCompanion(name: Value(name), updatedAt: Value(DateTime.now().millisecondsSinceEpoch)));
    notifyListeners();
  }

  Future<List<(RecipeProduct, Product)>> getProductsOfRecipeById(String recipeId) async {
    final database = AppDatabaseSingleton.instance;

    var query = (database.select(database.recipeProducts)
          ..where((table) => table.recipeId.equals(recipeId))
          ..where((table) => table.deletedAt.isNull()))
        .join([innerJoin(database.products, database.products.id.equalsExp(database.recipeProducts.productId))]);

    query.where(database.products.deletedAt.isNull());

    return await query.map((row) => (row.readTable(database.recipeProducts), row.readTable(database.products))).get();
  }

  Future setIngredientOfRecipeById(String recipeId, String productId, bool value) async {
    final database = AppDatabaseSingleton.instance;

    Recipe recipe =
        await (database.select(database.recipes)
              ..where((table) => table.id.equals(recipeId))
              ..where((table) => table.deletedAt.isNull()))
            .getSingle();

    if (value) {
      await database
          .into(database.recipeProducts)
          .insert(
            RecipeProductsCompanion(
              recipeId: Value(recipeId),
              productId: Value(productId),
              amount: Value("como para un(a) ${recipe.name}"),
              updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
            ),
          );
    } else {
      await (database.update(database.recipeProducts)..where(
        (table) => table.recipeId.equals(recipeId) & table.productId.equals(productId),
      )).write(RecipeProductsCompanion(deletedAt: Value(DateTime.now().millisecondsSinceEpoch)));
    }

    notifyListeners();
  }

  Future<List<(RecipeProduct, Recipe)>> getRecepiesOfProductById(String productId) async {
    final database = AppDatabaseSingleton.instance;
    var query = (database.select(database.recipeProducts)..where((table) => table.productId.equals(productId))).join([
      innerJoin(database.products, database.products.id.equalsExp(database.recipeProducts.productId)),
      innerJoin(database.recipes, database.recipes.id.equalsExp(database.recipeProducts.recipeId)),
    ]);

    query.where(database.products.deletedAt.isNull());
    query.where(database.recipes.deletedAt.isNull());
    query.where(database.recipeProducts.deletedAt.isNull());

    return query.map((row) => (row.readTable(database.recipeProducts), row.readTable(database.recipes))).get();
  }

  Future<void> setIngredientAmountOfRecipeById(String recipeId, String productId, String amount) async {
    final database = AppDatabaseSingleton.instance;
    await (database.update(database.recipeProducts)..where(
      (table) => table.recipeId.equals(recipeId) & table.productId.equals(productId),
    )).write(RecipeProductsCompanion(amount: Value(amount), updatedAt: Value(DateTime.now().millisecondsSinceEpoch)));

    notifyListeners();
  }

  Future<List<RecipeProduct>> getDisplayRecipeProductList() async {
    final database = AppDatabaseSingleton.instance;

    return await (database.select(database.recipeProducts)..where((table) => table.deletedAt.isNull())).get();
  }

  Future<List<RecipeProduct>> getSyncRecipeProductList() async {
    final database = AppDatabaseSingleton.instance;

    var query = database.select(database.recipeProducts);
    query.orderBy([(u) => OrderingTerm(expression: u.updatedAt, mode: OrderingMode.desc)]);

    return await query.get();
  }

  Future<List<Recipe>> getSyncRecipeList() async {
    final database = AppDatabaseSingleton.instance;

    var query = database.select(database.recipes);
    query.orderBy([(u) => OrderingTerm(expression: u.updatedAt, mode: OrderingMode.desc)]);

    return await query.get();
  }

  // TODO change recipe name
}
