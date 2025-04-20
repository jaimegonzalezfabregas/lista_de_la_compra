import 'package:flutter/material.dart';
import 'package:jhopping_list/products/product_provider.dart';
import 'package:jhopping_list/recipies/recipe_provider.dart';
import 'package:jhopping_list/home.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized(); // needed for db access

  var recipeProvider = RecipeProvider();
  var productProvider = ProductProvider();

  await recipeProvider.cacheInvalidation();
  await productProvider.cacheInvalidation();

  runApp(MyApp(recipeProvider, productProvider));
}

class MyApp extends StatelessWidget {
  final RecipeProvider recipeProvider;
  final ProductProvider productProvider;

  const MyApp(this.recipeProvider, this.productProvider, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print("$recipeProvider");
    print("$productProvider");
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RecipeProvider>(create: (_) => recipeProvider),
        ChangeNotifierProvider<ProductProvider>(create: (_) => productProvider),
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
