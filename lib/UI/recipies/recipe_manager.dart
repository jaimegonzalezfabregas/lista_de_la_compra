import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/common/searchable_list_view.dart';
import 'package:lista_de_la_compra_backend/src/db/database.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra_backend/src/db_providers/recipe_provider.dart';
import 'package:lista_de_la_compra/UI/recipies/recipe_detail.dart';
import 'package:provider/provider.dart';

import '../../flutter_providers/flutter_providers.dart';

class RecipeView extends StatelessWidget {
  final String enviromentId;
  const RecipeView(this.enviromentId, {super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;

    RecipeProvider recipeProvider = context.watch<FlutterRecipeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(appLoc.recipeList, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: FutureBuilder(
        future: recipeProvider.getDisplayRecipeList(enviromentId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text(appLoc.loading);
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
              recipeProvider.addRecipe(name, enviromentId);
            },
          );
        },
      ),
    );
  }
}
