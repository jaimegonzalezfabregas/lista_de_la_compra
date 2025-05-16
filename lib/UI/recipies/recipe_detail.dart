import 'package:flutter/material.dart';
import 'package:jhopping_list/db/database.dart';
import 'package:jhopping_list/UI/products/product_detail.dart';
import 'package:jhopping_list/providers/product_provider.dart';
import 'package:jhopping_list/UI/recipies/add_ingredient.dart';
import 'package:jhopping_list/providers/recipe_provider.dart';
import 'package:jhopping_list/UI/schedule/day_view.dart';
import 'package:jhopping_list/UI/schedule/schedule_view.dart';
import 'package:jhopping_list/providers/schedule_provider.dart';
import 'package:jhopping_list/UI/schedule/utils.dart';
import 'package:jhopping_list/UI/common/loading_box.dart';
import 'package:provider/provider.dart';

class Ingredients extends StatelessWidget {
  final String recipeId;
  const Ingredients(this.recipeId, {super.key});

  ListTile ingredientEntry(RecipeProduct ingredient, Product product, RecipeProvider recipeProvider, BuildContext context) {
    ProductProvider productProvider = context.watch();

    return ListTile(
      title: Text(product.name),
      subtitle: ingredient.amount != "" ? Text(ingredient.amount) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: product.needed,
            onChanged: (value) {
              productProvider.setProductNeededness(product.id, value!);
            },
          ),
          IconButton(
            onPressed: () {
              TextEditingController textEditingController = TextEditingController();
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
                      recipeProvider.setIngredientAmountOfRecipeById(recipeId, ingredient.productId, textEditingController.text);
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
            icon: Icon(Icons.edit),
          ),
          IconButton(
            icon: Icon(Icons.arrow_outward),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return ProductDetail(ingredient.productId);
                  },
                ),
              );
            },
          ),
          IconButton(
            onPressed: () {
              recipeProvider.setIngredientOfRecipeById(recipeId, ingredient.productId, false);
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    RecipeProvider recipeProvider = context.watch();
    context.watch<ProductProvider>();

    var ingredients = recipeProvider.getProductsOfRecipeById(recipeId);

    return FutureBuilder(
      future: ingredients,
      builder: (context, AsyncSnapshot<List<(RecipeProduct, Product)>> snapshot) {
        if (!snapshot.hasData) {
          return LoadingBox();
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                if (snapshot.data!.isNotEmpty)
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(), // Prevent scrolling inside the Column
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) => ingredientEntry(snapshot.data![index].$1, snapshot.data![index].$2, recipeProvider, context),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(padding: const EdgeInsets.all(8.0), child: Center(child: Text("Todavía no se han añadido ingredientes"))),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
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

                    child: Row(
                      children: [
                        Icon(Icons.add),
                        SizedBox(width: 8),
                        Text("Añadir ingredientes", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
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
    ScheduleProvider scheduleRecipeProvider = context.watch();
    RecipeProvider recipeProvider = context.watch();

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
                  Text("Mostrar fechas pasadas"),
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
                  return LoadingBox();
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
                          title: Text("${date.day} de ${months[date.month]} de ${date.year}"),

                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,

                            children: [
                              IconButton(
                                onPressed: () async {
                                  Recipe? recipe = await recipeProvider.getRecipeById(widget.recipeId);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return ScheduleView(entry.week, recipe!.enviromentId);
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
                    : Padding(padding: const EdgeInsets.all(8.0), child: Center(child: Center(child: Text("No hay fechas planificadas"))));
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
    RecipeProvider appState = context.watch();

    Future<Recipe?> recipeFuture = appState.getRecipeById(recipeId);

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (s) {},
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Row(children: [Text("Eliminar"), SizedBox(width: 8), Icon(Icons.delete)]),
                  onTap: () {
                    Navigator.pop(context);
                    appState.deleteRecipeById(recipeId);
                  },
                ),
              ];
            },
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: FutureBuilder(
          future: recipeFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LoadingBox();
            }
            if (snapshot.data == null) {
              return Text("Error", style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer));
            }

            var recipe = snapshot.data!;

            return Text(recipe.name);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text("Ingredientes", style: Theme.of(context).textTheme.titleSmall),
            ),
            Ingredients(recipeId),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 15.0), child: Text("Fechas", style: Theme.of(context).textTheme.titleSmall)),
            PlannedDates(recipeId),
          ],
        ),
      ),
    );
  }
}
