import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lista_de_la_compra/UI/common/needed_checkbox.dart';
import 'package:provider/provider.dart';
import 'package:lista_de_la_compra/UI/schedule/schedule_home.dart';
import 'package:lista_de_la_compra/UI/recipies/add_ingredient_to_recipe.dart';
import 'package:lista_de_la_compra/UI/products/product_detail.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';

import '../../flutter_providers/flutter_providers.dart';

import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';

class Ingredients extends StatelessWidget {
  final String recipeId;
  const Ingredients(this.recipeId, {super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;
    RecipeProvider recipeProvider = context.watch<FlutterRecipeProvider>();

    var ingredientFuture = recipeProvider.getProductsOfRecipeById(recipeId);

    return FutureBuilder(
      future: ingredientFuture,
      builder: (context, AsyncSnapshot<List<(RecipeProduct, Product)>> snapshot) {
        if (!snapshot.hasData) {
          return Text(appLoc.loading);
        }
        List<(RecipeProduct, Product)> ingredientList = snapshot.data!;

        if (ingredientList.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text(appLoc.noIngredientsYet)),
          );
        }

        // Get a default house for needed toggles
        String? enviromentId = ingredientList.isNotEmpty ? ingredientList.first.$2.enviromentId : null;

        return FutureBuilder<List<House>>(
          future: enviromentId != null ? context.read<FlutterHouseProvider>().getHouseList(enviromentId) : Future.value([]),
          builder: (context, houseSnapshot) {
            var firstHouse = houseSnapshot.data?.isNotEmpty == true ? houseSnapshot.data!.first : null;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: ingredientList.length,
                      itemBuilder: (context, index) {
                        var (ingredient, product) = ingredientList[index];

                        return ListTile(
                          title: Text(product.name),
                          subtitle: ingredient.amount != "" ? Text(ingredient.amount) : null,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (firstHouse != null)
                                NeededCheckbox(productId: product.id, houseId: firstHouse.id),
                              PopupMenuButton<String>(
                                onSelected: (s) {},
                                itemBuilder: (BuildContext context) {
                                  return [
                                    PopupMenuItem(
                                      onTap: () {
                                        TextEditingController textEditingController = TextEditingController();
                                        textEditingController.text = ingredient.amount;
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            Widget cancelButton = TextButton(
                                              child: Text(appLoc.cancel),
                                              onPressed: () => Navigator.of(context).pop(),
                                            );
                                            Widget continueButton = ElevatedButton(
                                              child: Text(appLoc.save),
                                              onPressed: () {
                                                recipeProvider.setIngredientAmountOfRecipeById(recipeId, ingredient.productId, textEditingController.text);
                                                Navigator.of(context).pop();
                                              },
                                            );
                                            return AlertDialog(
                                              title: Text(appLoc.inputTheAmount),
                                              content: TextField(controller: textEditingController),
                                              actions: [cancelButton, continueButton],
                                            );
                                          },
                                        );
                                      },
                                      child: Row(children: [Icon(Icons.edit), SizedBox(width: 8), Text(appLoc.editAmount)]),
                                    ),
                                    PopupMenuItem(
                                      child: Row(children: [Icon(Icons.arrow_outward), SizedBox(width: 8), Text(appLoc.details)]),
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => ProductDetail(ingredient.productId, enviromentId!)),
                                        );
                                      },
                                    ),
                                    PopupMenuItem(
                                      onTap: () {
                                        recipeProvider.setIngredientOfRecipeById(recipeId, ingredient.productId, false, appLoc.enoughForA);
                                      },
                                      child: Row(children: [Icon(Icons.delete), SizedBox(width: 8), Text(appLoc.delete)]),
                                    ),
                                  ];
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddIngredientToRecipe(recipeId)),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(Icons.format_list_bulleted_add),
                            SizedBox(width: 8),
                            Text(appLoc.addIngredients, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class PlannedDates extends StatefulWidget {
  final String recipeId;
  const PlannedDates(this.recipeId, {super.key});

  @override
  State<PlannedDates> createState() => _PlannedDatesState();
}

class _PlannedDatesState extends State<PlannedDates> {
  bool showPast = false;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;

    ScheduleProvider scheduleRecipeProvider = context.watch<FlutterScheduleProvider>();
    RecipeProvider recipeProvider = context.watch<FlutterRecipeProvider>();

    Future<List<ScheduleEntry>> dates = scheduleRecipeProvider.getEntriesForRecipe(widget.recipeId, showPast);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(appLoc.showPastDates),
                  Checkbox(
                    value: showPast,
                    onChanged: (value) {
                      setState(() {
                        showPast = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            Divider(),
            FutureBuilder(
              future: dates,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text(appLoc.loading);
                }

                return snapshot.data!.isNotEmpty
                    ? ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => Divider(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var entry = snapshot.data![index];
                          DateTime date = weekAndDayToDateTime(entry.week, entry.day);

                          return ListTile(
                            title: Text(DateFormat('yMMMd').format(date)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    Future<Recipe?> recipeFuture = recipeProvider.getRecipeById(widget.recipeId);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return FutureBuilder(
                                            future: recipeFuture,
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return Text(appLoc.loading);
                                              }
                                              return ScheduleHome(entry.week, snapshot.data!.enviromentId);
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.arrow_outward),
                                ),
                                IconButton(
                                  onPressed: () {
                                    scheduleRecipeProvider.removeEntryById(entry.id);
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Center(child: Text(appLoc.noPlannedDates))),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeDetail extends StatelessWidget {
  final String recipeId;
  const RecipeDetail(this.recipeId, {super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;
    RecipeProvider recipeProvider = context.watch<FlutterRecipeProvider>();
    Future<Recipe?> recipeFuture = recipeProvider.getRecipeById(recipeId);

    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            onSelected: (s) {},
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Row(children: [Icon(Icons.delete), SizedBox(width: 8), Text(appLoc.delete)]),
                  onTap: () {
                    Navigator.pop(context);
                    recipeProvider.deleteRecipeById(recipeId);
                  },
                ),
                PopupMenuItem(
                  child: Row(children: [Icon(Icons.edit), SizedBox(width: 8), Text(appLoc.editName)]),
                  onTap: () {
                    TextEditingController textControler = TextEditingController();
                    recipeFuture.then((Recipe? p) {
                      textControler.text = p!.name;
                    });
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(appLoc.changeName),
                          content: TextField(
                            decoration: InputDecoration(labelText: appLoc.name),
                            controller: textControler,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(appLoc.cancel),
                            ),
                            TextButton(
                              onPressed: () {
                                recipeProvider.setRecipeName(recipeId, textControler.text);
                                Navigator.of(context).pop();
                              },
                              child: Text(appLoc.save),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ];
            },
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        title: FutureBuilder(
          future: recipeFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text(appLoc.loading);
            }
            if (snapshot.data == null) {
              return Text(appLoc.error, style: TextStyle(color: Theme.of(context).colorScheme.onSurface));
            }
            return Text(snapshot.data!.name);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(appLoc.ingredients, style: Theme.of(context).textTheme.titleSmall),
            ),
            Ingredients(recipeId),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(appLoc.dates, style: Theme.of(context).textTheme.titleSmall),
            ),
            PlannedDates(recipeId),
          ],
        ),
      ),
    );
  }
}
