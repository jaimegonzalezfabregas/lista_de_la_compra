import 'package:flutter/material.dart';
import 'package:jhopping_list/common/searchable_list_view.dart';
import 'package:jhopping_list/db/database.dart';
import 'package:jhopping_list/recipies/recipe_provider.dart';
import 'package:jhopping_list/recipies/recipe_detail.dart';
import 'package:provider/provider.dart';

class RecipeManager extends StatelessWidget {
  const RecipeManager({super.key});

  @override
  Widget build(BuildContext context) {
    RecipeProvider state = context.watch();

    return Scaffold(
      appBar: AppBar(title: Text("Lista de Recetas")),
      body: FutureBuilder(
        future: state.getRecipeList(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("TODO"); // TODO
          }

          return Searchablelistview<Recipe>(
            elements: snapshot.data!,
            elementToTag: (Recipe r) => r.name,
            elementToListTile:
                (Recipe r, RichText tag) => ListTile(
                  title: tag,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetail(r.id),
                      ),
                    );
                  },
                ),
            newElement: (String name) {
              state.addRecipe(name);
            },
          );
        },
      ),
    );
  }
}
