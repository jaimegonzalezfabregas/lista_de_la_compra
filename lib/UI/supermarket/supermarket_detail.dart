import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/common/searchable_list_view.dart';
import 'package:lista_de_la_compra/UI/supermarket/add_products_to_isle.dart';
import 'package:lista_de_la_compra/flutter_providers/flutter_providers.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';
import 'package:provider/provider.dart';

class Aisles extends StatelessWidget {
  final String supermarketId;

  const Aisles(this.supermarketId, {super.key});

  @override
  Widget build(BuildContext context) {
    final AisleProvider aisleProvider = context.watch<FlutterAisleProvider>();
    final ProductAisleProvider productAisleProvider = context.watch<FlutterProductAisleProvider>();
    final AppLocalizations appLoc = AppLocalizations.of(context)!;

    Future<List<Aisle>> aisleFuture = aisleProvider.getAislesBySupermarket(supermarketId);

    return FutureBuilder(
      future: aisleFuture,
      builder: (context, asyncSnapshot) {
        if (!asyncSnapshot.hasData) {
          return Text(appLoc.loading);
        }

        var aisles = asyncSnapshot.data!;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(8)),

            child: Searchablelistview(
              elements: aisles,
              elementToListTile: (Aisle aisle, rt) => ListTile(
                title: rt,
                subtitle: FutureBuilder(
                  future: productAisleProvider.getProductsByAisle(aisle.id),
                  builder: (context, asyncSnapshot) {
                    if (!asyncSnapshot.hasData) {
                      return Text(appLoc.loading);
                    }
                    var products = asyncSnapshot.data!;
                    return Text(appLoc.numberOfProducts(products.length));
                  },
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: () => {aisleProvider.deleteById(aisle.id)}, icon: Icon(Icons.delete)),
                    IconButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductsToIsle(aisle.id))),
                      icon: Icon(Icons.edit),
                    ),
                  ],
                ),
              ),

              elementToTag: (Aisle a) => a.name,
              newElement: (String name) => aisleProvider.addAisle(name, supermarketId),
            ),
          ),
        );
      },
    );
  }
}

class SupermarketDetail extends StatelessWidget {
  final String supermarketId;

  const SupermarketDetail(this.supermarketId, {super.key});

  @override
  Widget build(BuildContext context) {
    final SuperMarketProvider superMarketProvider = context.watch<FlutterSuperMarketProvider>();

    final AppLocalizations appLoc = AppLocalizations.of(context)!;

    Future<SuperMarket?> supermarketFuture = superMarketProvider.getSuperMarketById(supermarketId);

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (s) {},
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Row(children: [Icon(Icons.delete), SizedBox(width: 8), Text(appLoc.delete)]),
                  onTap: () {
                    Navigator.pop(context);
                    superMarketProvider.deleteById(supermarketId);
                  },
                ),
              ];
            },
          ),
        ],
        title: FutureBuilder(
          future: supermarketFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.name);
            }
            if (snapshot.hasError) {
              return Text("$snapshot");
            }
            return Text(appLoc.loading);
          },
        ),

        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(appLoc.aisles, style: Theme.of(context).textTheme.titleSmall),
            ),
            Aisles(supermarketId),
          ],
        ),
      ),
    );
  }
}
