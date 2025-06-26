import 'package:contentsize_tabbarview/contentsize_tabbarview.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/sync/http/known_servers.dart';
import 'package:lista_de_la_compra/UI/sync/nearby_servers.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra/db_providers/http_server_provider.dart';
import 'package:lista_de_la_compra/db_providers/http_server_state_provider.dart';
import 'package:lista_de_la_compra/UI/sync/ip_list_view.dart';
import 'package:lista_de_la_compra/sync/open_connection_manager.dart';
import 'package:provider/provider.dart';

class HTTPView extends StatelessWidget {
  final OpenConnectionManager openConnectionManager;

  const HTTPView(this.openConnectionManager, {super.key});

  Widget serveControlls(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;

    HttpServerStateProvider serverStateProvider = context.watch();

    switch (serverStateProvider.getServerStatus()) {
      case ServerStatus.running:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(appLoc.localDeviceAvailableIPs),
            IpListView(),
            TextButton(
              onPressed: () async {
                await serverStateProvider.stopServer();
              },
              child: Text(appLoc.stopServer),
            ),
          ],
        );
      case ServerStatus.stopped:
        return TextButton(
          onPressed: () async {
            await serverStateProvider.tryStartServer();
          },
          child: Text(appLoc.startServer),
        );
      case ServerStatus.turningOn:
        return Text(appLoc.startingServer);
      case ServerStatus.turningOff:
        return Text(appLoc.stoppingServer);
      case ServerStatus.error:
        return Column(
          children: [
            Text("${appLoc.errorStartingServer}: ${serverStateProvider.getServerError()}"),
            TextButton(
              onPressed: () async {
                await serverStateProvider.tryStartServer();
              },
              child: Text(appLoc.startServer),
            ),
          ],
        );
    }
  }

  Widget clientControlls(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;
    final HttpServerProvider httpServerProvider = context.watch();

    TextEditingController hostTextController = TextEditingController();

    var toast = ScaffoldMessenger.of(context);

    return Column(
      children: [
        Text(appLoc.nearbyDevices),

        NearbyServers(openConnectionManager),

        Text(appLoc.enterAddressManually),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: hostTextController,
            decoration: InputDecoration(labelText: appLoc.remoteAddress, border: OutlineInputBorder()),
          ),
        ),

        TextButton(
          onPressed: () async {
            var host = hostTextController.text;
            if (host.isEmpty) {
              toast.showSnackBar(SnackBar(content: Text(appLoc.errorEmptyRemoteAddress)));
              return;
            }

            httpServerProvider.addHttpServer(host, 4545);
          },
          child: Text(appLoc.connect),
        ),

        Text(appLoc.knownServers),

        HTTPKnownServers(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;

    Widget putInsideContainer(Widget child) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(10)),
          child: Padding(padding: const EdgeInsets.all(8.0), child: child),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: appLoc.server),
              Tab(text: appLoc.client),
            ],
          ),
          ContentSizeTabBarView(children: [serveControlls(context), clientControlls(context)].map(putInsideContainer).toList()),
        ],
      ),
    );
  }
}
