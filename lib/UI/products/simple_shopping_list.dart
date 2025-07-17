import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/common/needed_checkbox.dart';
import 'package:lista_de_la_compra/UI/common/searchable_list_view.dart';
import 'package:lista_de_la_compra/UI/products/common.dart';
import 'package:lista_de_la_compra_http_server/src/db/database.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra_http_server/src/db_providers/product_provider.dart';
import 'package:lista_de_la_compra/UI/products/product_detail.dart';
import 'package:lista_de_la_compra_http_server/src/db_providers/schedule_provider.dart';
import 'package:provider/provider.dart';

import '../../flutter_providers/flutter_providers.dart';

class ProductListDisplay extends StatelessWidget {
  final List<Product> products;
  final bool isNeededList;
  final String enviromentId;

  const ProductListDisplay(this.products, this.isNeededList, this.enviromentId, {super.key});

  @override
  Widget build(BuildContext context) {
    ScheduleProvider scheduleProvider = context.watch<FlutterScheduleProvider>();
    final ProductProvider productProvider = context.watch<FlutterProductProvider>();

    var filteredProducts = isNeededList ? products.where((e) => e.needed).toList() : products;

    return Searchablelistview<Product>(
      elements: filteredProducts,
      searchElements: products,
      elementToListTile: (Product p, RichText tag) {
        return ListTile(
          title: tag,
          subtitle: getNeededAmount(scheduleProvider, p.id),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              NeededCheckbox(p.id, delay: isNeededList ? Duration(milliseconds: 200) : null),
              IconButton(
                icon: const Icon(Icons.arrow_outward),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetail(p.id)));
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
          productProvider.setProductNeededness(referenced.id, isNeededList);
        } else {
          productProvider.addProduct(name, isNeededList, enviromentId);
        }
      },
    );
  }
}

class SimpleShoppinglist extends StatelessWidget {
  final String enviromentId;
  const SimpleShoppinglist(this.enviromentId, {super.key});

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
