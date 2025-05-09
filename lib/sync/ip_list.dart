import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IpList extends StatefulWidget {
  const IpList({super.key});

  @override
  State<IpList> createState() => _IpListState();
}

class _IpListState extends State<IpList> {
  @override
  Widget build(BuildContext context) {
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
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("Dirección IP (${address.address}) copiada al portapapeles")));
                      },
                      icon: Icon(Icons.copy),
                    ),
                  ),
              TextButton(onPressed: () => setState(() {}), child: Text("Refrescar IPs")),
            ],
          );
        }
        return Text("Cargando direcciones IP...");
      },
    );
  }
}
