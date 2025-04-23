import 'package:flutter/material.dart';
import 'package:jhopping_list/products/product_provider.dart';
import 'package:jhopping_list/recipies/recipe_provider.dart';
import 'package:jhopping_list/home.dart';
import 'package:jhopping_list/schedule/schedule_provider.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized(); // needed for db access

  var recipeProvider = RecipeProvider();
  var productProvider = ProductProvider();
  var scheduleProvider = ScheduleProvider();

  await recipeProvider.cacheInvalidation();
  await productProvider.cacheInvalidation();
  await scheduleProvider.cacheInvalidation();

  runApp(MyApp(recipeProvider, productProvider, scheduleProvider));
}

class MyApp extends StatelessWidget {
  final RecipeProvider recipeProvider;
  final ProductProvider productProvider;
  final ScheduleProvider scheduleProvider;

  const MyApp(
    this.recipeProvider,
    this.productProvider,
    this.scheduleProvider, {
    super.key,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RecipeProvider>(create: (_) => recipeProvider),
        ChangeNotifierProvider<ProductProvider>(create: (_) => productProvider),
        ChangeNotifierProvider<ScheduleProvider>(
          create: (_) => scheduleProvider,
        ),
      ],
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: Home(),
      ),
    );
  }
}
