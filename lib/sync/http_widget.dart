import 'dart:convert';

import 'package:contentsize_tabbarview/contentsize_tabbarview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jhopping_list/providers/http_server_state_provider.dart';
import 'package:jhopping_list/providers/shared_preferences_provider.dart';
import 'package:jhopping_list/sync/ip_list.dart';
import 'package:jhopping_list/providers/pairing_provider.dart';
import 'package:provider/provider.dart';

class HTTPManageWidget extends StatelessWidget {
  const HTTPManageWidget({super.key});

  Widget serveControlls(BuildContext context) {
    HttpServerStateProvider serverStateProvider = context.watch();

    return Column(
      mainAxisSize: MainAxisSize.min,

      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Builder(
            builder: (context) {
              Widget child;

              switch (serverStateProvider.getServerStatus()) {
                case ServerStatus.running:
                  child = Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IpList(),
                      TextButton(
                        onPressed: () async {
                          await serverStateProvider.stopServer();
                        },
                        child: Text("Detener servidor"),
                      ),
                    ],
                  );
                  break;
                case ServerStatus.stopped:
                  child = TextButton(
                    onPressed: () async {
                      await serverStateProvider.tryStartServer();
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
                      Text("Error iniciando servidor: ${serverStateProvider.getServerError()}"),
                      TextButton(
                        onPressed: () async {
                          await serverStateProvider.tryStartServer();
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
    SharedPreferencesProvider sharedPreferencesProvider = context.watch();
    PairingProvider pairingProvider = context.watch();
    TextEditingController hostTextController = TextEditingController();
    TextEditingController portTextController = TextEditingController();

    var toast = ScaffoldMessenger.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(controller: hostTextController, decoration: InputDecoration(labelText: "Dirección remota", border: OutlineInputBorder())),
          TextField(controller: portTextController, decoration: InputDecoration(labelText: "Puerto remoto (4545)", border: OutlineInputBorder())),
          TextButton(
            onPressed: () async {
              var host = hostTextController.text;
              if (host.isEmpty) {
                toast.showSnackBar(SnackBar(content: Text("Error: la dirección remota no puede estar vacía")));
                return;
              }

              var port = int.tryParse(portTextController.text) ?? 4545;

              portTextController.text = port.toString();

              var textUrl = "http://$host:$port/add_pairing";

              Uri? uri;
              try {
                uri = Uri.parse(textUrl);
                http.Response response = await http.post(
                  uri,
                  body: jsonEncode({
                    "nick": await sharedPreferencesProvider.getLocalNick(),
                    "terminalId": await sharedPreferencesProvider.getTerminalId(),
                  }),
                  headers: {"Content-Type": "application/json"},
                );

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

                print("Response: ${response.body}");

                var responseContents = jsonDecode((response).body);
                print("Response: ${responseContents}");

                if (responseContents["token"] == null) {
                  toast.showSnackBar(SnackBar(content: Text("Error al conectar con el servidor remoto, no ha devuelto un token")));
                  return;
                }

                pairingProvider.addHttpServerToRemoteTerminal(
                  responseContents["terminalId"],
                  host,
                  port,
                  responseContents["token"],
                  responseContents["nick"],
                );
              } on FormatException catch (_, e) {
                toast.showSnackBar(SnackBar(content: Text("Error de formato en el host $host, la url construida es \"$textUrl\". Error. $e")));
              } catch (e) {
                toast.showSnackBar(SnackBar(content: Text("Error: $e")));
              }
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
          ContentSizeTabBarView(children: [serveControlls(context), clientControlls(context)]),
        ],
      ),
    );
  }
}
