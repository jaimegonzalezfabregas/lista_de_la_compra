import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:jhopping_list/db/enviroments.dart';
import 'package:jhopping_list/db/remote_terminals_model.dart';
import 'package:jhopping_list/db/product_model.dart';
import 'package:jhopping_list/db/recipe_model.dart';
import 'package:jhopping_list/db/schedule.dart';
import 'package:uuid/uuid.dart';

part 'database.g.dart';

@DriftDatabase(tables: [ScheduleEntries, Products, Recipes, RecipeProducts, RemoteTerminals, Enviroments, RemoteTerminalEnviroments])
class AppDatabase extends _$AppDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/setup/
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'persistence', native: const DriftNativeOptions());
  }
}

class AppDatabaseSingleton {
  static final AppDatabase _instance = AppDatabase();

  static AppDatabase get instance => _instance;

  AppDatabaseSingleton._();
}
