import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/products/product_list_display.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra/shared_preference_providers/persistant_shared_preferences_provider.dart';
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
    final SharedPreferencesProvider sharedPreferencesProvider = context.watch<PersistantSharedPreferencesProvider>();
    final SuperMarketProvider superMarketProvider = context.watch<FlutterSuperMarketProvider>();

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
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(appLoc.shoppingList),
              SizedBox(width: 50.0),
              FutureBuilder(
                future: Future.wait([
                  superMarketProvider.getDisplaySuperMarketList(enviromentId),
                  sharedPreferencesProvider.getSelectedSupermarket(enviromentId),
                ]),
                builder: (context, asyncSnapshot) {
                  if (!asyncSnapshot.hasData) {
                    return SizedBox.shrink();
                  }
                  final List<SuperMarket> supermarkets = asyncSnapshot.data![0] as List<SuperMarket>;
                  final String? selectedSupermarket = asyncSnapshot.data![1] as String?;

                  return Flexible(
                    child: Container(
                      margin: EdgeInsets.only(left: 16.0),
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,

                        items: (supermarkets
                            .map(
                              (m) => DropdownMenuItem(
                                value: m.id,
                                child: Text(m.name, overflow: TextOverflow.ellipsis),
                              ),
                            )
                            .toList()),
                        onChanged: (String? selectedId) {
                          if (selectedId != null) {
                            sharedPreferencesProvider.setSelectedSupermarket(enviromentId, selectedId);
                          } else {
                            sharedPreferencesProvider.clearSelectedSupermarket(enviromentId);
                          }
                        },
                        initialValue: selectedSupermarket,

                        hint: Text(appLoc.selectSupermarket),
                      ),
                    ),
                  );
                },
              ),

              FutureBuilder(
                future: sharedPreferencesProvider.getSelectedSupermarket(enviromentId),
                builder: (context, asyncSnapshot) {
                  if (!asyncSnapshot.hasData || asyncSnapshot.data == null) {
                    return SizedBox.shrink();
                  }
                  return IconButton(onPressed: () => sharedPreferencesProvider.clearSelectedSupermarket(enviromentId), icon: Icon(Icons.clear));
                },
              ),
            ],
          ),
        ),
        body: FutureBuilder<List<Product>>(
          future: productProvider.getDisplayProductList(enviromentId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            var allProducts = snapshot.data!;

            return TabBarView(children: [ProductListDisplay(allProducts, true, enviromentId), ProductListDisplay(allProducts, false, enviromentId)]);
          },
        ),
      ),
    );
  }
}
