import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/common/searchable_list_view.dart';
import 'package:lista_de_la_compra/flutter_providers/flutter_providers.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';
import 'package:provider/provider.dart';

class AddProductsToIsle extends StatelessWidget {
  final String aisleId;

  const AddProductsToIsle(this.aisleId, {super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;
    final ProductProvider productProvider = context.watch<FlutterProductProvider>();
    final AisleProvider aisleProvider = context.watch<FlutterAisleProvider>();
    final SuperMarketProvider supermarketProvider = context.watch<FlutterSuperMarketProvider>();
    final ProductAisleProvider productAisleProvider = context.watch<FlutterProductAisleProvider>();

    Future<Aisle?> aisleFuture = aisleProvider.getAisleById(aisleId);
    Future<SuperMarket?> supermarketFuture = aisleFuture.then((aisle) => supermarketProvider.getSuperMarketById(aisle!.marketId));
    Future<List<Product>> allProductsInEnvFuture = supermarketFuture.then(
      (supermarket) => productProvider.getDisplayProductList(supermarket!.enviromentId),
    );

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: Future.wait([aisleFuture, supermarketFuture]),
          builder: (context, snap) {
            if (snap.hasData) {
              final Aisle? aisle = snap.data![0] as Aisle?;
              final SuperMarket? market = snap.data![1] as SuperMarket?;
              final String aisleName = aisle?.name ?? '...';
              final String marketName = market?.name ?? '...';
              return Text(appLoc.addProductsToAisle(aisleName, marketName));
            } else {
              return Text(appLoc.addProductsToAisle("...", "..."));
            }
          },
        ),
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
        future: allProductsInEnvFuture,
        builder: (context, asyncSnapshot) {
          if (!asyncSnapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final List<Product> allProducts = asyncSnapshot.data!;
          return Searchablelistview(
            elements: allProducts,
            elementToTag: (Product p) => p.name,
            newElement: (String name) async {
              String productId = await productProvider.addProduct(name, false, (await supermarketFuture)!.enviromentId);

              productAisleProvider.setProductInAisle(productId, aisleId, true);
            },
            elementToListTile: (Product product, tag) => ListTile(
              title: tag,
              trailing: FutureBuilder(
                future: aisleProvider.isProductInAisle(aisleId, product.id),
                builder: (context, asyncSnapshot) {
                  if (!asyncSnapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  bool isInAisle = asyncSnapshot.data!;
                  return Checkbox(
                    value: isInAisle,
                    onChanged: (value) {
                      productAisleProvider.setProductInAisle(product.id, aisleId, value == true);
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
