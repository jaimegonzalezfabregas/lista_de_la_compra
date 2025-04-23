import 'dart:io' as io;

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DbStatic {
  static bool inited = false;

  static Future<Database> getDb() async {
    if (!inited) {
      inited = true;
      sqfliteFfiInit();
    }
    var databaseFactory = databaseFactoryFfi;

    final io.Directory appDocumentsDir =
        await getApplicationDocumentsDirectory();
    String dbPath = path.join(
      appDocumentsDir.path,
      "JhoppingList",
      "persistence.db",
    );

    return await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (Database db, int _) async {
          await db.execute(
            'CREATE TABLE Products (id INTEGER PRIMARY KEY, name TEXT UNIQUE, needed BOOLEAN)',
          );

          await db.execute(
            'CREATE TABLE Recipes (id INTEGER PRIMARY KEY, name TEXT UNIQUE)',
          );

          await db.execute("""
CREATE TABLE RecipeProduct (
  product_id INTEGER, 
  recipe_id INTEGER, 
  amount VARCHAR, 
  PRIMARY KEY (product_id, recipe_id)
  FOREIGN KEY (product_id) REFERENCES Products(id), 
  FOREIGN KEY (recipe_id) REFERENCES Recipes(id)
)""");

          await db.execute("""
CREATE TABLE Schedule (
  id INTEGER PRIMARY KEY, 
  week INTEGER, 
  day INTEGER, 
  recipe_id INTEGER, 
  FOREIGN KEY (recipe_id) REFERENCES Recipes(id)
)
""");
        },
      ),
    );
  }
}
