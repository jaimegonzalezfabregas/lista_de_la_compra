import 'package:flutter/material.dart';
import 'package:jhopping_list/UI/common/searchable_list_view.dart';
import 'package:jhopping_list/UI/products/common.dart';
import 'package:jhopping_list/db/database.dart';
import 'package:jhopping_list/providers/product_provider.dart';
import 'package:jhopping_list/UI/products/product_detail.dart';
import 'package:jhopping_list/providers/schedule_provider.dart';
import 'package:provider/provider.dart';

class ProductListDisplay extends StatelessWidget {
  final bool Function(Product) filter;
  final bool defaultNeeded;
  final String enviromentId;

  const ProductListDisplay(this.defaultNeeded, this.filter, this.enviromentId, {super.key});

  @override
  Widget build(BuildContext context) {
    try {
      ProductProvider productProvider = context.watch();
      ScheduleProvider scheduleProvider = context.watch();

      return FutureBuilder(
        future: productProvider.getDisplayProductList(enviromentId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Cargando...");
          }
          var products = snapshot.data!.where(filter).toList();

          return Searchablelistview<Product>(
            elements: products,
            elementToListTile: (Product p, RichText tag) {

              return ListTile(
                title: tag,
                onTap: () => productProvider.setProductNeededness(p.id, !p.needed),
                subtitle: getNeededAmount(scheduleProvider, p.id),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_outward),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetail(p.id)));
                      },
                    ),
                    Checkbox(value: p.needed, onChanged: (bool? x) => productProvider.setProductNeededness(p.id, x!)),
                  ],
                ),
              );
            },
            elementToTag: (Product p) => p.name,
            newElement: (String name) async {
              var allProducts = await productProvider.getDisplayProductList(enviromentId);
              if (allProducts.any((e) => e.name.toLowerCase() == name.toLowerCase())) {
                var referenced = allProducts.firstWhere((e) => e.name.toLowerCase() == name.toLowerCase());

                productProvider.setProductNeededness(referenced.id, defaultNeeded);
              } else {
                productProvider.addProduct(name, defaultNeeded, enviromentId);
              }
            },
          );
        },
      );
    } catch (e) {
      return Text("$e", textScaler: TextScaler.linear(0.7),);
    }
  }
}

class SimpleShoppinglist extends StatelessWidget {
  final String enviromentId;
  const SimpleShoppinglist(this.enviromentId, {super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,

          bottom: const TabBar(
            tabs: [Tab(icon: Icon(Icons.check_box_outline_blank)), Tab(icon: Icon(Icons.check_box)), Tab(icon: Icon(Icons.indeterminate_check_box))],
          ),
          title: Text("Lista de la compra"),
        ),
        body: TabBarView(
          children: [
            ProductListDisplay(false, (p) => !p.needed, enviromentId),
            ProductListDisplay(true, (p) => p.needed, enviromentId),
            ProductListDisplay(true, (_) => true, enviromentId),
          ],
        ),
      ),
    );
  }
}
