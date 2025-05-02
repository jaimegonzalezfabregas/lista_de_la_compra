import 'dart:io';

import 'package:contentsize_tabbarview/contentsize_tabbarview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jhopping_list/sync/pairing_provider.dart';
import 'package:provider/provider.dart';

class HTTPManageWidget extends StatelessWidget {
  Widget serveControlls(BuildContext context) {
    var ips = NetworkInterface.list();

    PairingProvider pairingProvider = context.watch();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Builder(
            builder: (context) {
              Widget child;

              switch (pairingProvider.getServerStatus()) {
                case ServerStatus.running:
                  child = Column(
                    children: [
                      FutureBuilder(
                        future: ips,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: [
                                for (var interface in snapshot.data!)
                                  for (var address in interface.addresses)
                                    ListTile(
                                      title: Text(address.address),
                                      subtitle: Text(interface.name),
                                      trailing: IconButton(
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(text: address.address));
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(SnackBar(content: Text("Dirección IP (${address.address}) copiada al portapapeles")));
                                        },
                                        icon: Icon(Icons.copy),
                                      ),
                                    ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text("Utilize estas direciones IP para aceder a su dispositivo actual desde otros dispositivos"),
                                ),
                              ],
                            );
                          }
                          return const Text("Cargando...");
                        },
                      ),
                      TextButton(
                        onPressed: () async {
                          await pairingProvider.stopServer();
                        },
                        child: Text("Detener servidor"),
                      ),
                    ],
                  );
                  break;
                case ServerStatus.stopped:
                  child = TextButton(
                    onPressed: () async {
                      await pairingProvider.tryStartServer();
                    },
                    child: Text("Iniciar servidor"),
                  );
                  break;
                case ServerStatus.turningOn:
                  child = Text("Iniciando servidor...");
                  break;
                case ServerStatus.turningOff:
                  child = Text("Deteniendo servidor...");
                  break;
                case ServerStatus.error:
                  child = Column(
                    children: [
                      Text("Error iniciando servidor: ${pairingProvider.getServerError()}"),
                      TextButton(
                        onPressed: () async {
                          await pairingProvider.tryStartServer();
                        },
                        child: Text("Iniciar servidor"),
                      ),
                    ],
                  );
                  break;
              }

              return Container(
                width: double.infinity,
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(10)),
                child: Padding(padding: const EdgeInsets.all(8.0), child: child),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget clientControlls(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(child: TextField(decoration: InputDecoration(labelText: "Dirección remota", border: OutlineInputBorder()))),
          TextButton(onPressed: () {
      
            
            
      
          }, child: Text("Conectar")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(tabs: [Tab(text: "Servidor"), Tab(text: "Cliente")]),
          Container( child: ContentSizeTabBarView(children: [serveControlls(context), clientControlls(context)])),
        ],
      ),
    );
  }
}
