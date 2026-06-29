import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/common/needed_checkbox.dart';
import 'package:lista_de_la_compra/UI/common/searchable_list_view.dart';
import 'package:lista_de_la_compra/UI/products/common.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra/UI/recipies/recipe_detail.dart';
import 'package:provider/provider.dart';
import '../../flutter_providers/flutter_providers.dart';

import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';

// todo
// see history
// see locations in diferent markets

class ProductDetail extends StatelessWidget {
  final String productId;
  final String enviromentId;

  const ProductDetail(this.productId, this.enviromentId, {super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;
    ProductProvider productProvider = context.watch<FlutterProductProvider>();

    var productFuture = productProvider.getProductById(productId);

    TextEditingController textEditingController = TextEditingController();
    (() async {
      var product = await productFuture;
      if (product != null) {
        textEditingController.text = product.name;
      }
    })();

    RecipeProvider recipeProvider = context.watch<FlutterRecipeProvider>();

    var recepiesFuture = recipeProvider.getRecepiesOfProductById(productId);

    var recipeList = FutureBuilder(
      future: recepiesFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text(appLoc.loading);
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(8)),
            child: Searchablelistview<(RecipeProduct, Recipe)>(
              elements: snapshot.data!,
              elementToListTile: (recipe, tag) => ListTile(
                title: tag,
                subtitle: Text(recipe.$1.amount),
                trailing: IconButton(
                  icon: Icon(Icons.arrow_outward),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return RecipeDetail(recipe.$2.id);
                      },
                    ),
                  ),
                ),
              ),
              elementToTag: (recipe) => recipe.$2.name,
            ),
          ),
        );
      },
    );

    ScheduleProvider scheduleProvider = context.watch<FlutterScheduleProvider>();
    HouseProvider houseProvider = context.watch<FlutterHouseProvider>();

    var housesFuture = houseProvider.getHouseList(enviromentId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (s) {},
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Row(children: [Icon(Icons.delete), SizedBox(width: 8), Text(appLoc.delete)]),
                  onTap: () {
                    Navigator.pop(context);
                    productProvider.deleteProductById(productId);
                  },
                ),
                PopupMenuItem(
                  child: Row(children: [Icon(Icons.edit), SizedBox(width: 8), Text(appLoc.editName)]),
                  onTap: () {
                    TextEditingController textControler = TextEditingController();
                    productFuture.then((Product? p) {
                      textControler.text = p!.name;
                    });
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(appLoc.editName),
                          content: TextField(
                            decoration: InputDecoration(labelText: appLoc.name),
                            controller: textControler,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(appLoc.cancel),
                            ),
                            TextButton(
                              onPressed: () {
                                productProvider.setProductName(productId, textControler.text);
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
        title: FutureBuilder(
          future: productFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.name);
            }
            if (snapshot.hasError) {
              return Text("$snapshot");
            }
            return Text(appLoc.loading);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(appLoc.houses, style: Theme.of(context).textTheme.titleSmall),

            FutureBuilder<List<House>>(
              future: housesFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return SizedBox.shrink();
                return Column(
                  children: snapshot.data!.map((house) {
                    return ListTile(
                      title: Text(house.name),
                      subtitle: getNeededAmount(scheduleProvider, productId, [house.id], context),
                      trailing: NeededCheckbox(productId: productId, houseId: house.id),
                    );
                  }).toList(),
                );
              },
            ),

            Text(appLoc.recipeList, style: Theme.of(context).textTheme.titleSmall),

            SizedBox(height: 500, child: recipeList),
          ],
        ),
      ),
    );
  }
}
