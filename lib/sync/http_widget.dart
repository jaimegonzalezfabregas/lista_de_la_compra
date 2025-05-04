import 'dart:convert';
import 'dart:io';

import 'package:contentsize_tabbarview/contentsize_tabbarview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:jhopping_list/sync/ip_list.dart';
import 'package:jhopping_list/sync/pairing_provider.dart';
import 'package:provider/provider.dart';

class HTTPManageWidget extends StatelessWidget {
  const HTTPManageWidget({super.key});

  Widget serveControlls(BuildContext context) {
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
                      IpList(),
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
    PairingProvider pairingProvider = context.watch();
    TextEditingController hostTextController = TextEditingController();

    var toast = ScaffoldMessenger.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: hostTextController,
              decoration: InputDecoration(labelText: "Dirección remota", border: OutlineInputBorder()),
            ),
          ),
          TextButton(
            onPressed: () async {
              var host = hostTextController.text;
              var textUrl = "http://$host:4545/";

              Uri? uri;
              try {
                uri = Uri.parse(textUrl);
              } on FormatException catch (_, e) {
                toast.showSnackBar(SnackBar(content: Text("Error de formato en el host $host, la url construida es \"$textUrl\". Error. $e")));
              } catch (e) {
                toast.showSnackBar(SnackBar(content: Text("Error: $e")));
              }
              http.Response response = await http.post(uri!, body: jsonEncode({"nick": context.read<PairingProvider>().getLocalNick()}));

              if (response.statusCode != 200) {
                toast.showSnackBar(SnackBar(content: Text("Error al conectar con el servidor remoto, código de estado ${response.statusCode}")));
                return;
              }

              if (response.body.isEmpty) {
                toast.showSnackBar(SnackBar(content: Text("Error al conectar con el servidor remoto, no ha devuelto contenido")));
                return;
              }

              if (response.headers["content-type"] != "application/json") {
                toast.showSnackBar(SnackBar(content: Text("Error al conectar con el servidor remoto, no ha devuelto un json")));
                return;
              }

              var responseContents = jsonDecode((response).body);

              if (responseContents["tocken"] == null) {
                toast.showSnackBar(SnackBar(content: Text("Error al conectar con el servidor remoto, no ha devuelto un token")));
                return;
              }

              pairingProvider.addHttpServerEntry(host, 4545, responseContents["token"]);
            },
            child: Text("Conectar"),
          ),
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
          Container(child: ContentSizeTabBarView(children: [serveControlls(context), clientControlls(context)])),
        ],
      ),
    );
  }
}
