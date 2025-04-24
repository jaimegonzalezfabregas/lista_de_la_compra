import 'package:drift/drift.dart';
import 'package:jhopping_list/db/recipe_model.dart';

class Schedule extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get week => integer()();
  IntColumn get day => integer()();
  IntColumn get recipeId => integer().references(Recipes, #id)();
}
