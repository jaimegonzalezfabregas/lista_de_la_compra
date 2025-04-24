import 'package:flutter/material.dart';
import 'package:jhopping_list/db/database.dart';
import 'package:jhopping_list/products/product_detail.dart';
import 'package:jhopping_list/recipies/add_ingredient.dart';
import 'package:jhopping_list/recipies/recipe_provider.dart';
import 'package:provider/provider.dart';

class Ingredients extends StatelessWidget {
  final int recipeId;
  const Ingredients(this.recipeId, {super.key});

  ListTile ingredientEntry(
    RecipeProduct ingredient,
    Product product,
    RecipeProvider recipeProvider,
    BuildContext context,
  ) {
    return ListTile(
      onLongPress:
          () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetail(ingredient.productId),
              ),
            ),
          },
      title: Text(product.name),
      subtitle: ingredient.amount != "" ? Text(ingredient.amount) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () {
              TextEditingController textEditingController =
                  TextEditingController();
              textEditingController.text = ingredient.amount;
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  Widget cancelButton = TextButton(
                    child: Text("Cancelar"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  );
                  Widget continueButton = ElevatedButton(
                    child: Text("Guardar"),
                    onPressed: () {
                      recipeProvider.setIngredientAmountOfRecipeById(
                        recipeId,
                        ingredient.productId,
                        textEditingController.text,
                      );
                      Navigator.of(context).pop();
                    },
                  );

                  return AlertDialog(
                    title: Text("Introduce la cantidad"),
                    content: TextField(controller: textEditingController),
                    actions: [cancelButton, continueButton],
                  );
                },
              );
            },
            child: Icon(Icons.edit),
          ),
          TextButton(
            onPressed: () {
              recipeProvider.setIngredientOfRecipeById(
                recipeId,
                ingredient.productId,
                false,
              );
            },
            child: Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    RecipeProvider recipeProvider = context.watch();

    var ingredients = recipeProvider.getProductsOfRecipeById(recipeId);

    return FutureBuilder(
      future: ingredients,
      builder: (
        context,
        AsyncSnapshot<List<(RecipeProduct, Product)>> snapshot,
      ) {
        if (!snapshot.hasData) {
          return Text("Cargando... $snapshot");
        }

        return Column(
          children: [
            snapshot.data!.isNotEmpty
                ? ListView(
                  shrinkWrap: true,
                  physics:
                      NeverScrollableScrollPhysics(), // Prevent scrolling inside the Column
                  children:
                      snapshot.data!
                          .map(
                            (ingredient) => ingredientEntry(
                              ingredient.$1,
                              ingredient.$2,
                              recipeProvider,
                              context,
                            ),
                          )
                          .toList(),
                )
                : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text("Todavía no se han añadido ingredientes"),
                  ),
                ),
            Center(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return AddIngredient(recipeId);
                      },
                    ),
                  );
                },
                child: Text("Añadir Ingredientes"),
              ),
            ),
          ],
        );
      },
    );
  }
}

class RecipeDetail extends StatelessWidget {
  final int recipeId;

  const RecipeDetail(this.recipeId, {super.key});

  @override
  Widget build(BuildContext context) {
    RecipeProvider appState = context.watch();

    Future<Recipe?> recipeFuture = appState.getRecipeById(recipeId);

    return Scaffold(
      appBar: AppBar(title: FutureBuilder(
        future: recipeFuture,
        builder: (context,snapshot) {
          if(!snapshot.hasData){
            return Text("Cargando...");
          }
          if(snapshot.data == null){
            return Text("Error");
          }

          var recipe = snapshot.data!;

          return Text(recipe.name);
        }
      )),
      body: Column(
        children: [
          Text(
            "Ingredientes",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Ingredients(recipeId),
          Divider(),
          Text("Fechas", style: Theme.of(context).textTheme.headlineMedium),
          Divider(),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              appState.deleteRecipeById(recipeId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Danger color
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text("Eliminar"),
          ),
        ],
      ),
    );
  }
}
