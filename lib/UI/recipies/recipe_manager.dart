import 'package:flutter/material.dart';
import 'package:jhopping_list/UI/common/searchable_list_view.dart';
import 'package:jhopping_list/db/database.dart';
import 'package:jhopping_list/providers/recipe_provider.dart';
import 'package:jhopping_list/UI/recipies/recipe_detail.dart';
import 'package:jhopping_list/UI/common/loading_box.dart';
import 'package:provider/provider.dart';

class RecipeView extends StatelessWidget {
  final String enviromentId;
  const RecipeView(this.enviromentId, {super.key});

  @override
  Widget build(BuildContext context) {
    RecipeProvider state = context.watch();

    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Recetas", style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer)),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: FutureBuilder(
        future: state.getDisplayRecipeList(enviromentId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoadingBox();
          }

          return Searchablelistview<Recipe>(
            elements: snapshot.data!,
            elementToTag: (Recipe r) => r.name,
            elementToListTile: (Recipe r, RichText tag) {
              assert(r.enviromentId == enviromentId);

              return ListTile(
                title: tag,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RecipeDetail(r.id)));
                },
              );
            },
            newElement: (String name) {
              state.addRecipe(name, enviromentId);
            },
          );
        },
      ),
    );
  }
}
