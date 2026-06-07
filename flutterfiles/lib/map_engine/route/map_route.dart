import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/products/product_list_display.dart';
import 'package:lista_de_la_compra/flutter_providers/flutter_providers.dart';
import 'package:lista_de_la_compra/flutter_providers/temp_route_provider.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra/map_engine/editor/map_editor.dart';
import 'package:lista_de_la_compra/map_engine/route/engine.dart';
import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';
import 'package:provider/provider.dart';

import 'route_game.dart';
import '../map_utils.dart';

export '../editor/map_editor.dart' show MapEditor;

class MapRouter extends StatelessWidget {
  final String supermarketId;
  final String enviromentId;
  final int floor;
  final GroceryRoute route;

  const MapRouter({super.key, required this.supermarketId, required this.enviromentId, required this.floor, required this.route});

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    final MapTileProvider mapTileProvider = context.watch<FlutterMapTileProvider>();
    final AisleProvider aisleProvider = context.watch<FlutterAisleProvider>();
    final RouteProvider routeProvider = context.watch<RouteProvider>();
    final ProductProvider productProvider = context.watch<FlutterProductProvider>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              elevation: 20,
              color: Theme.of(context).colorScheme.surfaceContainer,
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder(
                  future: mapTileProvider.getMapOfMarket(supermarketId, floor),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data == null) return Text(appLoc.loading);
                    if (snapshot.data!.isEmpty) return Text(appLoc.noMappingDataAviable);

                    return FutureBuilder(
                      future: buildTileToTypeMap(snapshot.data!, aisleProvider, supermarketId),
                      builder: (context, aisleSnapshot) {
                        if (!aisleSnapshot.hasData || aisleSnapshot.data == null) return Text(appLoc.loading);
                        return GameWidget(game: RouteGame(snapshot.data!, aisleSnapshot.data!, route));
                      },
                    );
                  },
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(appLoc.shoppingList, style: Theme.of(context).textTheme.titleSmall),
          ),

          FutureBuilder(
            future: productProvider.getDisplayProductList(enviromentId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              var allProducts = snapshot.data!;

              return ProductListDisplay(allProducts, true, enviromentId, {categoryOrdering:route});
            },
          ),
        ],
      ),
    );
  }
}
