import 'dart:io';

// https://stackoverflow.com/questions/78626240/flutter-drift-for-the-web-unsupported-operation-unsupported-invalid-type-invali
import 'package:drift/backends.dart';
import 'package:drift/native.dart';
import 'package:lista_de_la_compra_backend/src/db/database.dart';
import 'package:lista_de_la_compra_backend/src/db_providers/aisle_provider.dart';
import 'package:lista_de_la_compra_backend/src/db_providers/product_aisle_provider.dart';
import 'package:lista_de_la_compra_backend/src/db_providers/supermarket_provider.dart';

import 'src/db_providers/environment_provider.dart';

import 'src/db_providers/http_server_provider.dart';
import 'src/db_providers/http_server_state_provider.dart';
import 'src/db_providers/product_provider.dart';
import 'src/db_providers/recipe_provider.dart';
import 'src/db_providers/schedule_provider.dart';
import 'src/shared_preferences_providers/ram_shared_preferences_provider.dart';
import 'src/sync/http_server_manager.dart';
import 'src/sync/open_conection_provider.dart';
import 'src/sync/open_connection_manager.dart';
import 'src/sqlite_db/sqlite_db.dart';


Future main() async {
  runServer();
}

Future runServer() async {
  QueryExecutor executor = createUnderlyingDatabaseConnection();
  AppDatabaseSingleton.setQueryExecutor(executor);

  final environmentProvider = RamEnvironmentProvider();
  final recipeProvider = RamRecipeProvider();
  final productProvider = RamProductProvider();
  final scheduleProvider = RamScheduleProvider();
  final httpServerProvider = RamHttpServerProvider();
  final sharedPreferencesProvider = RamSharedPreferencesProvider();
  final openConnectionProvider = RamOpenConnectionProvider();
  final supermarketProvider = RamSuperMarketProvider();
  final aisleProvider = RamAisleProvider();
  final productAisleProvider = RamProductAisleProvider();

  final OpenConnectionManager openConnectionManager = OpenConnectionManager(
    openConnectionProvider,
    productProvider,
    recipeProvider,
    scheduleProvider,
    sharedPreferencesProvider,
    environmentProvider,
    supermarketProvider,
    aisleProvider,
    productAisleProvider,

    downloadAllEnvironments: true,
  );

  final httpServerManager = HttpServerManager(httpServerProvider, openConnectionManager);

  final httpServerStateProvider = RamHttpServerStateProvider(httpServerManager, sharedPreferencesProvider);

  httpServerStateProvider.tryStartServer();

  while (true) {
    String? err = httpServerStateProvider.getServerError();
    if (err != null) {
      print(err);
      httpServerStateProvider.tryStartServer();
    }

    await Future.delayed(Duration(seconds: 5));
  }
}
