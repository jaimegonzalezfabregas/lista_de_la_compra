import 'package:flutter/material.dart';
import 'package:flutter_show_when_locked/flutter_show_when_locked.dart';
import 'package:lista_de_la_compra/UI/selected_enviroment_fork.dart';
import 'package:lista_de_la_compra_backend/src/db_providers/enviroment_provider.dart';
import 'package:lista_de_la_compra_backend/src/db_providers/http_server_state_provider.dart';
import 'package:lista_de_la_compra/shared_preference_providers/persistant_shared_preferences_provider.dart';
import 'package:lista_de_la_compra_backend/src/shared_preferences_providers/shared_preferences_provider.dart';
import 'package:lista_de_la_compra/sync/http_client_service.dart';
import 'package:lista_de_la_compra_backend/src/sync/open_conection_provider.dart';
import 'package:lista_de_la_compra_backend/src/db_providers/http_server_provider.dart';
import 'package:lista_de_la_compra_backend/src/db_providers/product_provider.dart';
import 'package:lista_de_la_compra_backend/src/db_providers/recipe_provider.dart';
import 'package:lista_de_la_compra_backend/src/db_providers/schedule_provider.dart';
import 'package:lista_de_la_compra_backend/src/sync/http_server_manager.dart';
import 'package:lista_de_la_compra_backend/src/sync/open_connection_manager.dart';
import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';
import 'package:provider/provider.dart';
import 'flutter_providers/flutter_providers.dart';
import 'l10n/app_localizations.dart';

Future main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final FlutterEnviromentProvider enviromentProvider = FlutterEnviromentProvider();
    final FlutterRecipeProvider recipeProvider = FlutterRecipeProvider();
    final FlutterProductProvider productProvider = FlutterProductProvider();
    final FlutterScheduleProvider scheduleProvider = FlutterScheduleProvider();
    final FlutterHttpServerProvider httpServerProvider = FlutterHttpServerProvider();
    final PersistantSharedPreferencesProvider sharedPreferencesProvider = PersistantSharedPreferencesProvider(context);
    final FlutterOpenConnectionProvider openConnectionProvider = FlutterOpenConnectionProvider();

    final OpenConnectionManager openConnectionManager = OpenConnectionManager(
      openConnectionProvider,
      productProvider,
      recipeProvider,
      scheduleProvider,
      sharedPreferencesProvider,
      enviromentProvider,
    );

    final HttpServerManager httpServerManager = HttpServerManager(httpServerProvider, openConnectionManager);
    final FlutterHttpClientService httpClientService = FlutterHttpClientService(openConnectionProvider, openConnectionManager, httpServerProvider);

    final FlutterHttpServerStateProvider httpServerStateProvider = FlutterHttpServerStateProvider(httpServerManager, sharedPreferencesProvider);

    (() async {
      httpServerStateProvider.tryStartServer();
    })();

    AppLifecycleListener(
      onShow: () {
        FlutterShowWhenLocked().show();
      },
    );


    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => enviromentProvider),
        ChangeNotifierProvider(create: (_) => recipeProvider),
        ChangeNotifierProvider(create: (_) => productProvider),
        ChangeNotifierProvider(create: (_) => scheduleProvider),
        ChangeNotifierProvider(create: (_) => httpServerProvider),
        ChangeNotifierProvider(create: (_) => sharedPreferencesProvider),
        ChangeNotifierProvider(create: (_) => openConnectionProvider),
        ChangeNotifierProvider(create: (_) => httpServerStateProvider),
        ChangeNotifierProvider(create: (_) => httpClientService),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateTitle: (context) {
          AppLocalizations appLoc = AppLocalizations.of(context)!;
          return appLoc.appTitle;
        },
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(220, 138, 221, 1), brightness: MediaQuery.platformBrightnessOf(context)),
        ),
        home: SelectedEnviromentFork(openConnectionManager),
      ),
    );
  }
}
