import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/db/database.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra/providers/http_server_provider.dart';
import 'package:provider/provider.dart';

class HTTPKnownServers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;
    HttpServerProvider httpServerProvider = context.watch();

    return FutureBuilder(
      future: httpServerProvider.getHttpServers(),
      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return Text(appLoc.loading);
        }

        List<HttpServerData> servers = snapshot.data!;
        if (servers.isEmpty) {
          return Center(child: Text(appLoc.noHTTPPairings));
        }
        return Column(
          children: servers.map((server) {
            // TODO show if a connection is happenind right now and allow to trigger connection
            return ListTile(
              title: Text(server.httpHost),
              subtitle: Text(server.nick ?? appLoc.neverConnected),
              trailing: IconButton(
                onPressed: () {
                  httpServerProvider.deleteHttpServer(server.id);
                },
                icon: Icon(Icons.delete),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
