import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/common/needed_checkbox.dart';
import 'package:lista_de_la_compra/UI/common/searchable_list_view.dart';
import 'package:lista_de_la_compra/UI/products/common.dart';
import 'package:lista_de_la_compra/db/database.dart';
import 'package:lista_de_la_compra/providers/product_provider.dart';
import 'package:lista_de_la_compra/UI/products/product_detail.dart';
import 'package:lista_de_la_compra/providers/schedule_provider.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_show_when_locked/flutter_show_when_locked.dart';

class ProductListDisplay extends StatelessWidget {
  final bool Function(Product) filter;
  final bool defaultNeeded;
  final String enviromentId;

  const ProductListDisplay(this.defaultNeeded, this.filter, this.enviromentId, {super.key});

  @override
  Widget build(BuildContext context) {


    ProductProvider productProvider = context.watch();
    ScheduleProvider scheduleProvider = context.watch();

    try {
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
                    NeededCheckbox(p.id)
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
      return Text("$e", textScaler: TextScaler.linear(0.7));
    }
  }
}

class SimpleShoppinglist extends StatelessWidget {
  final String enviromentId;
  const SimpleShoppinglist(this.enviromentId, {super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,

          bottom: const TabBar(
            tabs: [Tab(icon: Icon(Icons.shopping_cart), child: Text("Comprar")), Tab(icon: Icon(Icons.list), child: Text("Todo"))],
          ),
          title: Text("Lista de la compra"),
        ),
        body: TabBarView(children: [ProductListDisplay(false, (p) => !p.needed, enviromentId), ProductListDisplay(true, (_) => true, enviromentId)]),
      ),
    );
  }
}
