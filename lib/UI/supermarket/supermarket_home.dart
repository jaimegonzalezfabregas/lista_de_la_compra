import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/common/searchable_list_view.dart';
import 'package:lista_de_la_compra/UI/supermarket/supermarket_detail.dart';
import 'package:lista_de_la_compra/flutter_providers/flutter_providers.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';
import 'package:provider/provider.dart';

class SupermarketHome extends StatelessWidget {
  final String enviromentId;
  const SupermarketHome(this.enviromentId, {super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;
    final SuperMarketProvider supermarketProvider = context.watch<FlutterSuperMarketProvider>();
    final AisleProvider aislesProvider = context.watch<FlutterAisleProvider>();

    Future<List<SuperMarket>> supermarketFuture = supermarketProvider.getDisplaySuperMarketList(enviromentId);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLoc.supermarketList, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),

        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: FutureBuilder(
        future: supermarketFuture,
        builder: (context, asyncSnapshot) {
          if (!asyncSnapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var allSupermarkets = asyncSnapshot.data!;
          return Searchablelistview(
            elements: allSupermarkets,
            elementToListTile: (SuperMarket s, tag) => ListTile(
              title: tag,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SupermarketDetail(s.id);
                  },
                ),
              ),
              subtitle: FutureBuilder(
                future: aislesProvider.getAislesBySupermarket(s.id),
                builder: (context, asyncSnapshot) {
                  if (!asyncSnapshot.hasData) {
                    return Text(appLoc.loading);
                  }
                  var aisles = asyncSnapshot.data!;
                  return Text(appLoc.numberOfAisles(aisles.length));
                },
              ),

            ),
            elementToTag: (SuperMarket s) => s.name,
            newElement: (name) => supermarketProvider.addSuperMarket(name, enviromentId),
          );
        },
      ),
    );
  }
}
