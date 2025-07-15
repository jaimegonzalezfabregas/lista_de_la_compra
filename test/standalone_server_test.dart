eimport 'package:flutter_test/flutter_test.dart' hide test;
import 'package:lista_de_la_compra/db_providers/enviroment_provider.dart';
import 'package:lista_de_la_compra/db_providers/http_server_state_provider.dart';
import 'package:lista_de_la_compra/shared_preference_providers/ram_shared_preferences_provider.dart';
import 'package:lista_de_la_compra/shared_preference_providers/shared_preferences_provider.dart';
import 'package:lista_de_la_compra/sync/open_conection_provider.dart';
import 'package:lista_de_la_compra/db_providers/http_server_provider.dart';
import 'package:lista_de_la_compra/db_providers/product_provider.dart';
import 'package:lista_de_la_compra/db_providers/recipe_provider.dart';
import 'package:lista_de_la_compra/db_providers/schedule_provider.dart';
import 'package:lista_de_la_compra/sync/http_server_manager.dart';
import 'package:lista_de_la_compra/sync/open_connection_manager.dart';
import 'package:test/test.dart';

void main() {
  test("?", () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // TODO shared preferences set nick

    final EnviromentProvider enviromentProvider = RamEnviromentProvider();
    final RecipeProvider recipeProvider = RamRecipeProvider();
    final ProductProvider productProvider = RamProductProvider();
    final ScheduleProvider scheduleProvider = RamScheduleProvider();
    final HttpServerProvider httpServerProvider = RamHttpServerProvider();
    final SharedPreferencesProvider sharedPreferencesProvider = RamSharedPreferencesProvider();
    final OpenConnectionProvider openConnectionProvider = RamOpenConnectionProvider();

    final OpenConnectionManager openConnectionManager = OpenConnectionManager(
      openConnectionProvider,
      productProvider,
      recipeProvider,
      scheduleProvider,
      sharedPreferencesProvider,
      enviromentProvider,
      
      downloadAllEnviroments : true
      
    );

    final HttpServerManager httpServerManager = HttpServerManager(httpServerProvider, openConnectionManager);

    final HttpServerStateProvider httpServerStateProvider = RamHttpServerStateProvider(httpServerManager, sharedPreferencesProvider);

    httpServerStateProvider.tryStartServer();

    while (true) {
      String? err = httpServerStateProvider.getServerError();
      if (err != null) {
        print(err);
        httpServerStateProvider.tryStartServer();
      }

      await Future.delayed(Duration(seconds: 5));
    }
  });
}
