import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jhopping_list/providers/enviroment_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShareEnviroment extends StatelessWidget {
  final String enviromentId;

  const ShareEnviroment(this.enviromentId, {super.key});

  @override
  Widget build(BuildContext context) {
    EnviromentProvider enviromentProvider = context.watch();
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: enviromentProvider.getEnviromentById(enviromentId),
          builder: (context, snapshot) {
            String envName = "Cargando...";
            if (snapshot.hasData) {
              envName = snapshot.data!.name;
            }

            if (snapshot.hasError) {
              envName = "error!";
            }

            return Text("Compartir ($envName)");
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),

            child: Container(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(color: Colors.white, child: QrImageView(data: jsonEncode(enviromentId), version: QrVersions.auto)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(enviromentId, style: Theme.of(context).textTheme.bodyMedium),
                        IconButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: enviromentId));
                          },
                          icon: Icon(Icons.copy),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
