import 'package:flutter/material.dart';
import 'package:jhopping_list/providers/product_provider.dart';
import 'package:jhopping_list/providers/recipe_provider.dart';
import 'package:jhopping_list/home.dart';
import 'package:jhopping_list/providers/schedule_provider.dart';
import 'package:jhopping_list/providers/pairing_provider.dart';
import 'package:provider/provider.dart';

Future main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RecipeProvider>(create: (_) => RecipeProvider()),
        ChangeNotifierProvider<ProductProvider>(
          create: (_) => ProductProvider(),
        ),
        ChangeNotifierProvider<ScheduleProvider>(
          create: (_) => ScheduleProvider(),
        ),
        ChangeNotifierProvider<PairingProvider>(
          create: (_) => PairingProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 25, 0, 255),
            brightness: MediaQuery.platformBrightnessOf(context),
          ),
        ),
        home: Home(),
      ),
    );
  }
}
