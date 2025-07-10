import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra/sync/open_conection_provider.dart';
import 'package:lista_de_la_compra/sync/open_connection.dart';
import 'package:provider/provider.dart';

class OpenConnectionsList extends StatelessWidget {
  const OpenConnectionsList({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;

    OpenConnectionProvider openConnectionProvider = context.watch();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Builder(
            builder: (context) {
              List<OpenConnection> openConnections = openConnectionProvider.openConnections.values.toList();
          
              if (openConnections.isEmpty) {
                return Center(child: Text(appLoc.noOpenConnection));
              }
          
              return ListView.builder(
                shrinkWrap: true,
                itemCount: openConnections.length,
                itemBuilder: (context, index) {
                  OpenConnection openConnection = openConnections[index];
          
                  return ListTile(
                    title: Row(children: [Icon(Icons.link), Text(openConnection.nick)]),
                    subtitle: Text(openConnection.userNote),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (openConnection.latency != null) Text("(${openConnection.latency}ms)"),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            openConnectionProvider.removeOpenConnection(openConnection.id);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
