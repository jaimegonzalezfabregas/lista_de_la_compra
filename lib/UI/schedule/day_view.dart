import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lista_de_la_compra/UI/common/needed_checkbox.dart';
import '../../../packages/lista_de_la_compra_backend/lib/src/db/database.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import '../../../packages/lista_de_la_compra_backend/lib/src/db_providers/product_provider.dart';
import 'package:lista_de_la_compra/UI/recipies/recipe_detail.dart';
import '../../../packages/lista_de_la_compra_backend/lib/src/db_providers/recipe_provider.dart';
import 'package:lista_de_la_compra/UI/schedule/choose_recipe.dart';
import '../../../packages/lista_de_la_compra_backend/lib/src/db_providers/schedule_provider.dart';
import 'package:provider/provider.dart';

import '../../flutter_providers/flutter_providers.dart';

// TODO Mark recipies as fullfilled

class DayView extends StatelessWidget {
  final int week;
  final int day;
  final String enviromentId;
  final DateTime startOfWeekTime;
  const DayView(this.week, this.day, this.startOfWeekTime, this.enviromentId, {super.key});

  Widget expansionContents(AppLocalizations appLoc, RecipeProvider recipeProvider, ProductProvider productProvider, ScheduleEntry entry) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Builder(
        builder: (context) {
          var ingredients = recipeProvider.getProductsOfRecipeById(entry.recipeId);

          return FutureBuilder(
            future: ingredients,
            builder: (constext, ingredientSnapshot) {
              if (!ingredientSnapshot.hasData) {
                return Text(appLoc.loading);
              }
              if (ingredientSnapshot.data!.isEmpty) {
                return Center(child: Text(appLoc.recipeWithoutIngredients));
              }

              return Column(
                children: ingredientSnapshot.data!.map((ingredient) {
                  var product = ingredient.$2;
                  var recipeProduct = ingredient.$1;

                  return Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.name),
                            Text(
                              recipeProduct.amount,
                              textScaler: TextScaler.linear(0.9),
                              style: TextStyle(color: Theme.of(context).colorScheme.primary),
                            ),
                          ],
                        ),
                      ),
                      NeededCheckbox(product.id),
                    ],
                  );

                  // return ListTile(
                  //   title: Text(product.name),
                  //   subtitle: Text(recipeProduct.amount),
                  //   trailing: NeededCheckbox(product.id),
                  // );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;

    ScheduleProvider scheduleProvider = context.watch<FlutterScheduleProvider>();
    RecipeProvider recipeProvider = context.watch<FlutterRecipeProvider>();
    ProductProvider productProvider = context.watch<FlutterProductProvider>();

    var dayTime = startOfWeekTime.add(Duration(hours: 24 * day));
    var currentDatetime = DateTime.now();
    var isToday = dayTime.day == currentDatetime.day && dayTime.year == currentDatetime.year && dayTime.month == currentDatetime.month;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: isToday ? Theme.of(context).colorScheme.surfaceContainer : Theme.of(context).colorScheme.surface),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "${DateFormat('EEEE').format(dayTime)} ${dayTime.day}",
                  style: TextStyle(color: isToday ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurface),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ChooseRecipe(week, day, enviromentId);
                      },
                    ),
                  );
                },
                icon: Icon(Icons.add),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(8)),
            child: Column(
              children: [
                FutureBuilder(
                  future: (() => scheduleProvider.getEntries(week, day, enviromentId))(),
                  builder: (context, entrySnapshot) {
                    if (!entrySnapshot.hasData) {
                      return Text(appLoc.loading);
                    }
                    return Column(
                      children: entrySnapshot.data!.map((ScheduleEntry entry) {
                        return FutureBuilder(
                          future: recipeProvider.getRecipeById(entry.recipeId),

                          builder: (context, recipeSnapshot) {
                            if (!recipeSnapshot.hasData) {
                              return Text(appLoc.loading);
                            }
                            if (recipeSnapshot.data == null) {
                              return Text(appLoc.error);
                            }

                            return ExpansionTile(
                              title: Row(
                                children: [
                                  Expanded(child: Text(recipeSnapshot.data!.name)),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      scheduleProvider.removeEntryById(entry.id);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.arrow_outward),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return RecipeDetail(recipeSnapshot.data!.id);
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),

                              children: [expansionContents(appLoc, recipeProvider, productProvider, entry)],
                            );
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
