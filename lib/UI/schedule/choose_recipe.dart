import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/common/searchable_list_view.dart';
import 'package:lista_de_la_compra/db/database.dart';
import 'package:lista_de_la_compra/providers/recipe_provider.dart';
import 'package:lista_de_la_compra/providers/schedule_provider.dart';
import 'package:lista_de_la_compra/UI/common/loading_box.dart';
import 'package:provider/provider.dart';

class ChooseRecipe extends StatelessWidget {
  final int week;
  final int day;
  final String enviromentId;

  const ChooseRecipe(this.week, this.day, this.enviromentId, {super.key});

  @override
  Widget build(BuildContext context) {
    ScheduleProvider scheduleProvider = context.watch();
    RecipeProvider recipeProvider = context.watch();

    Future<List<ScheduleEntry>> scheduleList = scheduleProvider.getEntries(week, day, enviromentId);

    return Scaffold(
      appBar: AppBar(
        title: Text("Seleccionar receta"),
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
            return LoadingBox();
          }
          var recipeList = snapshot.data!;

          return Searchablelistview(
            elements: recipeList,
            newElement: (String name) {
              recipeProvider.addRecipe(name, enviromentId);
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
