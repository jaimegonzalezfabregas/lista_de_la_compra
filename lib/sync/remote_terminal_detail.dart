import 'package:flutter/material.dart';
import 'package:jhopping_list/db/database.dart';
import 'package:jhopping_list/providers/pairing_provider.dart';
import 'package:provider/provider.dart';

class RemoteTerminalDetail extends StatelessWidget {
  final String id;

  const RemoteTerminalDetail(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    final PairingProvider pairingProvider = context.watch();

    Future<RemoteTerminal> pairing_promise = pairingProvider.getRemoteTerminalById(id);

    return Scaffold(
      appBar: AppBar(
        title: Text("Sincronización", style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer)),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Text("Ultimo emparejamiento", style: Theme.of(context).textTheme.titleSmall),
            Text("Tipos de emparejamiento", style: Theme.of(context).textTheme.titleSmall),

            FutureBuilder(
              future: pairing_promise,
              builder: (builder, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final pairing = snapshot.data!;

                return Row(
                  children: [
                    if (pairing.isHttpClient) Text("HTTP Client", style: Theme.of(context).textTheme.titleSmall),
                    if (pairing.isHttpServer) Text("HTTP Server", style: Theme.of(context).textTheme.titleSmall),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
