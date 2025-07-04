import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/db/database.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra/db_providers/http_server_provider.dart';
import 'package:lista_de_la_compra/sync/http_client_service.dart';
import 'package:lista_de_la_compra/sync/open_conection_provider.dart';
import 'package:provider/provider.dart';

class HTTPKnownServers extends StatelessWidget {
  const HTTPKnownServers({super.key});

  @override
  Widget build(BuildContext context) {
    final HttpClientService httpClientService = context.watch();

    final AppLocalizations appLoc = AppLocalizations.of(context)!;
    HttpServerProvider httpServerProvider = context.watch();
    OpenConnectionProvider openConnectionProvider = context.watch();

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
            Widget stateIcon = Icon(Icons.link_off);
            if (httpClientService.runningAttempts.contains(server.id)) {
              stateIcon = Icon(Icons.hourglass_top);
            }
            if (openConnectionProvider.anyOpenConnectionOfSource(server.id)) {
              stateIcon = Icon(Icons.link);
            }

            return ListTile(
              title: Text(server.httpHost),
              subtitle: Text(server.nick ?? appLoc.neverConnected),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  stateIcon,
                  IconButton(
                    onPressed: () {
                      openConnectionProvider.closeByConnectionSource(server.id);
                      httpServerProvider.deleteHttpServer(server.id);
                    },
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
