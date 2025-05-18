import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jhopping_list/db/database.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShareEnviroment extends StatelessWidget {
  final Enviroment enviroment;

  const ShareEnviroment(this.enviroment, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Compartir (${enviroment.name})"), backgroundColor: Theme.of(context).colorScheme.surfaceContainer),
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
                    Container(color: Colors.white, child: QrImageView(data: jsonEncode(enviroment.id), version: QrVersions.auto)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(enviroment.id, style: Theme.of(context).textTheme.bodyMedium),
                        IconButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: enviroment.id));
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
