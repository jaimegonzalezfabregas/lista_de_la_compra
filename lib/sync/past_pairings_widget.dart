import 'package:flutter/material.dart';
import 'package:jhopping_list/db/database.dart';
import 'package:jhopping_list/sync/pairing_provider.dart';
import 'package:provider/provider.dart';

class PastPairingsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PairingProvider pairingProvider = context.watch();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Builder(
            builder: (context) {
              var httpClientPairingListFuture = pairingProvider.getHttpClientPairings();
              var httpServerPairingListFuture = pairingProvider.getHttpServerPairings();

              return Column(
                children: [
                  FutureBuilder(
                    future: httpServerPairingListFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var pairings = snapshot.data!;

                        if (pairings.isEmpty) {
                          return Center(child: Text("No hay emparejamientos pasados con Servidores HTTP"));
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: pairings.length,
                          itemBuilder: (context, index) {
                            HttpServerPairing pairing = pairings[index];
                            return ListTile(
                              title: Text(pairing.nick),
                              subtitle: Text("Host HTTP " + pairing.host),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  pairingProvider.deleteHttpServerPairingsById(pairing.id);
                                },
                              ),
                            );
                          },
                        );
                      }
                      if (snapshot.hasError) {
                        return Text("Error! :( ${snapshot.error}");
                      }
                      return Text("Cargando...");
                    },
                  ),

                  FutureBuilder(
                    future: httpClientPairingListFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var pairings = snapshot.data!;

                        if (pairings.isEmpty) {
                          return Center(child: Text("No hay emparejamientos pasados con cientes HTTP"));
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: pairings.length,
                          itemBuilder: (context, index) {
                            HttpClientPairing pairing = pairings[index];
                            return ListTile(
                              title: Text(pairing.nick),
                              subtitle: Text("cliente HTTP"),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  pairingProvider.deleteHttpClientPairingsById(pairing.id);
                                },
                              ),
                            );
                          },
                        );
                      }
                      if (snapshot.hasError) {
                        return Text("Error! :( ${snapshot.error}");
                      }
                      return Text("Cargando...");
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
