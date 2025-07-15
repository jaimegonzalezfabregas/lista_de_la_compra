import 'package:drift/drift.dart';
import './recipe_model.dart';
import 'package:uuid/uuid.dart';

class ScheduleEntries extends Table {
  TextColumn get id => text().clientDefault(() => Uuid().v7())();
  IntColumn get week => integer()();
  IntColumn get day => integer()();
  TextColumn get recipeId => text().references(Recipes, #id)();
  IntColumn get updatedAt => integer().clientDefault(() => DateTime.now().millisecondsSinceEpoch)();
  IntColumn get deletedAt => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
