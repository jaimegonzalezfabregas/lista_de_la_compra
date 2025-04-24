import 'package:flutter/material.dart';
import 'package:jhopping_list/common/searchable_list_view.dart';
import 'package:jhopping_list/db/database.dart';
import 'package:jhopping_list/products/product_provider.dart';
import 'package:jhopping_list/products/product_detail.dart';
import 'package:provider/provider.dart';

class ProductListDisplay extends StatelessWidget {
  final bool Function(Product) filter;
  final bool defaultNeeded;

  const ProductListDisplay(this.defaultNeeded, this.filter, {super.key});

  @override
  Widget build(BuildContext context) {
    ProductProvider state = context.watch();

    return FutureBuilder(
      future: state.getProductList(),
      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return Text("TODO"); // TODO
        }
        var products = snapshot.data!.where(filter).toList();

        return Searchablelistview<Product>(
          elements: products,
          elementToListTile:
              (Product p, RichText tag) => ListTile(
                title: tag,
                onTap: () => state.setProductNeededness(p.id, !p.needed),
                onLongPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetail(p.id),
                    ),
                  );
                },
                trailing: Checkbox(
                  value: p.needed,
                  onChanged: (bool? x) => state.setProductNeededness(p.id, x!),
                ),
              ),
          elementToTag: (Product p) => p.name,
          newElement: (String name) async {
            var allProducts = await state.getProductList();
            if (allProducts.any(
              (e) => e.name.toLowerCase() == name.toLowerCase(),
            )) {
              var referenced = allProducts.firstWhere(
                (e) => e.name.toLowerCase() == name.toLowerCase(),
              );

              state.setProductNeededness(referenced.id, defaultNeeded);
            } else {
              state.addProduct(name, defaultNeeded);
            }
          },
        );
      },
    );
  }
}

class SimpleShoppinglist extends StatelessWidget {
  const SimpleShoppinglist({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
          title: Text("Lista de la compra"),
        ),
        body: TabBarView(
          children: [
            ProductListDisplay(false, (p) => !p.needed),
            ProductListDisplay(true, (p) => p.needed),
            ProductListDisplay(true, (_) => true),
          ],
        ),
      ),
    );
  }
}
