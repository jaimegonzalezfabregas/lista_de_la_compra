import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra/providers/shared_preferences_provider.dart';
import 'package:lista_de_la_compra/UI/sync/http_view.dart';
import 'package:lista_de_la_compra/sync/open_connection_manager.dart';
import 'package:lista_de_la_compra/UI/sync/past_pairings_widget.dart';
import 'package:provider/provider.dart';

class SyncView extends StatefulWidget {
  final OpenConnectionManager openConnectionManager;

  const SyncView(this.openConnectionManager, {super.key});

  @override
  State<SyncView> createState() => _SyncViewState();
}

// TODO unusable because new "needed prdcuct checkbox"

class _SyncViewState extends State<SyncView> {
  HttpServer? server;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(appLoc.syncronization, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Text(appLoc.generalConfig, style: Theme.of(context).textTheme.titleSmall),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Builder(
                builder: (context) {
                  SharedPreferencesProvider sharedPreferencesProvider = context.watch();
                  var textControler = TextEditingController();

                  sharedPreferencesProvider.getLocalNick().then((String? value) {
                    if (value == null) {
                      value = appLoc.noNick;
                      sharedPreferencesProvider.setLocalNick(value);
                    }
                    textControler.text = value;
                  });

                  return Row(
                    children: [
                      Expanded(child: TextField(decoration: InputDecoration(labelText: appLoc.nick), enabled: false, controller: textControler)),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(appLoc.changeNick),
                                content: TextField(decoration: InputDecoration(labelText: appLoc.nick), controller: textControler),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(appLoc.cancel),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      sharedPreferencesProvider.setLocalNick(textControler.text);
                                      Navigator.of(context).pop();
                                      widget.openConnectionManager.triggerHandshakePush();
                                    },
                                    child: Text(appLoc.save),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            Text(appLoc.pastPairings, style: Theme.of(context).textTheme.titleSmall),
            RemoteTerminalList(),
            HTTPView(widget.openConnectionManager),
          ],
        ),
      ),
    );
  }
}
