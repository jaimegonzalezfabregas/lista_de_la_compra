import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/common/searchable_list_view.dart';
import 'package:lista_de_la_compra/UI/products/common.dart';
import 'package:lista_de_la_compra/db/database.dart';
import 'package:lista_de_la_compra/providers/product_provider.dart';
import 'package:lista_de_la_compra/UI/products/product_detail.dart';
import 'package:lista_de_la_compra/providers/schedule_provider.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_show_when_locked/flutter_show_when_locked.dart';


final Duration undoDuration = const Duration(seconds: 4);

class UndoToast extends StatefulWidget {
  final String productId;
  final bool oldNeededness;
  final FToast fToast;

  const UndoToast(this.productId, this.oldNeededness, this.fToast, {super.key});

  @override
  State<UndoToast> createState() => _UndoToastState();
}

class _UndoToastState extends State<UndoToast> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: undoDuration, vsync: this)..forward();
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = context.watch();

    return AnimatedBuilder(
      animation: _controller,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          FutureBuilder(
            future: productProvider.getProductById(widget.productId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.name);
              }
              return Text("Producto");
            },
          ),

          Text(" marcado como ${widget.oldNeededness ? "necesario" : "comprado"}. "),
          TextButton(
            onPressed: () {
              productProvider.setProductNeededness(widget.productId, widget.oldNeededness);
              widget.fToast.removeCustomToast();
            },
            child: Text("Deshacer"),
          ),
        ],
      ),
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            gradient: LinearGradient(
              stops: [_controller.value, _controller.value],
              // colors: [Colors.red, Colors.green],
              colors: [Theme.of(context).colorScheme.surfaceContainerHighest, Theme.of(context).colorScheme.surfaceContainerHigh],
            ),
          ),
          child: child,
        );
      },
    );
  }
}

Future<void> showUndoToast(FToast fToast, String productId, bool oldNeededness) async {
  fToast.removeCustomToast();
  fToast.removeQueuedCustomToasts();

  fToast.showToast(child: UndoToast(productId, oldNeededness, fToast), gravity: ToastGravity.BOTTOM, toastDuration: undoDuration);
}

showLockScreenToast(BuildContext context){
  Fluttertoast.showToast(
    msg: "Visible sin desbloquear el dispositivo",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
  );
}

class ProductListDisplay extends StatelessWidget {
  final bool Function(Product) filter;
  final bool defaultNeeded;
  final String enviromentId;

  const ProductListDisplay(this.defaultNeeded, this.filter, this.enviromentId, {super.key});

  @override
  Widget build(BuildContext context) {
    final FToast fToast = FToast();

    fToast.init(context);

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
                    Checkbox(
                      value: p.needed,
                      onChanged: (bool? x) {
                        productProvider.setProductNeededness(p.id, x!);
                        showUndoToast(fToast, p.id, !x);
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
          actions: [
            IconButton(onPressed: () async {
              await FlutterShowWhenLocked().show();
              showLockScreenToast(context);

            }, icon: Icon(Icons.screen_lock_portrait))
          ],

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
