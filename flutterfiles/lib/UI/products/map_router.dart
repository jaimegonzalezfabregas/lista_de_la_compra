import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/common/searchable_list_view.dart';
import 'package:lista_de_la_compra/UI/supermarket/add_products_to_isle.dart';
import 'package:lista_de_la_compra/flutter_providers/flutter_providers.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra/map_engine/preview/map_preview.dart';
import 'package:lista_de_la_compra/shared_preference_providers/persistant_selected_market_provider.dart';
import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';
import 'package:provider/provider.dart';
import 'package:lista_de_la_compra/UI/products/product_list_display.dart';

class MapRouter extends StatelessWidget {
  final String enviromentId;

  const MapRouter(this.enviromentId, {super.key});

  @override
  Widget build(BuildContext context) {
    final SuperMarketProvider superMarketProvider = context.watch<FlutterSuperMarketProvider>();
    final ProductProvider productProvider = context.watch<FlutterProductProvider>();
    final SelectedMarketProvider selectedSupermarketProvider = context.watch<PersistantSelectedMarketProvider>();
    final AppLocalizations appLoc = AppLocalizations.of(context)!;
    Future<String?> supermarketIdFuture = selectedSupermarketProvider.getSelectedSupermarket(enviromentId);

    Future<SuperMarket?> supermarketFuture = supermarketIdFuture.then(
      (String? supermarketId) async => supermarketId != null ? await superMarketProvider.getSuperMarketById(supermarketId) : null,
    );

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: supermarketFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.name);
            }
            if (snapshot.hasError) {
              return Text("Route for $snapshot"); // TODO Internationalize
            }
            return Text(appLoc.loading);
          },
        ),

        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(appLoc.map, style: Theme.of(context).textTheme.titleSmall),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: FutureBuilder(
                future: supermarketIdFuture,
                builder: (context, asyncSnapshot) {
                  if (!asyncSnapshot.hasData) {
                    return Text(appLoc.loading);
                  }

                  return MapPreview(asyncSnapshot.data!);
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(appLoc.aisles, style: Theme.of(context).textTheme.titleSmall),
            ),
            FutureBuilder<List<Product>>(
              future: productProvider.getDisplayProductList(enviromentId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var allProducts = snapshot.data!;

                return TabBarView(
                  children: [ProductListDisplay(allProducts, true, enviromentId), ProductListDisplay(allProducts, false, enviromentId)],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
