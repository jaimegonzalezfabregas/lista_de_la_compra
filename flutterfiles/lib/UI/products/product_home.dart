import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/houses/house_selector.dart';
import 'package:lista_de_la_compra/UI/route_planning/map_view.dart';
import 'package:lista_de_la_compra/UI/products/product_list_display.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra/shared_preference_providers/persistent_selected_houses_provider.dart';
import 'package:provider/provider.dart';
import '../../flutter_providers/flutter_providers.dart';

import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';

class ProductHome extends StatelessWidget {
  final String enviromentId;
  const ProductHome(this.enviromentId, {super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;
    final ProductProvider productProvider = context.watch<FlutterProductProvider>();
    final EnvironmentProvider enviromentProvider = context.watch<FlutterEnvironmentProvider>();
    final selectedHousesProvider = context.watch<PersistentSelectedHousesProvider>();

    return FutureBuilder<List<String>>(
      future: selectedHousesProvider.getSelectedHouses(enviromentId),
      builder: (context, housesSnapshot) {
        final selectedHouseIds = housesSnapshot.data ?? [];

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.shopping_cart), child: Text(appLoc.buy)),
                  Tab(icon: Icon(Icons.list), child: Text(appLoc.all)),
                ],
              ),
              title: FutureBuilder(
                future: enviromentProvider.getEnvironmentById(enviromentId),
                builder: (context, enviromentSnapshot) {
                  if (!enviromentSnapshot.hasData) {
                    return Text(appLoc.loading);
                  }
                  Enviroment env = enviromentSnapshot.data!;
                  return Text(env.name);
                },
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: HouseSelector(enviromentId: enviromentId),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    label: Text(appLoc.optimizeRoute),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MapView(enviromentId)));
                    },
                    icon: Icon(Icons.route),
                  ),
                ),
              ],
            ),
            body: FutureBuilder<List<Product>>(
              future: productProvider.getDisplayProductList(enviromentId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var allProducts = snapshot.data!;

                return TabBarView(
                  children: [
                    selectedHouseIds.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(padding: const EdgeInsets.all(8.0), child: Icon(Icons.home_outlined)),
                                Text(appLoc.selectHousesPrompt),
                              ],
                            ),
                          )
                        : ProductListDisplay(allProducts, true, enviromentId, selectedHouseIds),
                    ProductListDisplay(allProducts, false, enviromentId, selectedHouseIds),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
