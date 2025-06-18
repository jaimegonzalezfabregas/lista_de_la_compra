import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/Actions/export_controls.dart';
import 'package:lista_de_la_compra/UI/sync/sync_view.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra/providers/shared_preferences_provider.dart';
import 'package:lista_de_la_compra/sync/open_connection_manager.dart';
import 'package:provider/provider.dart';

class Actionindex extends StatelessWidget {
  final String enviromentId;
  final OpenConnectionManager openConnectionManager;

  const Actionindex(this.enviromentId, this.openConnectionManager, {super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;
    final SharedPreferencesProvider sharedPreferencesProvider = context.watch();

    return Scaffold(
      appBar: AppBar(
        title: Text(appLoc.actions, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [

            OutlinedButton(
              child: Row(children: [Icon(Icons.swap_horiz), SizedBox(width: 8), Text(appLoc.switchEnviroment)]),
              onPressed: () {
                sharedPreferencesProvider.clearSelectedEnviroment();
              },
            ),

            OutlinedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SyncView(openConnectionManager)));
              },
              child: Row(children: [Icon(Icons.add_link), SizedBox(width: 8), Text(appLoc.syncronization)]),
            ),
            ExporControls(enviromentId),
          ],
        ),
      ),
    );
  }
}
