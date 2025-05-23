import 'package:flutter/material.dart';
import 'package:jhopping_list/UI/env_manager.dart';
import 'package:jhopping_list/providers/enviroment_provider.dart';
import 'package:jhopping_list/providers/http_server_state_provider.dart';
import 'package:jhopping_list/providers/open_conection_provider.dart';
import 'package:jhopping_list/providers/pairing_provider.dart';
import 'package:jhopping_list/providers/product_provider.dart';
import 'package:jhopping_list/providers/recipe_provider.dart';
import 'package:jhopping_list/providers/schedule_provider.dart';
import 'package:jhopping_list/providers/shared_preferences_provider.dart';
import 'package:jhopping_list/sync/http_server_manager.dart';
import 'package:jhopping_list/sync/open_connection_manager.dart';
import 'package:provider/provider.dart';

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
    final PairingProvider pairingProvider = PairingProvider();
    final SharedPreferencesProvider sharedPreferencesProvider = SharedPreferencesProvider();
    final OpenConnectionProvider openConnectionProvider = OpenConnectionProvider();

    final OpenConnectionManager openConnectionManager = OpenConnectionManager(
      pairingProvider,
      openConnectionProvider,
      productProvider,
      recipeProvider,
      scheduleProvider,
      sharedPreferencesProvider,
      enviromentProvider,
    );

    final HttpServerManager httpServerManager = HttpServerManager(pairingProvider, openConnectionManager);

    final HttpServerStateProvider httpServerStateProvider = HttpServerStateProvider(httpServerManager);

    (() async {
      httpServerManager.startServer(httpServerStateProvider, await sharedPreferencesProvider.getLocalNick());
    })();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => enviromentProvider),
        ChangeNotifierProvider(create: (_) => recipeProvider),
        ChangeNotifierProvider(create: (_) => productProvider),
        ChangeNotifierProvider(create: (_) => scheduleProvider),
        ChangeNotifierProvider(create: (_) => pairingProvider),
        ChangeNotifierProvider(create: (_) => sharedPreferencesProvider),
        ChangeNotifierProvider(create: (_) => openConnectionProvider),
        ChangeNotifierProvider(create: (_) => httpServerStateProvider),
      ],
      child: MaterialApp(
        title: 'Jhopping List',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 25, 0, 255), brightness: MediaQuery.platformBrightnessOf(context)),
        ),
        home: EnvSelect(openConnectionManager),
      ),
    );
  }
}
