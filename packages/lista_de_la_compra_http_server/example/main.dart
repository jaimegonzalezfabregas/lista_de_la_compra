

import 'package:lista_de_la_compra_http_server/lista_de_la_compra_http_server.dart';
import 'package:lista_de_la_compra_http_server/src/db_providers/http_server_provider.dart';
import 'package:lista_de_la_compra_http_server/src/db_providers/product_provider.dart';
import 'package:lista_de_la_compra_http_server/src/db_providers/recipe_provider.dart';
import 'package:lista_de_la_compra_http_server/src/db_providers/schedule_provider.dart';

Future main() async {
  final enviromentProvider = RamEnviromentProvider();
  final recipeProvider = RamRecipeProvider();
  final productProvider = RamProductProvider();
  final scheduleProvider = RamScheduleProvider();
  final httpServerProvider = RamHttpServerProvider();
  final sharedPreferencesProvider = RamSharedPreferencesProvider();
  final openConnectionProvider = RamOpenConnectionProvider();

  final OpenConnectionManager openConnectionManager = OpenConnectionManager(
      openConnectionProvider,
      productProvider,
      recipeProvider,
      scheduleProvider,
      sharedPreferencesProvider,
      enviromentProvider,

      downloadAllEnviroments : true

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





