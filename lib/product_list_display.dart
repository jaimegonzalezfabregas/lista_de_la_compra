import 'package:flutter/material.dart';
import 'package:jopping_list/app_state.dart';
import 'package:jopping_list/product.dart';
import 'package:modals/modals.dart';
import 'package:provider/provider.dart';

class ProductListDisplay extends StatelessWidget {
  final List<Product> productList;
  final bool defaultNeeded;

  const ProductListDisplay(this.productList, this.defaultNeeded, {super.key});

  @override
  Widget build(BuildContext context) {
    var state = context.watch<AppPersistence>();

    List<Widget> items =
        productList.map((e) {
          return Container(
            child: ListTile(
              title: Text(e.name),
              onTap: () => state.setProductNeededness(e.id, !e.needed),
              onLongPress: () {
                showModal(
                  ModalEntry.positioned(
                    context,
                    tag: 'containerModal',
                    left: 200,
                    top: 200,
                    child: Container(color: Colors.red, width: 50, height: 50),
                  ),
                );
              },
              trailing: Checkbox(
                value: e.needed,
                onChanged: (bool? x) => state.setProductNeededness(e.id, x!),
              ),
            ),
          );
        }).toList();

    items.add(
      Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Introduce un nuevo producto',
            ),
            onSubmitted: (value) => state.addProduct(value, defaultNeeded),
          ),
        ),
      ),
    );

    return Scaffold(body: ListView(children: items));
  }
}
