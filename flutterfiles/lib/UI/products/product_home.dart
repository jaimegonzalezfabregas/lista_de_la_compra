import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/route_planning/map_view.dart';
import 'package:lista_de_la_compra/UI/products/product_list_display.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
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
          title: Text(appLoc.shoppingList),
          actions: [
            ElevatedButton.icon(
              label: Text(appLoc.optimizeRoute),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MapView(enviromentId)));
              },
              icon: Icon(Icons.route),
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

            return TabBarView(children: [ProductListDisplay(allProducts, true, enviromentId), ProductListDisplay(allProducts, false, enviromentId)]);
          },
        ),
      ),
    );
  }
}
