import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:lista_de_la_compra/db/enviroments.dart';
import 'package:lista_de_la_compra/db/http_server_model.dart';
import 'package:lista_de_la_compra/db/product_model.dart';
import 'package:lista_de_la_compra/db/recipe_model.dart';
import 'package:lista_de_la_compra/db/schedule.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

part 'database.g.dart';

@DriftDatabase(tables: [ScheduleEntries, Products, Recipes, RecipeProducts, HttpServer, Enviroments])
class AppDatabase extends _$AppDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/setup/
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {



    return driftDatabase(
      name: 'persistence',
      native: DriftNativeOptions(

        databaseDirectory: () async { 
          try{
            return await getApplicationDocumentsDirectory();
          }catch(err){
            return  "~/.lista_de_la_compra/db/";
          }
         },
        tempDirectoryPath: () async {
          try {
            return await getTemporaryDirectory().then((d) => d.path);
          } catch (err) {
            return "~/.lista_de_la_compra/tmp/";
          }
        },
      ),
    );
  }
}

class AppDatabaseSingleton {
  static final AppDatabase _instance = AppDatabase();

  static AppDatabase get instance => _instance;

  AppDatabaseSingleton._();
}
