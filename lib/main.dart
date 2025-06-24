import 'package:flutter/material.dart';
import 'package:flutter_show_when_locked/flutter_show_when_locked.dart';
import 'package:lista_de_la_compra/UI/selected_enviroment_fork.dart';
import 'package:lista_de_la_compra/providers/enviroment_provider.dart';
import 'package:lista_de_la_compra/providers/http_server_state_provider.dart';
import 'package:lista_de_la_compra/providers/open_conection_provider.dart';
import 'package:lista_de_la_compra/providers/http_server_provider.dart';
import 'package:lista_de_la_compra/providers/product_provider.dart';
import 'package:lista_de_la_compra/providers/recipe_provider.dart';
import 'package:lista_de_la_compra/providers/schedule_provider.dart';
import 'package:lista_de_la_compra/providers/shared_preferences_provider.dart';
import 'package:lista_de_la_compra/sync/http_client_manager.dart';
import 'package:lista_de_la_compra/sync/http_server_manager.dart';
import 'package:lista_de_la_compra/sync/open_connection_manager.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';

Future main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final EnviromentProvider enviromentProvider = EnviromentProvider();
    final RecipeProvider recipeProvider = RecipeProvider();
    final ProductProvider productProvider = ProductProvider();
    final ScheduleProvider scheduleProvider = ScheduleProvider();
    final HttpServerProvider httpServerProvider = HttpServerProvider();
    final SharedPreferencesProvider sharedPreferencesProvider = SharedPreferencesProvider();
    final OpenConnectionProvider openConnectionProvider = OpenConnectionProvider();

    final OpenConnectionManager openConnectionManager = OpenConnectionManager(
      httpServerProvider,
      openConnectionProvider,
      productProvider,
      recipeProvider,
      scheduleProvider,
      sharedPreferencesProvider,
      enviromentProvider,
    );

    final HttpServerManager httpServerManager = HttpServerManager(httpServerProvider, openConnectionManager);
    final HttpClientManager httpClientManager = HttpClientManager(openConnectionProvider, openConnectionManager, httpServerProvider);

    final HttpServerStateProvider httpServerStateProvider = HttpServerStateProvider(httpServerManager, sharedPreferencesProvider);

    (() async {
      httpServerManager.startServer(httpServerStateProvider, await sharedPreferencesProvider.getLocalNick());
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
