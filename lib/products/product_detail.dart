import 'package:flutter/material.dart';
import 'package:jhopping_list/common/searchable_list_view.dart';
import 'package:jhopping_list/db/database.dart';
import 'package:jhopping_list/products/product_provider.dart';
import 'package:jhopping_list/recipies/recipe_detail.dart';
import 'package:provider/provider.dart';

// todo
// see history
// see locations in diferent markets

class ProductDetail extends StatelessWidget {
  final int productId;

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

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: productFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return Text(snapshot.data!.name);
            } else {
              return Text("Error"); // TODO
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nombre del producto',
                      ),
                      controller: textEditingController,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    var product = (await productFuture);

                    if (product != null) {
                      productProvider.setProductName(
                        productId,
                        textEditingController.text,
                      );
                    } else {
                      // TODO
                    }
                  },
                  child: Text("Guardar"),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      var product = (await productFuture);
                      if (product != null) {
                        productProvider.setProductNeededness(
                          productId,
                          !product.needed,
                        );
                      } else {
                        // TODO
                      }
                    },
                    child: FutureBuilder(
                      future: productFuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          return Text(
                            snapshot.data!.needed
                                ? "Marcar como comprado"
                                : "Marcar como por comprar",
                          );
                        } else {
                          return Text("Error"); // TODO
                        }
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      productProvider.deleteProductById(productId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Danger color
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: const Text("Eliminar Producto"),
                  ),
                ],
              ),
            ),
            Divider(),

            Text("Mapas", style: Theme.of(context).textTheme.headlineMedium),
            Divider(),
            Text("Recetas", style: Theme.of(context).textTheme.headlineMedium),
            Expanded(
              child: FutureBuilder(
                future: productProvider.getRecepiesOfProductById(productId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Searchablelistview<Recipe>(
                      elements: snapshot.data!,
                      elementToListTile:
                          (recipe, tag) => ListTile(
                            title: tag,
                            onLongPress:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return RecipeDetail(recipe.id);
                                    },
                                  ),
                                ),
                          ),
                      elementToTag: (recipe) => recipe.name,
                    );
                  }
                  return Text("Cargando...");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
