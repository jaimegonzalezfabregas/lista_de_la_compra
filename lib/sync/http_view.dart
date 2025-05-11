import 'package:contentsize_tabbarview/contentsize_tabbarview.dart';
import 'package:flutter/material.dart';
import 'package:jhopping_list/providers/http_server_state_provider.dart';
import 'package:jhopping_list/sync/ip_list_view.dart';
import 'package:jhopping_list/sync/http_client_manager.dart';
import 'package:provider/provider.dart';

class HTTPView extends StatelessWidget {
  final HttpClientManager syncManager;

  const HTTPView(this.syncManager, {super.key});

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
                      IpListView(),
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
    TextEditingController hostTextController = TextEditingController();
    TextEditingController portTextController = TextEditingController();

    var toast = ScaffoldMessenger.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: hostTextController,
              decoration: InputDecoration(labelText: "Dirección remota", border: OutlineInputBorder()),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: portTextController,
              decoration: InputDecoration(labelText: "Puerto remoto (4545)", border: OutlineInputBorder()),
            ),
          ),
          TextButton(
            onPressed: () async {
              var host = hostTextController.text;
              if (host.isEmpty) {
                toast.showSnackBar(SnackBar(content: Text("Error: la dirección remota no puede estar vacía")));
                return;
              }

              var port = int.tryParse(portTextController.text) ?? 4545;

              portTextController.text = port.toString();

              syncManager.tryConnectingToHttpServer(host, port);
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
