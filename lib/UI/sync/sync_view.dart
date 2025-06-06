import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/providers/shared_preferences_provider.dart';
import 'package:lista_de_la_compra/UI/sync/http_view.dart';
import 'package:lista_de_la_compra/sync/open_connection_manager.dart';
import 'package:lista_de_la_compra/UI/sync/past_pairings_widget.dart';
import 'package:provider/provider.dart';

class SyncView extends StatefulWidget {
  final OpenConnectionManager openConnectionManager;

  const SyncView(this.openConnectionManager, {super.key});

  @override
  State<SyncView> createState() => _SyncViewState();
}

class _SyncViewState extends State<SyncView> {
  HttpServer? server;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sincronización", style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
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
                  SharedPreferencesProvider sharedPreferencesProvider = context.watch();
                  var textControler = TextEditingController();

                  sharedPreferencesProvider.getLocalNick().then((String? value) {
                    if (value == null) {
                      value = "Sin nick";
                      sharedPreferencesProvider.setLocalNick(value);
                    }
                    textControler.text = value;
                  });

                  return Row(
                    children: [
                      Expanded(child: TextField(decoration: InputDecoration(labelText: "Nick"), enabled: false, controller: textControler)),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Cambiar nick"),
                                content: TextField(decoration: InputDecoration(labelText: "Nick"), controller: textControler),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Cancelar"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      sharedPreferencesProvider.setLocalNick(textControler.text);
                                      Navigator.of(context).pop();
                                      widget.openConnectionManager.triggerHandshakePush();
                                    },
                                    child: Text("Guardar"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            Text("Emparejamientos pasados", style: Theme.of(context).textTheme.titleSmall),
            RemoteTerminalList(),
            HTTPView(widget.openConnectionManager),
            // ExpansionTile(title: Text("Sincronización HTTP"), children: []),
            // ExpansionTile(title: Text("Sincronización MQTT"), children: []),
          ],
        ),
      ),
    );
  }
}
