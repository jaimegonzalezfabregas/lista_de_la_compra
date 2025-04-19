import 'package:flutter/material.dart';
import 'package:jhopping_list/AppState.dart';
import 'package:jhopping_list/common/SearchScorer.dart';
import 'package:jhopping_list/common/Product.dart';
import 'package:provider/provider.dart';

class ProductListDisplay extends StatelessWidget {
  final List<Product> productList;
  final bool defaultNeeded;
  final SearchScorer searchScorer;

  const ProductListDisplay(
    this.productList,
    this.searchScorer,
    this.defaultNeeded, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var state = context.watch<AppState>();

    List<Widget> items =
        productList.map((e) {
          return ListTile(
            title: searchScorer.getMatching(e.name),
            onTap: () => state.setProductNeededness(e.id, !e.needed),
            onLongPress: () {
              // navigate to product sheet
            },
            trailing: Checkbox(
              value: e.needed,
              onChanged: (bool? x) => state.setProductNeededness(e.id, x!),
            ),
          );
        }).toList();

    var productFilter = state.getProductFilter();
    var allProducts = state.getProductList();
    if (productFilter != "" &&
        (allProducts != null) &&
        !allProducts.any(
          (e) => e.name.toLowerCase() == productFilter.toLowerCase(),
        )) {
      items.insert(
        0,
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            onPressed: () {
              state.addProduct(state.getProductFilter(), defaultNeeded);
              state.setProductFilter("");
            },
            child: Text("add \"${state.getProductFilter()}\" as product"),
          ),
        ),
      );
    }
    return ListView(children: items);
  }
}

class SimpleShopinglist extends StatelessWidget {
  final AppState appState;

  const SimpleShopinglist(this.appState, {super.key});

  @override
  Widget build(BuildContext context) {
    var productList = appState.getProductList();

    if (productList == null) {
      return Text("Loading...");
    }

    SearchScorer scorer = SearchScorer(appState.getProductFilter());

    productList.sort(
      (a, b) => scorer.getScore(b.name) - scorer.getScore(a.name),
    );

    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.check_box_outline_blank)),
                Tab(icon: Icon(Icons.check_box)),
                Tab(icon: Icon(Icons.indeterminate_check_box)),
              ],
            ),
            title: Text("Jhopping List"),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Buscar',
                  ),
                  initialValue: appState.getProductFilter(),
                  onChanged: (value) => appState.setProductFilter(value),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ProductListDisplay(
                      productList.where((p) => !p.needed).toList(),
                      scorer,
                      false,
                    ),
                    ProductListDisplay(
                      productList.where((p) => p.needed).toList(),
                      scorer,
                      true,
                    ),
                    ProductListDisplay(productList.toList(), scorer, true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
