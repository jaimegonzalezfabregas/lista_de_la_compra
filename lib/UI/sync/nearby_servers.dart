import 'package:flutter/material.dart';
import 'package:jhopping_list/sync/open_connection_manager.dart';
import 'package:nsd/nsd.dart';

class DiscoveredPear {}

class _NearbyServers extends State<NearbyServers> {
  Discovery? discovery;

  _NearbyServers() {
    startDiscovery('_jhop._tcp').then((d) {
      d.addListener(() {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (discovery == null) {
      return Text("Comenzando busqueda");
    } else {
      if (discovery!.services.isEmpty) {
        return Text("Todavía no se han encontrado resultados");
      } else {
        return ListView(
          children:
              discovery!.services.map((Service service) {
                return ListTile(
                  title: Text(service.name ?? "Sin nombre"),
                  subtitle: Text(service.host ?? "Sin host"),
                  trailing: IconButton(
                    onPressed: () {
                      widget.openConnectionManager.tryConnectingToHttpServer(service.host!, service.port!, widget.enviromentId);
                    },
                    icon: Icon(Icons.add_link),
                  ),
                );
              }).toList(),
        );
      }
    }
  }
}

class NearbyServers extends StatefulWidget {
  final OpenConnectionManager openConnectionManager;
  final String enviromentId;

  const NearbyServers(this.openConnectionManager, this.enviromentId, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _NearbyServers();
  }
}
