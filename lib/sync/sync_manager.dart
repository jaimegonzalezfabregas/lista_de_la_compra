import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jhopping_list/providers/shared_preferences_provider.dart';
import 'package:jhopping_list/sync/http_widget.dart';
import 'package:jhopping_list/sync/past_pairings_widget.dart';
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
                  SharedPreferencesProvider sharedPreferencesProvider = context.watch();
                  var nickTextController = TextEditingController();
                  sharedPreferencesProvider.getLocalNick().then((value) {
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
                          sharedPreferencesProvider.setLocalNick(nickTextController.text);
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
                  SharedPreferencesProvider sharedPreferencesProvider = context.watch();

                  var roomKeyTextController = TextEditingController();

                  sharedPreferencesProvider.getRoomKey().then((value) {
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
                          sharedPreferencesProvider.setRoomKey(roomKeyTextController.text);
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
            RemoteTerminalList(),

            ExpansionTile(title: Text("Sincronización HTTP"), children: [HTTPManageWidget()]),
            ExpansionTile(title: Text("Sincronización MQTT"), children: []),
          ],
        ),
      ),
    );
  }
}
