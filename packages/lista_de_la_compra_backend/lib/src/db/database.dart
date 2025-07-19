import 'dart:io';

import 'package:drift/native.dart';
import 'package:drift/drift.dart';
// TODO: NO SE PUEDE PONER drift_flutter AQUI, NO HAY QUE PONER DEPENDENCIAS DE FLUTTER
//import 'package:drift_flutter/drift_flutter.dart'; 
// TODO: path_provider TAMBIEN ES DE FLUTTER
//import 'package:path_provider/path_provider.dart';
import 'enviroments.dart';
import 'http_server_model.dart';
import 'product_model.dart';
import 'recipe_model.dart';
import 'schedule.dart';
import 'package:uuid/uuid.dart';
import 'dart:io' show Platform;

part 'database.g.dart';

@DriftDatabase(tables: [ScheduleEntries, Products, Recipes, RecipeProducts, HttpServer, Enviroments])
class AppDatabase extends _$AppDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/setup/

  // TODO: NO HACER EL MÉTODO _openConnection(), SINO PASAR EL QUERYEXECUTOR, PARA QUE NO HAYA DEPENDENCIAS DE FLUTTER
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  // TODO: _openConnection() en flutter era distinto, abstraer o unificar

  static QueryExecutor _openConnection() {
    // ignore: dead_code
    if (Platform.isAndroid) {
      return driftDatabase(
        name: 'persistence',
        native: DriftNativeOptions(
          databaseDirectory: () async {
            try {
              return await getApplicationDocumentsDirectory();
            } catch (err) {
              return "~/.lista_de_la_compra/db/";
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
    } else {
      // TODO take from cli
      return NativeDatabase.createInBackground(File('./persistence.sqlite'));
    }
  }
}

class AppDatabaseSingleton {
  static final AppDatabase _instance = AppDatabase();

  static AppDatabase get instance => _instance;

  AppDatabaseSingleton._();
}
