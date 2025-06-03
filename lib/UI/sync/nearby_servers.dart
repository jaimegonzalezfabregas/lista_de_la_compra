import 'package:flutter/material.dart';
import 'package:jhopping_list/sync/open_connection_manager.dart';
import 'package:nsd/nsd.dart';

class DiscoveredPeer {}
// TODO dedup by ip

class _NearbyServers extends State<NearbyServers> {
  Discovery? discovery;

  void notifyUpdate() {
    setState(() {});
  }

  _NearbyServers() {
    (() async {
      var d = await startDiscovery('_jhop._tcp');

      d.addListener(notifyUpdate);

      setState(() {
        discovery = d;
      });
    })();
  }

  @override
  void dispose() {
    super.dispose();
    discovery?.removeListener(notifyUpdate);
  }

  @override
  Widget build(BuildContext context) {
    if (discovery == null) {
      return Text("Comenzando busqueda");
    } else {
      // TODO no mostrar el servidor en el que estas al usuario

      if (discovery!.services.isEmpty) {
        return Text("Todavía no se han encontrado resultados");
      } else {
        var allServices = discovery!.services;

        Map<String, Service> dedupedByHostServices = {};
        for (var service in allServices) {
          String? host = service.host;
          if (host != null && !dedupedByHostServices.containsKey(service.host)) {
            dedupedByHostServices[host] = service;
          }
        }

        var children = dedupedByHostServices.values.map((Service service) {
          return ListTile(
            title: Text(service.name ?? "Sin nombre"),
            subtitle: Text(service.host ?? "Sin host"),
            trailing: IconButton(
              onPressed: () {
                widget.openConnectionManager.tryConnectingToHttpServer(service.host!, service.port!);
              },
              icon: Icon(Icons.add_link),
            ),
          );
        });

        return ListView(shrinkWrap: true, children: children.toList());
      }
    }
  }
}

class NearbyServers extends StatefulWidget {
  final OpenConnectionManager openConnectionManager;

  const NearbyServers(this.openConnectionManager, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _NearbyServers();
  }
}
