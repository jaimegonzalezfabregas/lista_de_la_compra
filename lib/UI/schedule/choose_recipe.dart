import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/common/searchable_list_view.dart';
import 'package:lista_de_la_compra_http_server/src/db/database.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra_http_server/src/db_providers/recipe_provider.dart';
import 'package:lista_de_la_compra_http_server/src/db_providers/schedule_provider.dart';
import 'package:provider/provider.dart';

import '../../flutter_providers/flutter_providers.dart';

class ChooseRecipe extends StatelessWidget {
  final int week;
  final int day;
  final String enviromentId;

  const ChooseRecipe(this.week, this.day, this.enviromentId, {super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;
    ScheduleProvider scheduleProvider = context.watch<FlutterScheduleProvider>();
    RecipeProvider recipeProvider = context.watch<FlutterRecipeProvider>();

    Future<List<ScheduleEntry>> scheduleList = scheduleProvider.getEntries(week, day, enviromentId);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLoc.selectRecipe),
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
        future: recipeProvider.getDisplayRecipeList(enviromentId),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text(appLoc.loading);
          }
          var recipeList = snapshot.data!;

          return Searchablelistview(
            elements: recipeList,
            newElement: (String name) async {
              final String newRecipeId = await recipeProvider.addRecipe(name, enviromentId);
              scheduleProvider.addEntry(week, day, newRecipeId);
            },
            elementToListTile: (recipe, tag) {
              return ListTile(
                title: tag,
                trailing: FutureBuilder(
                  future: scheduleList,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Checkbox(tristate: true, value: false, onChanged: (_) {});
                    }
                    if (snapshot.data == null) {
                      return Checkbox(tristate: true, value: false, onChanged: (_) {});
                    }

                    return Checkbox(
                      value: snapshot.data!.any((entry) => entry.recipeId == recipe.id),
                      onChanged: (value) {
                        if (value == true) {
                          scheduleProvider.addEntry(week, day, recipe.id);
                        } else {
                          scheduleProvider.removeEntry(week, day, recipe.id);
                        }
                      },
                    );
                  },
                ),
              );
            },
            elementToTag: (recipe) => recipe.name,
          );
        },
      ),
    );
  }
}
