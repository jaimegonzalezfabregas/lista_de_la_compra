import 'package:drift/drift.dart';
import 'package:jhopping_list/db/product_model.dart';

class Recipes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
}

class RecipeProducts extends Table {
  IntColumn get recipeId => integer().references(Recipes, #id)();
  IntColumn get productId => integer().references(Products, #id)();
  TextColumn get amount => text()();
}
