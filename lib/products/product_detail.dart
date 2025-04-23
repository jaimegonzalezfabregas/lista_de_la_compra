import 'package:flutter/material.dart';
import 'package:jhopping_list/common/searchable_list_view.dart';
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

    var product = productProvider.getProductById(productId);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Producto no encontrado")),
        body: Center(
          child: Text("Es probable que el producto haya sido eliminado."),
        ),
      );
    }

    TextEditingController textEditingController = TextEditingController();
    textEditingController.text = product.name;

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
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
                  onPressed: () {
                    productProvider.setProductName(
                      product.id,
                      textEditingController.text,
                    );
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
                    onPressed: () {
                      productProvider.setProductNeededness(
                        product.id,
                        !product.needed,
                      );
                    },
                    child: Text(
                      product.needed
                          ? "Marcar como comprado"
                          : "Marcar como por comprar",
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      productProvider.deleteProductById(product.id);
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
                future: productProvider.getRecepiesOfProductById(product.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Searchablelistview(
                      elements: snapshot.data!,
                      elementToListTile:
                          (recipe, tag) => ListTile(
                            title: tag,
                            onLongPress:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => RecipeDetail(recipe.id),
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
