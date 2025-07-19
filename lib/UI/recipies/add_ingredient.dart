import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/common/searchable_list_view.dart';
import 'package:lista_de_la_compra_backend/src/db/database.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra_backend/src/db_providers/product_provider.dart';
import 'package:lista_de_la_compra_backend/src/db_providers/recipe_provider.dart';
import 'package:provider/provider.dart';

import '../../flutter_providers/flutter_providers.dart';

class AddIngredient extends StatelessWidget {
  final String recipeId;

  const AddIngredient(this.recipeId, {super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;

    ProductProvider productProvider = context.watch<FlutterProductProvider>();
    RecipeProvider recipeProvider = context.watch<FlutterRecipeProvider>();

    Future<List<(RecipeProduct, Product)>> ingredientsFuture = recipeProvider.getProductsOfRecipeById(recipeId);
    Future<Recipe?> recipeFuture = recipeProvider.getRecipeById(recipeId);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLoc.selectIngredients),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],

        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),

      body: FutureBuilder(
        future: recipeProvider
            .getRecipeById(recipeId)
            .then((Recipe? recipe) async => recipe == null ? null : await productProvider.getDisplayProductList(recipe.enviromentId)),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text(appLoc.loading);
          }
          final List<Product> products = snapshot.data!;
          return Searchablelistview<Product>(
            elements: products,
            elementToTag: (Product p) => p.name,
            elementToListTile: (Product product, tag) {
              return ListTile(
                title: tag,
                trailing: FutureBuilder(
                  future: ingredientsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final List<(RecipeProduct, Product)> recipeProducts = snapshot.data!;

                      return Checkbox(
                        value: recipeProducts.any((ingredient) => ingredient.$2.id == product.id),
                        onChanged: (value) {
                          recipeProvider.setIngredientOfRecipeById(recipeId, product.id, value == true, appLoc.enoughForA);
                        },
                      );
                    } else {
                      return Checkbox(value: false, onChanged: (_) {}, tristate: true);
                    }
                  },
                ),
              );
            },
            newElement: (String name) async {
              String productId = await productProvider.addProduct(name, false, (await recipeFuture)!.enviromentId);

              recipeProvider.setIngredientOfRecipeById(recipeId, productId, true, appLoc.enoughForA);
            },
          );
        },
      ),
    );
  }
}
