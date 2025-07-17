import 'dart:io';

import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

import './schedule.dart';
import './product_model.dart';
import './recipe_model.dart';
import './enviroments.dart';
import 'package:drift/drift.dart';
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
/*
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
 */

  static QueryExecutor _openConnection() {
    return NativeDatabase.createInBackground(File('/home/alvaro/repos/lista_de_la_compra/~/.lista_de_la_compra/db/persistence.sqlite'));
  }



}

class AppDatabaseSingleton {
  static final AppDatabase _instance = AppDatabase();

  static AppDatabase get instance => _instance;

  AppDatabaseSingleton._();
}
