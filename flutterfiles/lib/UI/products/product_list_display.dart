import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/common/needed_checkbox.dart';
import 'package:lista_de_la_compra/UI/common/searchable_list_view.dart';
import 'package:lista_de_la_compra/UI/products/common.dart';
import 'package:lista_de_la_compra/UI/products/product_detail.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra/shared_preference_providers/persistant_selected_market_provider.dart';
import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';
import 'package:provider/provider.dart';
import '../../flutter_providers/flutter_providers.dart';

class ProductListDisplay extends StatelessWidget {
  final List<Product> products;
  final bool isNeededList;
  final String enviromentId;
  final List<String> selectedHouseIds;
  final List<String> categoryOrdering;

  const ProductListDisplay(
    this.products,
    this.isNeededList,
    this.enviromentId,
    this.selectedHouseIds, {
    super.key,
    this.categoryOrdering = const [],
  });

  @override
  Widget build(BuildContext context) {
    ScheduleProvider scheduleProvider = context.watch<FlutterScheduleProvider>();
    final ProductProvider productProvider = context.watch<FlutterProductProvider>();
    final SelectedMarketProvider selectedMarketProvider = context.watch<PersistantSelectedMarketProvider>();
    final ProductAisleProvider productAisleProvider = context.watch<FlutterProductAisleProvider>();
    final NeededProductProvider neededProductProvider = context.watch<FlutterNeededProductProvider>();
    final HouseProvider houseProvider = context.watch<FlutterHouseProvider>();
    final AppLocalizations appLoc = AppLocalizations.of(context)!;

    return FutureBuilder<List<House>>(
      future: houseProvider.getHouseList(enviromentId),
      builder: (context, houseSnapshot) {
        var allHouses = houseSnapshot.data ?? [];
        var selectedHouses = allHouses.where((h) => selectedHouseIds.contains(h.id)).toList();

        return FutureBuilder<Set<String>>(
          future: neededProductProvider.getNeededProductIds(enviromentId, selectedHouseIds),
          builder: (context, neededSnapshot) {
            var neededProductIds = neededSnapshot.data ?? {};

            var displayProducts = isNeededList
                ? products.where((p) => neededProductIds.contains(p.id)).toList()
                : products;

            return Searchablelistview<Product>(
              elements: displayProducts,
              elementsOnSearch: products,
              elementToListTile: (Product p, RichText tag) {
                return ListTile(
                  title: tag,
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       getNeededAmount(scheduleProvider, p.id, selectedHouseIds, context),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (selectedHouseIds.isNotEmpty)
                        ...selectedHouses.map((house) {
                          return NeededCheckbox(
                            productId: p.id,
                            houseId: house.id,
                            delay: isNeededList ? Duration(milliseconds: 200) : null,
                          );
                        }),
                      if (selectedHouseIds.isEmpty)
                        Text(appLoc.noHouseSelected),
                      IconButton(
                        icon: const Icon(Icons.arrow_outward),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetail(p.id, enviromentId)));
                        },
                      ),
                    ],
                  ),
                );
              },
              elementToTag: (Product p) => p.name,
              newElement: (String name) async {
                var allProducts = await productProvider.getDisplayProductList(enviromentId);
                if (allProducts.any((e) => e.name.toLowerCase() == name.toLowerCase())) {
                  var referenced = allProducts.firstWhere((e) => e.name.toLowerCase() == name.toLowerCase());
                  for (var houseId in selectedHouseIds) {
                    neededProductProvider.setNeeded(houseId, referenced.id, true);
                  }
                } else {
                  String newId = await productProvider.addProduct(name, enviromentId);
                  for (var houseId in selectedHouseIds) {
                    neededProductProvider.setNeeded(houseId, newId, true);
                  }
                }
              },
              elementCategories: (Product p) async {
                String? selectedSupermarket = await selectedMarketProvider.getSelectedSupermarket(enviromentId);

                if (selectedSupermarket == null) {
                  return [];
                }

                var aisles = await productAisleProvider.getAisleOfProductInSupermarket(p.id, selectedSupermarket);
                return aisles.map((a) => (a.id, a.name)).toList();
              },
              categoryOrdering: categoryOrdering,
            );
          },
        );
      },
    );
  }
}
