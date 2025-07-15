import 'package:drift/drift.dart';
import 'package:lista_de_la_compra_http_server/src/db/product_model.dart';
import 'package:uuid/uuid.dart';

import 'enviroments.dart';

class Recipes extends Table {
  TextColumn get id => text().clientDefault(() => Uuid().v7())();
  TextColumn get name => text().unique()();
  IntColumn get updatedAt => integer().clientDefault(() => DateTime.now().millisecondsSinceEpoch)();
  IntColumn get deletedAt => integer().nullable()();
  TextColumn get enviromentId => text().references(Enviroments, #id)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class RecipeProducts extends Table {
  TextColumn get id => text().clientDefault(() => Uuid().v7())();
  TextColumn get recipeId => text().references(Recipes, #id)();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get amount => text()();
  IntColumn get updatedAt => integer().clientDefault(() => DateTime.now().millisecondsSinceEpoch)();
  IntColumn get deletedAt => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
