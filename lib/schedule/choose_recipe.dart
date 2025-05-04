import 'package:flutter/material.dart';
import 'package:jhopping_list/common/searchable_list_view.dart';
import 'package:jhopping_list/db/database.dart';
import 'package:jhopping_list/recipies/recipe_provider.dart';
import 'package:jhopping_list/schedule/schedule_provider.dart';
import 'package:jhopping_list/utils/loading_box.dart';
import 'package:provider/provider.dart';

class ChooseRecipe extends StatelessWidget {
  final int week;
  final int day;

  const ChooseRecipe(this.week, this.day, {super.key});

  @override
  Widget build(BuildContext context) {
    ScheduleProvider scheduleProvider = context.watch();
    RecipeProvider recipeProvider = context.watch();

    Future<List<ScheduleEntry>> scheduleList = scheduleProvider.getEntries(
      week,
      day,
    );

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
      ),
      body: FutureBuilder(
        future: recipeProvider.getRecipeList(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoadingBox();
          }
          var recipeList = snapshot.data!;

          // TODO make searcheable list ordered by selected recipes

          return Searchablelistview(
            elements: recipeList,
            elementToListTile: (recipe, tag) {
              return ListTile(
                title: tag,
                trailing: FutureBuilder(
                  future: scheduleList,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Checkbox(
                        tristate: true,
                        value: false,
                        onChanged: (_) {},
                      );
                    }
                    if (snapshot.data == null) {
                      return Checkbox(
                        tristate: true,
                        value: false,
                        onChanged: (_) {},
                      );
                    }

                    return Checkbox(
                      value: snapshot.data!.any(
                        (entry) => entry.recipeId == recipe.id,
                      ),
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
