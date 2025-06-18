import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/db/database.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra/providers/open_conection_provider.dart';
import 'package:lista_de_la_compra/providers/pairing_provider.dart';
import 'package:lista_de_la_compra/sync/open_connection.dart';
import 'package:provider/provider.dart';

class RemoteTerminalView extends StatelessWidget {
  final String id;

  const RemoteTerminalView(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;

    final PairingProvider pairingProvider = context.watch();
    final OpenConnectionProvider openConnectionProvider = context.watch();

    Future<RemoteTerminal?> pairingFuture = pairingProvider.getRemoteTerminalById(id);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLoc.syncronization, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: FutureBuilder(
        future: pairingFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final RemoteTerminal pairing = snapshot.data!;
          final OpenConnection? connection = openConnectionProvider.openConnections[pairing.terminalId];

          Widget? connectionWidget = connection == null ? Text(appLoc.notStablished) : Text("${appLoc.stablished} (${connection.latency}ms)");

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                Text(appLoc.connectionType, style: Theme.of(context).textTheme.titleSmall),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (pairing.isHttpClient) Text(appLoc.httpClient),
                      if (pairing.isHttpServer) Text("${appLoc.httpServer} (${pairing.httpHost}:${pairing.httpPort})"),
                    ],
                  ),
                ),

                Text(appLoc.connectionState),
                Padding(padding: const EdgeInsets.all(8), child: connectionWidget),
              ],
            ),
          );
        },
      ),
    );
  }
}
