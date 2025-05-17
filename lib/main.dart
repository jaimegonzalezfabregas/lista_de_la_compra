import 'package:flutter/material.dart';
import 'package:jhopping_list/UI/env_manager.dart';
import 'package:jhopping_list/providers/enviroment_provider.dart';
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

    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => enviromentProvider)],
      child: MaterialApp(
        title: 'Jhopping List',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 25, 0, 255), brightness: MediaQuery.platformBrightnessOf(context)),
        ),
        home: EnvSelect(),
      ),
    );
  }
}
