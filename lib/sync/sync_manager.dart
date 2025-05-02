import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jhopping_list/db/database.dart';
import 'package:jhopping_list/sync/http_widget.dart';
import 'package:jhopping_list/sync/pairing_provider.dart';
import 'package:provider/provider.dart';

class SyncManager extends StatefulWidget {
  const SyncManager({super.key});

  @override
  State<SyncManager> createState() => _SyncManagerState();
}

class _SyncManagerState extends State<SyncManager> {
  HttpServer? server;

  @override
  Widget build(BuildContext context) {
    PairingProvider pairingProvider = context.watch();

    return Scaffold(
      appBar: AppBar(
        title: Text("Sincronización", style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer)),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Text("Configuración general", style: Theme.of(context).textTheme.titleSmall),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Builder(
                builder: (context) {
                  var nickTextController = TextEditingController();
                  pairingProvider.getLocalNick().then((value) {
                    nickTextController.text = value ?? "";
                  });

                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: nickTextController,
                          decoration: InputDecoration(labelText: "Nick", border: OutlineInputBorder()),
                          onChanged: (value) {},
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.save),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Nick guardado")));
                          pairingProvider.setLocalNick(nickTextController.text);
                        },
                      ),
                    ],
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Builder(
                builder: (context) {
                  var roomKeyTextController = TextEditingController();

                  pairingProvider.getRoomKey().then((value) {
                    roomKeyTextController.text = value ?? "";
                  });
                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: roomKeyTextController,
                          decoration: InputDecoration(labelText: "Clave de sala", border: OutlineInputBorder()),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Clave de sala guardada")));
                          pairingProvider.setRoomKey(roomKeyTextController.text);
                        },
                        icon: Icon(Icons.save),
                      ),

                      IconButton(onPressed: () {}, icon: Icon(Icons.qr_code)), // TODO
                      IconButton(onPressed: () {}, icon: Icon(Icons.qr_code_scanner)), // TODO
                      IconButton(onPressed: () {}, icon: Icon(Icons.refresh)), // TODO
                    ],
                  );
                },
              ),
            ),

            Text("Emparejamientos pasados", style: Theme.of(context).textTheme.titleSmall),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Builder(
                    builder: (context) {
                      var pairingListFuture = pairingProvider.getPairings();

                      return FutureBuilder(
                        future: pairingListFuture,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<PairingData> pairings = snapshot.data!;

                            if (pairings.isEmpty) {
                              return Center(child: Text("No hay emparejamientos pasados"));
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: pairings.length,
                              itemBuilder: (context, index) {
                                var pairing = pairings[index];
                                return ListTile(
                                  title: Text(pairing.nick),
                                  subtitle: Text(pairing.host),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      pairingProvider.deletePairingById(pairing.id);
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
                      );
                    },
                  ),
                ),
              ),
            ),

            ExpansionTile(title: Text("Sincronización HTTP"), children: [HTTPManageWidget()]),
            ExpansionTile(title: Text("Sincronización MQTT"), children: []),
          ],
        ),
      ),
    );
  }
}
