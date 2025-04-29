import 'package:drift/drift.dart';
import 'package:jhopping_list/db/product_model.dart';
import 'package:uuid/uuid.dart';

class Recipes extends Table {
  TextColumn get id => text().clientDefault(() => Uuid().v7())();
  TextColumn get name => text().unique()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class RecipeProducts extends Table {
  TextColumn get recipeId => text().references(Recipes, #id)();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get amount => text()();

  @override
  Set<Column<Object>> get primaryKey => {recipeId, productId};
}
