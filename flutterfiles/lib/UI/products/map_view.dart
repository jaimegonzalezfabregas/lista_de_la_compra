import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/supermarket/supermarket_detail.dart';
import 'package:lista_de_la_compra/flutter_providers/flutter_providers.dart';
import 'package:lista_de_la_compra/flutter_providers/temp_route_provider.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra/map_engine/route/engine.dart';
import 'package:lista_de_la_compra/map_engine/route/map_route.dart';
import 'package:lista_de_la_compra/shared_preference_providers/persistant_selected_market_provider.dart';
import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';
import 'package:provider/provider.dart';
import 'package:lista_de_la_compra/UI/products/product_list_display.dart';
import 'package:async_filter/async_filter.dart';
import 'package:dynamic_height_list_view/dynamic_height_view.dart';

class MarketSelectorScreen extends StatelessWidget {
  final String enviromentId;

  const MarketSelectorScreen(this.enviromentId, {super.key});

  @override
  Widget build(BuildContext context) {
    final SuperMarketProvider superMarketProvider = context.watch<FlutterSuperMarketProvider>();
    final SelectedMarketProvider selectedSupermarketProvider = context.watch<PersistantSelectedMarketProvider>();
    final MapTileProvider mapTileProvider = context.watch<FlutterMapTileProvider>();
    final AppLocalizations appLoc = AppLocalizations.of(context)!;

    Future<Widget> selectorWidgetFuture = (() async {
      String? selectedSupermarketId = await selectedSupermarketProvider.getSelectedSupermarket(enviromentId);

      List<SuperMarket> supermarketList = await superMarketProvider.getDisplaySuperMarketList(enviromentId);

      List<SuperMarket> supermarketListWithMaps = await supermarketList.asyncFilter(
        (market) async => (await mapTileProvider.getFloorsOfMarket(market.id)).isNotEmpty,
      );
      List<SuperMarket> supermarketListWithoutMaps = await supermarketList.asyncFilter(
        (market) async => (await mapTileProvider.getFloorsOfMarket(market.id)).isEmpty,
      );

      Widget supermarketListWithoutMapsList = DynamicHeightGridView(
        itemCount: supermarketListWithoutMaps.length,

        builder: (context, index) {
          SuperMarket market = supermarketListWithoutMaps[index];
          return ListTile(
            leading: market.id != selectedSupermarketId ? Icon(Icons.image_not_supported_outlined) : Icon(Icons.image_not_supported),

            titleAlignment: ListTileTitleAlignment.center,
            subtitle: Text("Add map"),
            title: Text(market.name),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return SupermarketDetail(market.id);
                },
              ),
            ),
          );
        },

        shrinkWrap: true,
        crossAxisCount: 2,
      );

      Widget supermarketListWithMapsList = DynamicHeightGridView(
        shrinkWrap: true,
        crossAxisCount: 2,

        itemCount: supermarketListWithMaps.length,
        builder: (context, index) {
          SuperMarket market = supermarketListWithMaps[index];
          return ListTile(
            leading: Icon(Icons.radio_button_off),
            onTap: () => selectedSupermarketProvider.setSelectedSupermarket(enviromentId, market.id),
            title: Text(market.name),
          );
        },
      );

      if (selectedSupermarketId == null) {
        if (supermarketList.isEmpty) {
          return Text("Please create a supermarket and define its map before planning a route");
        }

        if (supermarketListWithMaps.isEmpty) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Text("There is no supermarket with a inputed map. Please input a map into any of the supermarkets before planning a route"),
                supermarketListWithoutMapsList,
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              Text("No selected supermarket; Select a supermarket with maps"),
              supermarketListWithMapsList,
              Text("Otherwise please input a map into any of the other supermarkets"),
              supermarketListWithoutMapsList,
            ],
          ),
        );
      } else {
        if ((await mapTileProvider.getFloorsOfMarket(selectedSupermarketId)).isEmpty) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Text("The selected supermarket has no loaded maps. You can either a supermarket with maps ..."),
                supermarketListWithMapsList,
                Text("... or please input a map into any of the other supermarkets"),
                supermarketListWithoutMapsList,
              ],
            ),
          );
        }

        return CalculateRouteScreen(selectedSupermarketId, enviromentId);
      }
    })();

    return FutureBuilder(
      future: selectorWidgetFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text(appLoc.loading);
        }

        return snapshot.data!;
      },
    );
  }
}

class CalculateRouteScreen extends StatelessWidget {
  final String supermarketId;
  final String enviromentId;

  const CalculateRouteScreen(this.supermarketId, this.enviromentId, {super.key});

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    final MapTileProvider mapTileProvider = context.watch<FlutterMapTileProvider>();
    final AisleProvider aisleProvider = context.watch<FlutterAisleProvider>();
    final ProductAisleProvider productAisleProvider = context.watch<FlutterProductAisleProvider>();
    final RouteProvider routeProvider = context.watch<RouteProvider>();
    final ProductProvider productProvider = context.watch<FlutterProductProvider>();

    if (routeProvider.getProgress() == 1) {
      return MapRouter(supermarketId, enviromentId);
    }

    return Center(
      child: FutureBuilder(
        future: getPendingVisitAsileIds(productProvider, productAisleProvider, supermarketId, enviromentId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text(appLoc.loading);
          }

          Set<Aisle> visitingAisles = snapshot.data!;

          if (visitingAisles.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(50.0),
              child: Text("There are no asiles to visit given the needed products. No route can be calculated"),
            ); // TODO Internationalize
          }

          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Pending aisles to visit", style: const TextStyle(fontWeight: FontWeight.bold)),
                ListView(
                  shrinkWrap: true,
                  children: visitingAisles.map((aisle) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(padding: const EdgeInsets.all(8.0), child: Icon(Icons.shelves)),
                            Text(aisle.name),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                Divider(),
                if (routeProvider.getProgress() == null)
                  TextButton.icon(
                    onPressed: () async {
                      calculateTileRoute(supermarketId, routeProvider, mapTileProvider, aisleProvider, visitingAisles);
                    },
                    label: Text("Calculate route"),
                    icon: Icon(Icons.calculate),
                  )
                else
                  Column(
                    children: [
                      Text("progress: ${(routeProvider.getProgress() ?? 0) * 100}%"),

                      TextButton.icon(
                        onPressed: () async {
                          abortCalculateTileRoute(routeProvider);
                        },
                        label: Text("Cancel route calculation"),
                        icon: Icon(Icons.cancel),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}


class FloorSelector extends StatefulWidget {
  final String supermarketId;
  final String enviromentId;

  const FloorSelector(this.supermarketId, this.enviromentId, {super.key});

  @override
  State<FloorSelector> createState() => _FloorSelectorState();
}


class _FloorSelectorState extends State<FloorSelector> {
  int floor = 0;
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }


}

class MapView extends StatelessWidget {
  final String enviromentId;

  const MapView(this.enviromentId, {super.key});

  @override
  Widget build(BuildContext context) {
    final SuperMarketProvider superMarketProvider = context.watch<FlutterSuperMarketProvider>();
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
            if (snapshot.data == null) {
              return Text("Select a supermarket"); // TODO Internationalize
            }
            if (snapshot.hasError) {
              return Text("Route for $snapshot"); // TODO Internationalize
            }
            return Text(appLoc.loading);
          },
        ),

        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),

      body: MarketSelectorScreen(enviromentId),


    );
  }
}
