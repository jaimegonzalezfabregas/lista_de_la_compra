import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/products/product_list_display.dart';
import 'package:lista_de_la_compra/flutter_providers/flutter_providers.dart';
import 'package:lista_de_la_compra/flutter_providers/temp_route_provider.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra/map_engine/tiles/tile_type.dart';
import 'package:lista_de_la_compra/shared_preference_providers/persistent_selected_houses_provider.dart';
import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';
import 'package:provider/provider.dart';

import 'route_game.dart';
import '../map_utils.dart';

export '../editor/map_editor.dart' show MapEditor;

Future<String?> firstNeededAisle(
  JRoute route,
  List<Product> products,
  ProductAisleProvider productAsileProvider,
  String supermarketId, 
  Set<String> neededProductIds,
) async {
  Set<String> neededAisles = {};

  for (Product p in products) {
    if (neededProductIds.isEmpty || neededProductIds.contains(p.id)) {
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

class MapGameWidget extends StatefulWidget {
  final List<MapTile> tiles;
  final Map<String, TileType> tileToTileType;
  final JRoute route;
  final String? nextAisleId;

  const MapGameWidget({
    super.key,
    required this.tiles,
    required this.tileToTileType,
    required this.route,
    required this.nextAisleId,
  });

  @override
  State<MapGameWidget> createState() => _MapGameWidgetState();
}

class _MapGameWidgetState extends State<MapGameWidget> {
  late final RouteGame _game;

  @override
  void initState() {
    super.initState();
    _game = RouteGame(widget.tiles, widget.tileToTileType, widget.route, widget.nextAisleId);
  }

  @override
  void didUpdateWidget(MapGameWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.nextAisleId != oldWidget.nextAisleId) {
      _game.updateNextAisle(widget.nextAisleId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: _game);
  }
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
    final NeededProductProvider neededProductProvider = context.watch<FlutterNeededProductProvider>();
    final SelectedHousesProvider selectedHousesProvider = context.watch<PersistentSelectedHousesProvider>();

    return FutureBuilder(
      future: productProvider.getDisplayProductList(enviromentId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text(appLoc.loading);
        }
        var allProducts = snapshot.data!;

        return FutureBuilder(
          future: selectedHousesProvider.getSelectedHouses(enviromentId),
          builder: (context, housesSnapshot) {
            if (!housesSnapshot.hasData) {
              return Text(appLoc.loading);
            }
            var selectedHouseIds = housesSnapshot.data!;

            return FutureBuilder(
              future: neededProductProvider.getNeededProductIds(enviromentId, selectedHouseIds),
              builder: (context, neededSnapshot) {
                if (!housesSnapshot.hasData) {
                  return Text(appLoc.loading);
                }
                var neededProductIds = neededSnapshot.data!;

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
                                      future: firstNeededAisle(
                                        route,
                                        allProducts,
                                        productAsileProvider,
                                        supermarketId,
                                        neededProductIds,
                                      ),
                                      builder: (context, asyncSnapshot) {
                                        if (asyncSnapshot.connectionState != ConnectionState.done) {
                                          return Text(appLoc.loading);
                                        }

                                        String? nextAisleId = asyncSnapshot.data;

                                        return MapGameWidget(tiles: tiles, tileToTileType: tileToTileType, route: route, nextAisleId: nextAisleId);
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
                        selectedHouseIds,
                        categoryOrdering: route.steps.map((step) => step.goalAisleId).whereType<String>().toList(),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
