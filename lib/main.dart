import 'package:flutter/material.dart';
import 'package:jhopping_list/providers/http_server_state_provider.dart';
import 'package:jhopping_list/providers/open_conection_provider.dart';
import 'package:jhopping_list/providers/product_provider.dart';
import 'package:jhopping_list/providers/recipe_provider.dart';
import 'package:jhopping_list/home.dart';
import 'package:jhopping_list/providers/schedule_provider.dart';
import 'package:jhopping_list/providers/pairing_provider.dart';
import 'package:jhopping_list/providers/shared_preferences_provider.dart';
import 'package:jhopping_list/sync/http_client_manager.dart';
import 'package:provider/provider.dart';

Future main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final RecipeProvider recipeProvider = RecipeProvider();
    final ProductProvider productProvider = ProductProvider();
    final ScheduleProvider scheduleProvider = ScheduleProvider();
    final PairingProvider pairingProvider = PairingProvider();
    final SharedPreferencesProvider sharedPreferencesProvider = SharedPreferencesProvider();

    final OpenConnectionProvider openConnectionProvider = OpenConnectionProvider(
      productProvider,
      recipeProvider,
      scheduleProvider,
      sharedPreferencesProvider,
      pairingProvider,
    );

    final HttpClientManager httpClientManager = HttpClientManager(pairingProvider, openConnectionProvider);

    final HttpServerStateProvider httpServerStateProvider = HttpServerStateProvider(pairingProvider, openConnectionProvider);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => recipeProvider),
        ChangeNotifierProvider(create: (_) => productProvider),
        ChangeNotifierProvider(create: (_) => scheduleProvider),
        ChangeNotifierProvider(create: (_) => pairingProvider),
        ChangeNotifierProvider(create: (_) => sharedPreferencesProvider),
        ChangeNotifierProvider(create: (_) => httpServerStateProvider),
        ChangeNotifierProvider(create: (_) => openConnectionProvider),
      ],
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 25, 0, 255), brightness: MediaQuery.platformBrightnessOf(context)),
        ),
        home: Home(httpClientManager),
      ),
    );
  }
}
