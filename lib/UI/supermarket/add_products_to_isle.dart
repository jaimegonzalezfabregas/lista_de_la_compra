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
    Future<List<Product>> allProductsInEnvFuture = aisleProvider
        .getAisleById(aisleId)
        .then(
          (aisle) => supermarketProvider
              .getSuperMarketById(aisle!.marketId)
              .then((supermarket) => productProvider.getDisplayProductList(supermarket!.enviromentId)),
        );

    return Scaffold(
      appBar: AppBar(title: Text(appLoc.addProductsToAisle)),
      body: FutureBuilder(
        future: allProductsInEnvFuture,
        builder: (context, asyncSnapshot) {
          if (!asyncSnapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var allProducts = asyncSnapshot.data!;
          return Searchablelistview(
                        elementToTag: (Product p) => p.name,

            elements: allProducts,
            elementToListTile: (Product p, tag) => ListTile(
              title: tag,
              trailing: Builder(builder: (builder) {
                return FutureBuilder(
                  future: aisleProvider.isProductInAisle(aisleId, p.id),
                  builder: (context, asyncSnapshot) {
                    if (!asyncSnapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    bool isInAisle = asyncSnapshot.data!;
                     return Checkbox(
                        value: isInAisle,
                        onChanged: (value) {
                          productAisleProvider.setProductInAisle(p.id, aisleId, value == true);
                        },
                      ); 
                    
                  },
                );
              }
              )
            ),
          );
        },
      ),
    );
  }
}
