
import 'package:drift/drift.dart';
import 'environments.dart';
import 'http_server_model.dart';
import 'product_model.dart';
import 'recipe_model.dart';
import 'schedule.dart';
import 'package:uuid/uuid.dart';
import 'supermarket_model.dart';
import 'aisle_model.dart';
import 'product_aisle_model.dart';

part 'database.g.dart';

typedef Environment = Enviroment;

@DriftDatabase(tables: [ScheduleEntries, Products, Recipes, RecipeProducts, HttpServer, Enviroments, SuperMarkets, Aisles, ProductAisles])
class AppDatabase extends _$AppDatabase {

  AppDatabase(QueryExecutor executor) : super(executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    // onCreate will be used when the database is first created
    onCreate: (m) async {
      await m.createAll();
    },
    // onUpgrade will run when schemaVersion increases; create the new tables
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        // create the new tables added in version 2 using SQL so this runs
        // cleanly even before generated table helpers exist
        await customStatement('''
          CREATE TABLE IF NOT EXISTS super_markets (
            id TEXT NOT NULL PRIMARY KEY,
            name TEXT NOT NULL,
            updated_at INTEGER NOT NULL,
            deleted_at INTEGER,
            enviroment_id TEXT NOT NULL REFERENCES enviroments(id)
          );

          CREATE TABLE IF NOT EXISTS aisles (
            id TEXT NOT NULL PRIMARY KEY,
            name TEXT NOT NULL,
            market_id TEXT NOT NULL REFERENCES super_markets(id),
            updated_at INTEGER NOT NULL,
            deleted_at INTEGER
          );

          CREATE TABLE IF NOT EXISTS product_aisles (
            id TEXT NOT NULL PRIMARY KEY,
            product_id TEXT NOT NULL REFERENCES products(id),
            aisle_id TEXT NOT NULL REFERENCES aisles(id),
            updated_at INTEGER NOT NULL,
            deleted_at INTEGER
          );
        ''' );
      }
    },
  );
}

class AppDatabaseSingleton {
  static AppDatabase? _instance = null;

  static AppDatabase get instance => _instance!;

  static setQueryExecutor(QueryExecutor queryExecutor) {
    _instance = AppDatabase(queryExecutor);
  }

  AppDatabaseSingleton._();
}
