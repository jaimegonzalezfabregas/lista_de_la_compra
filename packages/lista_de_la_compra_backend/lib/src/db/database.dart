
import 'package:drift/drift.dart';
import 'environments.dart';
import 'http_server_model.dart';
import 'product_model.dart';
import 'recipe_model.dart';
import 'schedule.dart';
import 'package:uuid/uuid.dart';

part 'database.g.dart';

typedef Environment = Enviroment;

@DriftDatabase(tables: [ScheduleEntries, Products, Recipes, RecipeProducts, HttpServer, Enviroments])
class AppDatabase extends _$AppDatabase {

  AppDatabase(QueryExecutor executor) : super(executor);

  @override
  int get schemaVersion => 1;
}

class AppDatabaseSingleton {
  static AppDatabase? _instance = null;

  static AppDatabase get instance => _instance!;

  static setQueryExecutor(QueryExecutor queryExecutor) {
    _instance = AppDatabase(queryExecutor);
  }

  AppDatabaseSingleton._();
}
