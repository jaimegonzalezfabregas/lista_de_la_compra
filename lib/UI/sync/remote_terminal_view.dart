import 'package:flutter/material.dart';
import 'package:jhopping_list/db/database.dart';
import 'package:jhopping_list/providers/open_conection_provider.dart';
import 'package:jhopping_list/providers/pairing_provider.dart';
import 'package:jhopping_list/sync/open_connection.dart';
import 'package:provider/provider.dart';

class RemoteTerminalView extends StatelessWidget {
  final String id;

  const RemoteTerminalView(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    final PairingProvider pairingProvider = context.watch();
    final OpenConnectionProvider openConnectionProvider = context.watch();

    Future<RemoteTerminal?> pairingFuture = pairingProvider.getRemoteTerminalById(id);

    return Scaffold(
      appBar: AppBar(
        title: Text("Sincronización", style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
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

          Widget? connectionWidget = connection == null ? Text("No establecida") : Text("Establecida (${connection.latency}ms)");

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                Text("Tipo de conexión", style: Theme.of(context).textTheme.titleSmall),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (pairing.isHttpClient) Text("HTTP Client"),
                      if (pairing.isHttpServer) Text("HTTP Server (${pairing.httpHost}:${pairing.httpPort})"),
                    ],
                  ),
                ),

                Text("Estado de la conexión"),
                Padding(padding: const EdgeInsets.all(8), child: connectionWidget),
              ],
            ),
          );
        },
      ),
    );
  }
}
