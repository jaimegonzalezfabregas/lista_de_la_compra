import 'package:flutter/material.dart';
import 'package:jhopping_list/db/database.dart';
import 'package:jhopping_list/providers/open_conection_provider.dart';
import 'package:jhopping_list/providers/pairing_provider.dart';
import 'package:jhopping_list/UI/sync/remote_terminal_view.dart';
import 'package:provider/provider.dart';

class RemoteTerminalList extends StatelessWidget {
  const RemoteTerminalList({super.key});

  @override
  Widget build(BuildContext context) {
    PairingProvider pairingProvider = context.watch();
    OpenConnectionProvider openConnectionProvider = context.watch();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Builder(
            builder: (context) {
              var remoteTerminals = pairingProvider.getRemoteTerminals();

              return ListView(
                shrinkWrap: true,
                children: [
                  FutureBuilder(
                    future: remoteTerminals,
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
                            RemoteTerminal pairing = pairings[index];

                            bool isOpen = openConnectionProvider.isConnected(pairing.terminalId);

                            return ListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return RemoteTerminalView(pairing.terminalId);
                                    },
                                  ),
                                );
                              },
                              title: Row(children: [if (isOpen) Icon(Icons.link), if (!isOpen) Icon(Icons.link_off), Text(pairing.nick)]),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      pairingProvider.deleteRemoteTerminalById(pairing.terminalId);
                                      openConnectionProvider.removeOpenConnection(pairing.terminalId);
                                    },
                                  ),
                                ],
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
