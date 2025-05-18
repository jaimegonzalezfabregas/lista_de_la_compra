import 'package:flutter/material.dart';
import 'package:jhopping_list/db/database.dart';
import 'package:jhopping_list/providers/pairing_provider.dart';
import 'package:provider/provider.dart';

class RemoteTerminalView extends StatelessWidget {
  final String id;

  const RemoteTerminalView(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    final PairingProvider pairingProvider = context.watch();

    Future<RemoteTerminal> pairingPromise = pairingProvider.getRemoteTerminalById(id);

    return Scaffold(
      appBar: AppBar(
        title: Text("Sincronización", style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: FutureBuilder(
        future: pairingPromise,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final pairing = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                Text("Ultimo emparejamiento", style: Theme.of(context).textTheme.titleSmall),

                Padding(padding: const EdgeInsets.all(8.0), child: Text(pairing.lastSync ?? "Sincronización no realizada")),

                Text("Ultimo contacto", style: Theme.of(context).textTheme.titleSmall),

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
              ],
            ),
          );
        },
      ),
    );
  }
}
