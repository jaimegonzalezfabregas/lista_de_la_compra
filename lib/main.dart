import 'package:flutter/material.dart';
import 'package:jhopping_list/views/SimpleShopingList.dart';
import 'package:jhopping_list/AppState.dart';
import 'package:provider/provider.dart';

Future main() async {
  var state = AppState();
  WidgetsFlutterBinding.ensureInitialized(); // needed for db access
  await state.cacheInvalidation();
  runApp(MyApp(state));
}

class MyApp extends StatelessWidget {
  final AppState persistence;

  const MyApp(this.persistence, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => persistence,
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return SimpleShopinglist(appState);
  }
}
