import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/common/searchable_list_view.dart';
import 'package:lista_de_la_compra/db/database.dart';
import 'package:lista_de_la_compra/providers/product_provider.dart';
import 'package:lista_de_la_compra/providers/recipe_provider.dart';
import 'package:lista_de_la_compra/UI/common/loading_box.dart';
import 'package:provider/provider.dart';

class AddIngredient extends StatelessWidget {
  final String recipeId;

  const AddIngredient(this.recipeId, {super.key});

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = context.watch();
    RecipeProvider recipeProvider = context.watch();

    var ingredientsFuture = recipeProvider.getProductsOfRecipeById(recipeId);

    return Scaffold(
      appBar: AppBar(title: Text("Seleccionar ingredientes"), backgroundColor: Theme.of(context).colorScheme.surfaceContainer),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text("Hecho"),
      ),
      body: FutureBuilder(
        future: recipeProvider
            .getRecipeById(recipeId)
            .then((Recipe? recipe) async => recipe == null ? null : await productProvider.getDisplayProductList(recipe.enviromentId)),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoadingBox();
          }

          return Searchablelistview<Product>(
            elements: snapshot.data!,
            elementToTag: (Product p) => p.name,
            elementToListTile: (Product product, tag) {
              return ListTile(
                title: tag,
                trailing: FutureBuilder(
                  future: ingredientsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Checkbox(
                        value: snapshot.data!.any((ingredient) => ingredient.$2.id == product.id),
                        onChanged: (value) {
                          recipeProvider.setIngredientOfRecipeById(recipeId, product.id, value == true);
                        },
                      );
                    } else {
                      return Checkbox(value: false, onChanged: (_) {}, tristate: true);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
