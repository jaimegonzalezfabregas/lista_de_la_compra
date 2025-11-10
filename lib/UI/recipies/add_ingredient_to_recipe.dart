import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/common/searchable_list_view.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../flutter_providers/flutter_providers.dart';

import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';

class AddIngredientToRecipe extends StatelessWidget {
  final String recipeId;

  const AddIngredientToRecipe(this.recipeId, {super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;

    ProductProvider productProvider = context.watch<FlutterProductProvider>();
    RecipeProvider recipeProvider = context.watch<FlutterRecipeProvider>();

    Future<Recipe?> recipeFuture = recipeProvider.getRecipeById(recipeId);
    Future<List<Product>> productsFuture = recipeFuture.then(
      (Recipe? recipe) async => recipe == null ? [] : await productProvider.getDisplayProductList(recipe.enviromentId),
    );

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: recipeFuture,
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.hasData) {
              final Recipe recipe = asyncSnapshot.data!;
              return Text(appLoc.addIngredientsToRecipe(recipe.name));
            } else {
              return Text(appLoc.addIngredientsToRecipe("..."));
            }
          },
        ),
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
        future: productsFuture,
        builder: (context, asyncSnapshot) {
          if (!asyncSnapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final List<Product> allProducts = asyncSnapshot.data!;
          return Searchablelistview(
            elements: allProducts,
            elementToTag: (Product p) => p.name,
            newElement: (String name) async {
              String productId = await productProvider.addProduct(name, false, (await recipeFuture)!.enviromentId);

              recipeProvider.setIngredientOfRecipeById(recipeId, productId, true, appLoc.enoughForA);
            },
            elementToListTile: (Product product, tag) => ListTile(
              title: tag,
              trailing: FutureBuilder(
                future: recipeProvider.isIngredientOfRecipe(recipeId, product.id),
                builder: (context, asyncSnapshot) {
                  if (!asyncSnapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  final bool isInRecipe = asyncSnapshot.data!;

                  return Checkbox(
                    value: isInRecipe,
                    onChanged: (value) {
                      recipeProvider.setIngredientOfRecipeById(recipeId, product.id, value == true, appLoc.enoughForA);
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
