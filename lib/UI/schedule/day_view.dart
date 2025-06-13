import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/common/needed_checkbox.dart';
import 'package:lista_de_la_compra/db/database.dart';
import 'package:lista_de_la_compra/providers/product_provider.dart';
import 'package:lista_de_la_compra/UI/recipies/recipe_detail.dart';
import 'package:lista_de_la_compra/providers/recipe_provider.dart';
import 'package:lista_de_la_compra/UI/schedule/choose_recipe.dart';
import 'package:lista_de_la_compra/providers/schedule_provider.dart';
import 'package:lista_de_la_compra/UI/common/loading_box.dart';
import 'package:provider/provider.dart';

const List<String> weekDays = ["Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sábado", "Domingo"];
const List<String> months = [
  "",
  "Enero",
  "Febrero",
  "Marzo",
  "Abril",
  "Mayo",
  "Junio",
  "Juilo",
  "Agosto",
  "Septiembre",
  "Octubre",
  "Noviembre",
  "Diciembre",
];

class DayView extends StatelessWidget {
  final int week;
  final int day;
  final String enviromentId;
  final DateTime startOfWeekTime;
  const DayView(this.week, this.day, this.startOfWeekTime, this.enviromentId, {super.key});

  @override
  Widget build(BuildContext context) {
    ScheduleProvider scheduleProvider = context.watch();
    RecipeProvider recipeProvider = context.watch();

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
                  "${weekDays[day]} ${dayTime.day}",
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
                      return LoadingBox();
                    }
                    return Column(
                      children:
                          entrySnapshot.data!.map((ScheduleEntry entry) {
                            return FutureBuilder(
                              future: recipeProvider.getRecipeById(entry.recipeId),

                              builder: (context, recipeSnapshot) {
                                if (!recipeSnapshot.hasData) {
                                  return LoadingBox();
                                }
                                if (recipeSnapshot.data == null) {
                                  return Text("Error");
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

                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Builder(
                                        builder: (context) {
                                          var ingredients = recipeProvider.getProductsOfRecipeById(entry.recipeId);

                                          return FutureBuilder(
                                            future: ingredients,
                                            builder: (constext, ingredientSnapshot) {
                                              var productProvider = context.watch<ProductProvider>();
                                              if (!ingredientSnapshot.hasData) {
                                                return LoadingBox();
                                              }
                                              if (ingredientSnapshot.data!.isEmpty) {
                                                return Center(child: Text("Esta receta no tiene ingredientes"));
                                              }

                                              return Column(
                                                children:
                                                    ingredientSnapshot.data!.map((ingredient) {
                                                      var product = ingredient.$2;
                                                      var recipeProduct = ingredient.$1;

                                                      return ListTile(
                                                        title: Text(product.name),
                                                        subtitle: Text(recipeProduct.amount),
                                                        trailing: NeededCheckbox(product.id),
                                                      );
                                                    }).toList(),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
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
