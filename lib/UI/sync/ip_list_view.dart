import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';

class IpListView extends StatefulWidget {
  const IpListView({super.key});

  @override
  State<IpListView> createState() => _IpListViewState();
}

class _IpListViewState extends State<IpListView> {
  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;

    var ips = NetworkInterface.list();

    return FutureBuilder(
      future: ips,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var interface in snapshot.data!)
                for (var address in interface.addresses)
                  ListTile(
                    title: Text(address.address),
                    subtitle: Text(interface.name),
                    trailing: IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: address.address));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(appLoc.ipCopied(address.address))));
                      },
                      icon: Icon(Icons.copy),
                    ),
                  ),
              TextButton(onPressed: () => setState(() {}), child: Text(appLoc.ipRefresh)),
            ],
          );
        }
        return Text(appLoc.loadingIps);
      },
    );
  }
}
