
import 'package:drift/drift.dart';
import 'package:lista_de_la_compra_backend/src/db/map_tile_model.dart';
import 'environments.dart';
import 'house_model.dart';
import 'http_server_model.dart';
import 'needed_product_model.dart';
import 'product_model.dart';
import 'recipe_model.dart';
import 'schedule.dart';
import 'package:uuid/uuid.dart';
import 'supermarket_model.dart';
import 'aisle_model.dart';
import 'product_aisle_model.dart';

part 'database.g.dart';

typedef Environment = Enviroment;

@DriftDatabase(tables: [Houses, NeededProducts, MapTiles, ScheduleEntries, Products, Recipes, RecipeProducts, HttpServer, Enviroments, SuperMarkets, Aisles, ProductAisles])
class AppDatabase extends _$AppDatabase {

  AppDatabase(QueryExecutor executor) : super(executor);

  @override
  int get schemaVersion => 6;

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
      if (from < 3) {
        // create the new tables added in version 3
        await customStatement('''
          CREATE TABLE IF NOT EXISTS houses (
            id TEXT NOT NULL PRIMARY KEY,
            name TEXT NOT NULL,
            enviroment_id TEXT NOT NULL REFERENCES enviroments(id),
            updated_at INTEGER NOT NULL,
            deleted_at INTEGER
          );

          CREATE TABLE IF NOT EXISTS needed_products (
            id TEXT NOT NULL PRIMARY KEY,
            house_id TEXT NOT NULL REFERENCES houses(id),
            product_id TEXT NOT NULL REFERENCES products(id),
            updated_at INTEGER NOT NULL,
            deleted_at INTEGER
          );
        ''' );

        // Migrate existing needed products to a default house per environment
        // For each environment, create a default house named "rename_me" and
        // move all products with needed=1 into needed_products for that house.
        // We do this in raw SQL since the needed column is about to be dropped.
        await customStatement('''
          INSERT OR IGNORE INTO houses (id, name, enviroment_id, updated_at, deleted_at)
          SELECT
            'default_house_' || e.id,
            'rename_me',
            e.id,
            (SELECT COALESCE(MAX(updated_at), 0) FROM products WHERE enviroment_id = e.id AND needed = 1),
            NULL
          FROM enviroments e
          WHERE EXISTS (SELECT 1 FROM products WHERE enviroment_id = e.id AND needed = 1);
        ''' );

        await customStatement('''
          INSERT OR IGNORE INTO needed_products (id, house_id, product_id, updated_at, deleted_at)
          SELECT
            'np_' || p.id,
            'default_house_' || p.enviroment_id,
            p.id,
            p.updated_at,
            NULL
          FROM products p
          WHERE p.needed = 1;
        ''' );

        // Drop the needed column - SQLite requires recreating the table
        await customStatement('''
          CREATE TABLE IF NOT EXISTS products_new (
            id TEXT NOT NULL PRIMARY KEY,
            name TEXT NOT NULL,
            updated_at INTEGER NOT NULL,
            deleted_at INTEGER,
            enviroment_id TEXT NOT NULL REFERENCES enviroments(id)
          );

          INSERT INTO products_new (id, name, updated_at, deleted_at, enviroment_id)
          SELECT id, name, updated_at, deleted_at, enviroment_id FROM products;

          DROP TABLE products;

          ALTER TABLE products_new RENAME TO products;
        ''' );
      }
      if (from < 4) {
        await customStatement('ALTER TABLE houses ADD COLUMN color INTEGER;');
      }
      if (from < 5) {
        await customStatement('UPDATE houses SET color = ${0xFFF44336} WHERE color IS NULL;');
      }
      if (from < 6) {
        // Create a default house for environments that have schedule entries but no houses yet
        await customStatement('''
          INSERT OR IGNORE INTO houses (id, name, enviroment_id, updated_at, deleted_at, color)
          SELECT DISTINCT
            'default_house_' || r.enviroment_id,
            'rename_me',
            r.enviroment_id,
            0,
            NULL,
            0xFFF44336
          FROM schedule_entries s
          INNER JOIN recipes r ON r.id = s.recipe_id
          WHERE NOT EXISTS (
            SELECT 1 FROM houses h WHERE h.enviroment_id = r.enviroment_id
          );
        ''');

        // Add house_id as nullable first, then fill it in
        await customStatement('ALTER TABLE schedule_entries ADD COLUMN house_id TEXT REFERENCES houses(id);');

        // Point existing entries to the first house in their environment
        await customStatement('''
          UPDATE schedule_entries SET house_id = (
            SELECT h.id FROM houses h
            INNER JOIN recipes r ON r.id = schedule_entries.recipe_id
            WHERE h.enviroment_id = r.enviroment_id
            LIMIT 1
          ) WHERE house_id IS NULL;
        ''');
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
