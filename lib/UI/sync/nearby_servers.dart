import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra_backend/src/db_providers/http_server_provider.dart';
import 'package:lista_de_la_compra/shared_preference_providers/persistant_shared_preferences_provider.dart';
import 'package:lista_de_la_compra_backend/src/shared_preferences_providers/shared_preferences_provider.dart';
import 'package:lista_de_la_compra_backend/src/sync/open_connection_manager.dart';
import 'package:nsd/nsd.dart';
import 'package:provider/provider.dart';

import 'package:collection/collection.dart';

import '../../flutter_providers/flutter_providers.dart';

class DiscoveredPeer {}

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

  Future<(Iterable<Service>, List<Service>)> getDedupedServices(SharedPreferencesProvider sharedPreferencesProvider) async {
    var allServices = discovery!.services;
    List<NetworkInterface> interfaces = await NetworkInterface.list();
    List<InternetAddress> selfAddresses = interfaces.map((e) => e.addresses).flattenedToList;

    Map<String, Service> dedupedByHostServices = {};
    List<Service> discarded = [];
    for (var service in allServices) {
      String? host = service.host;

      bool isSelf = service.addresses!.toSet().intersection(selfAddresses.toSet()).isEmpty;

      if (host != null && !dedupedByHostServices.containsKey(service.host) && isSelf) {
        dedupedByHostServices[host] = service;
      } else {
        discarded.add(service);
      }
    }

    return (dedupedByHostServices.values, discarded);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;
    SharedPreferencesProvider sharedPreferencesProvider = context.watch<PersistantSharedPreferencesProvider>();
    HttpServerProvider httpServerProvider = context.watch<FlutterHttpServerProvider>();

    if (discovery == null) {
      return Text(appLoc.scanStarted);
    } else {
      Future<(Iterable<Service>, List<Service>)> dedupedServices = getDedupedServices(sharedPreferencesProvider);

      if (discovery!.services.isEmpty) {
        return Text(appLoc.noResultsYet);
      } else {
        return FutureBuilder(
          future: dedupedServices,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text(appLoc.loading);
            }

            var (Iterable<Service> selected, List<Service> discarded) = snapshot.data!;

            var children = selected.map((Service service) {
              return ListTile(
                title: Text(service.name ?? appLoc.noName),
                subtitle: Text(service.addresses?[0].address ?? appLoc.noHost),
                trailing: IconButton(
                  onPressed: () {
                    httpServerProvider.addHttpServer(service.addresses![0].address, service.port!);
                  },
                  icon: Icon(Icons.add_link),
                ),
              );
            });

            return ListView(shrinkWrap: true, children: children.toList());
          },
        );
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
