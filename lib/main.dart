import 'package:flutter/material.dart';
import 'package:jopping_list/app_state.dart';
import 'package:jopping_list/product.dart';
import 'package:jopping_list/product_list_display.dart';
import 'package:provider/provider.dart';

Future main() async {
  var state = AppPersistence();
  WidgetsFlutterBinding.ensureInitialized(); // needed for db access
  await state.cacheInvalidation();
  runApp(MyApp(state));
}

class MyApp extends StatelessWidget {
  final AppPersistence persistence;

  MyApp(this.persistence, {super.key});

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
    var appState = context.watch<AppPersistence>();

    var product_list = appState.getProductList();

    if (product_list == null) {
      return Text("Loading...");
    }

    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.check_box_outline_blank)),
                Tab(icon: Icon(Icons.check_box)),
                Tab(icon: Icon(Icons.indeterminate_check_box)),
              ],
            ),
            title: const Text("Jhopping List"),
          ),
          body: TabBarView(
            children: [
              ProductListDisplay(
                product_list.where((p) => !p.needed).toList(),
                false,
              ),
              ProductListDisplay(
                product_list.where((p) => p.needed).toList(),
                true,
              ),
              ProductListDisplay(product_list, true),
            ],
          ),
        ),
      ),
    );
  }
}
