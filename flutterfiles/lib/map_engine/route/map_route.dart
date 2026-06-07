import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/products/product_list_display.dart';
import 'package:lista_de_la_compra/flutter_providers/flutter_providers.dart';
import 'package:lista_de_la_compra/flutter_providers/temp_route_provider.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra/map_engine/tiles/tile_type.dart';
import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';
import 'package:provider/provider.dart';

import 'route_game.dart';
import '../map_utils.dart';

export '../editor/map_editor.dart' show MapEditor;

Future<String?> firstNeededAisle(JRoute route, List<Product> products, ProductAisleProvider productAsileProvider, String supermarketId) async {
  Set<String> neededAisles = {};

  for (Product p in products) {
    if (p.needed) {
      neededAisles.addAll((await productAsileProvider.getAisleOfProductInSupermarket(p.id, supermarketId)).map((a) => a.id));
    }
  }

  for (String? aisleId in route.steps.map((s) => s.goalAisleId)) {
    if (aisleId == null) {
      continue;
    }

    if (neededAisles.contains(aisleId)) {
      return aisleId;
    }
  }

  return null;
}

class MapRouter extends StatelessWidget {
  final String supermarketId;
  final String enviromentId;
  final int floor;
  final JRoute route;

  const MapRouter({super.key, required this.supermarketId, required this.enviromentId, required this.floor, required this.route});

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    final MapTileProvider mapTileProvider = context.watch<FlutterMapTileProvider>();
    final AisleProvider aisleProvider = context.watch<FlutterAisleProvider>();
    final ProductProvider productProvider = context.watch<FlutterProductProvider>();
    final ProductAisleProvider productAsileProvider = context.watch<FlutterProductAisleProvider>();

    return FutureBuilder(
      future: productProvider.getDisplayProductList(enviromentId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text(appLoc.loading);
        }
        var allProducts = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
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
                      builder: (context, tileSnapshot) {
                        if (!tileSnapshot.hasData || tileSnapshot.data == null) return Text(appLoc.loading);
                        if (tileSnapshot.data!.isEmpty) return Text(appLoc.noMappingDataAviable);
          
                        List<MapTile> tiles = tileSnapshot.data!;
          
                        return FutureBuilder(
                          future: buildTileToTypeMap(tiles, aisleProvider, supermarketId),
                          builder: (context, tileTypeSnapshot) {
                            if (!tileTypeSnapshot.hasData || tileTypeSnapshot.data == null) return Text(appLoc.loading);
          
                            Map<String, TileType> tileToTileType = tileTypeSnapshot.data!;
          
                            return FutureBuilder(
                              future: firstNeededAisle(route, allProducts, productAsileProvider, supermarketId),
                              builder: (context, asyncSnapshot) {
                                if ( asyncSnapshot.connectionState != ConnectionState.done) {
                                  return Text(appLoc.loading);
                                }

                                String? nextAisleId = asyncSnapshot.data;
          
                                return GameWidget(game: RouteGame(tiles, tileToTileType, route, nextAisleId));
                              },
                            );
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
          
              ProductListDisplay(
                allProducts,
                true,
                enviromentId,
                categoryOrdering: route.steps.map((step) => step.goalAisleId).whereType<String>().toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
