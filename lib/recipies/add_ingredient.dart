import 'package:flutter/material.dart';
import 'package:jhopping_list/common/searchable_list_view.dart';
import 'package:jhopping_list/db/database.dart';
import 'package:jhopping_list/products/product_provider.dart';
import 'package:jhopping_list/recipies/recipe_provider.dart';
import 'package:jhopping_list/utils/loading_box.dart';
import 'package:provider/provider.dart';

class AddIngredient extends StatelessWidget {
  final String recipeId;

  const AddIngredient(this.recipeId, {super.key});

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = context.watch();
    RecipeProvider recipeProvider = context.watch();

    var ingredients = recipeProvider.getProductsOfRecipeById(recipeId);

    return Scaffold(
      appBar: AppBar(
        title: Text("Selecionar ingredientes"),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text("Hecho"),
      ),
      body: FutureBuilder(
        future: productProvider.getProductList(),
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
                  future: ingredients,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Checkbox(
                        value: snapshot.data!.any(
                          (ingredient) => ingredient.$2.id == product.id,
                        ),
                        onChanged: (value) {
                          recipeProvider.setIngredientOfRecipeById(
                            recipeId,
                            product.id,
                            value == true,
                          );
                        },
                      );
                    } else {
                      return Checkbox(
                        value: false,
                        onChanged: (_) {},
                        tristate: true,
                      );
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
