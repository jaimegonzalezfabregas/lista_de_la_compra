import 'package:flutter/material.dart';
import 'package:jhopping_list/UI/common/searchable_list_view.dart';
import 'package:jhopping_list/UI/products/common.dart';
import 'package:jhopping_list/db/database.dart';
import 'package:jhopping_list/providers/product_provider.dart';
import 'package:jhopping_list/UI/recipies/recipe_detail.dart';
import 'package:jhopping_list/providers/recipe_provider.dart';
import 'package:jhopping_list/UI/common/loading_box.dart';
import 'package:jhopping_list/providers/schedule_provider.dart';
import 'package:provider/provider.dart';

// todo
// see history
// see locations in diferent markets

class ProductDetail extends StatelessWidget {
  final String productId;

  const ProductDetail(this.productId, {super.key});

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = context.watch();

    var productFuture = productProvider.getProductById(productId);

    TextEditingController textEditingController = TextEditingController();
    (() async {
      var product = await productFuture;
      if (product != null) {
        textEditingController.text = product.name;
      }
    })();

    RecipeProvider recipeProvider = context.watch();

    var recepiesFuture = recipeProvider.getRecepiesOfProductById(productId);

    var recipeList = FutureBuilder(
      future: recepiesFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingBox();
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(8)),
            child: Searchablelistview<(RecipeProduct, Recipe)>(
              elements: snapshot.data!,
              elementToListTile:
                  (recipe, tag) => ListTile(
                    title: tag,
                    subtitle: Text(recipe.$1.amount),
                    trailing: IconButton(
                      icon: Icon(Icons.arrow_outward),
                      onPressed:
                          () => Navigator.push(
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
              elementToSubtitle: (recipe) => recipe.$1.amount,
            ),
          ),
        );
      },
    );

    ScheduleProvider scheduleProvider = context.watch();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (s) {},
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Row(children: [Icon(Icons.delete), SizedBox(width: 8), Text("Eliminar")]),
                  onTap: () {
                    Navigator.pop(context);
                    productProvider.deleteProductById(productId);
                  },
                ),
                PopupMenuItem(
                  child: Row(children: [Icon(Icons.edit), SizedBox(width: 8), Text("Editar nombre")]),
                  onTap: () {
                    TextEditingController textControler = TextEditingController();
                    productFuture.then((Product? p) {
                      textControler.text = p!.name;
                    });
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Editar nombre"),
                          content: TextField(decoration: InputDecoration(labelText: "Nombre"), controller: textControler),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Cancelar"),
                            ),
                            TextButton(
                              onPressed: () {
                                productProvider.setProductName(productId, textControler.text);
                                Navigator.of(context).pop();
                              },
                              child: Text("Guardar"),
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
              return Text("Error! :(");
            }
            return Text("Cargando...");
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  getNeededAmount(scheduleProvider,productId)!,
                  TextButton(
                    onPressed: () async {
                      var product = (await productFuture);
                      if (product != null) {
                        productProvider.setProductNeededness(productId, !product.needed);
                      }
                    },
                    child: FutureBuilder(
                      future: productFuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          return Text(snapshot.data!.needed ? "Marcar como comprado" : "Marcar como por comprar");
                        }else{
                          return Text("Cargando...");
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            Text("Recetas", style: Theme.of(context).textTheme.titleSmall),

            SizedBox(height: 200, child: recipeList),
            Text("Mapas", style: Theme.of(context).textTheme.titleSmall),
          ],
        ),
      ),
    );
  }
}
