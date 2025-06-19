import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/db/database.dart';
import 'package:uuid/uuid.dart';

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
            enviromentId: Value(serializedRecipe["enviromentId"]),
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
        enviromentId: Value(serializedRecipe["enviromentId"]),
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

    await (database.update(database.recipeProducts)..where((table) => table.id.equals(recipeProductId))).write(
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

  Future<List<Recipe>> getDisplayRecipeList(String enviromentId) async {
    final database = AppDatabaseSingleton.instance;
    return await (database.select(database.recipes)
          ..where((table) => table.deletedAt.isNull())
          ..where((table) => table.enviromentId.equals(enviromentId)))
        .get();
  }

  Future<String> addRecipe(String name, String enviromentId) async {
    final database = AppDatabaseSingleton.instance;

    final String id = Uuid().v7();

    database
        .into(database.recipes)
        .insert(
          RecipesCompanion(
            id: Value(id),
            name: Value(name),
            enviromentId: Value(enviromentId),
            updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
          ),
        );
    notifyListeners();

    return id;
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

    Recipe? recipe =
        await (database.select(database.recipes)
              ..where((table) => table.id.equals(recipeId))
              ..where((table) => table.deletedAt.isNull()))
            .getSingleOrNull();

    if (recipe != null) {
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

  Future<List<RecipeProduct>> getSyncRecipeProductList(String enviromentId) async {
    final database = AppDatabaseSingleton.instance;

    var query = database.select(database.recipeProducts).join([
      innerJoin(database.recipes, database.recipes.id.equalsExp(database.recipeProducts.recipeId)),
    ]);
    query.where(database.recipes.enviromentId.equals(enviromentId));

    query.orderBy([OrderingTerm(expression: database.recipeProducts.updatedAt, mode: OrderingMode.desc)]);

    return await query.map((row) => row.readTable(database.recipeProducts)).get();
  }

  Future<List<Recipe>> getSyncRecipeList(String enviromentId) async {
    final database = AppDatabaseSingleton.instance;

    var query = database.select(database.recipes);

    query.where((table) => database.recipes.enviromentId.equals(enviromentId));

    query.orderBy([(u) => OrderingTerm(expression: u.updatedAt, mode: OrderingMode.desc)]);

    return await query.get();
  }

  Future<void> setRecipeName(String recipeId, String newName) async {
    final database = AppDatabaseSingleton.instance;
    await (database.update(database.recipes)..where((table) => table.id.equals(recipeId))).write(RecipesCompanion(name: Value(newName)));

    notifyListeners();
  }
}
