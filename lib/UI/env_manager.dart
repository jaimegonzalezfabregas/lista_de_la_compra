import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/sync/sync_view.dart';
import 'package:lista_de_la_compra_http_server/src/db/database.dart';
import 'package:lista_de_la_compra_http_server/src/sync/enviroment_serializer.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra_http_server/src/db_providers/enviroment_provider.dart';
import 'package:lista_de_la_compra/shared_preference_providers/persistant_shared_preferences_provider.dart';
import 'package:lista_de_la_compra_http_server/src/shared_preferences_providers/shared_preferences_provider.dart';
import 'package:lista_de_la_compra_http_server/src/sync/open_conection_provider.dart';
import 'package:lista_de_la_compra_http_server/src/db_providers/product_provider.dart';
import 'package:lista_de_la_compra_http_server/src/db_providers/recipe_provider.dart';
import 'package:lista_de_la_compra_http_server/src/db_providers/schedule_provider.dart';
import 'package:lista_de_la_compra_http_server/src/sync/open_connection.dart';
import 'package:lista_de_la_compra_http_server/src/sync/open_connection_manager.dart';
import 'package:provider/provider.dart';

import '../flutter_providers/flutter_providers.dart';

class EnvSelect extends StatelessWidget {
  final OpenConnectionManager openConnectionManager;
  const EnvSelect(this.openConnectionManager, {super.key});

  void showEditEnviromentDialog(BuildContext context, EnviromentProvider enviromentProvider, Enviroment env) {
    final formKey = GlobalKey<FormState>();
    final AppLocalizations appLoc = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) {
        TextEditingController textControler = TextEditingController();
        textControler.text = env.name;
        return AlertDialog(
          title: Text(appLoc.changeName),
          content: Form(
            key: formKey,
            child: TextFormField(
              decoration: InputDecoration(labelText: appLoc.name),
              controller: textControler,
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return appLoc.theNameCantBeEmpty;
                }
                return null;
              },
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(appLoc.cancel),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  enviromentProvider.setName(env.id, textControler.text.trim());
                  Navigator.of(context).pop();
                }
              },
              child: Text(appLoc.save),
            ),
          ],
        );
      },
    );
  }

  Widget getOfflineListTile(
    BuildContext context,
    EnviromentProvider enviromentProvider,
    Enviroment env,
    SharedPreferencesProvider sharedPreferencesProvider,
  ) {
    return ListTile(
      onTap: () {
        sharedPreferencesProvider.setSelectedEnviroment(env.id);
      },
      title: Text(env.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              showEditEnviromentDialog(context, enviromentProvider, env);
            },
            icon: Icon(Icons.edit),
          ),

          IconButton(
            onPressed: () {
              enviromentProvider.deleteById(env.id);
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  Widget offlineEnviromentList(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;
    SharedPreferencesProvider sharedPreferencesProvider = context.watch<PersistantSharedPreferencesProvider>();


    return Builder(
      builder: (context) {
        EnviromentProvider enviromentProvider = context.watch<FlutterEnviromentProvider>();
        return FutureBuilder(
          future: enviromentProvider.getEnviromentList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(child: Text(appLoc.thisListHasNoResults));
              }
              return ListView(shrinkWrap: true, children: snapshot.data!.map((env) => getOfflineListTile(context, enviromentProvider, env,sharedPreferencesProvider)).toList());
            } else if (snapshot.hasError) {
              return Text("$snapshot");
            } else {
              return Text(appLoc.loading);
            }
          },
        );
      },
    );
  }

  Widget getRemoteListTile(BuildContext context, EnviromentProvider enviromentProvider, Enviroment env) {
    return ListTile(
      title: Text(env.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              enviromentProvider.upsertEnviroment(env);
              openConnectionManager.triggerSyncPull();
            },
            icon: Icon(Icons.download),
          ),
        ],
      ),
    );
  }

  Widget peerEnviromentList(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;

    EnviromentProvider enviromentProvider = context.watch<FlutterEnviromentProvider>();
    OpenConnectionProvider openConnectionProvider = context.watch<FlutterOpenConnectionProvider>();

    Future<Iterable<Enviroment>> getPeerEnviromentList() async {
      Map<String, Enviroment> remoteEnviroments = {};

      for (OpenConnection openConnection in openConnectionProvider.openConnections.values) {
        for (Enviroment remoteEnviroment in openConnection.enviromentList) {
          if (await enviromentProvider.getEnviromentById(remoteEnviroment.id) != null) {
            continue;
          }

          var alreadyAddedEnviroment = remoteEnviroments[remoteEnviroment.id];
          if (alreadyAddedEnviroment == null || alreadyAddedEnviroment.updatedAt < remoteEnviroment.updatedAt) {
            remoteEnviroments[remoteEnviroment.id] = remoteEnviroment;
          }
        }
      }
      return remoteEnviroments.values;
    }

    return Builder(
      builder: (context) {
        return FutureBuilder(
          future: getPeerEnviromentList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(child: Text(appLoc.thisListHasNoResults));
              }
              return ListView(shrinkWrap: true, children: snapshot.data!.map((env) => getRemoteListTile(context, enviromentProvider, env)).toList());
            } else if (snapshot.hasError) {
              return Text("$snapshot");
            } else {
              return Text(appLoc.loading);
            }
          },
        );
      },
    );
  }

  void createNewEnviromentPopup(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) {
        TextEditingController textControler = TextEditingController();
        return AlertDialog(
          title: Text(appLoc.createEnviroment),
          content: TextField(decoration: InputDecoration(labelText: appLoc.name), controller: textControler),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(appLoc.cancel),
            ),
            TextButton(
              onPressed: () {
                EnviromentProvider enviromentProvider = context.read();
                enviromentProvider.addEmptyEnviroment(textControler.text);
                Navigator.of(context).pop();
              },
              child: Text(appLoc.save),
            ),
          ],
        );
      },
    );
  }

  void importNewEnviroment(
    BuildContext context,
    EnviromentProvider enviromentProvider,
    ProductProvider productProvider,
    RecipeProvider recipeProvider,
    ScheduleProvider scheduleProvider,
  ) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(withData: true);

    if (result != null) {
      PlatformFile file = result.files.first;

      final Map<String, dynamic> serializedState = jsonDecode(utf8.decode(file.bytes!.toList()));

      Enviroment remoteEnviroment = Enviroment.fromJson(serializedState["enviroment"]);
      Enviroment? currentEnviroment = await enviromentProvider.getEnviromentById(remoteEnviroment.id);
      if (currentEnviroment == null) {
        enviromentProvider.upsertEnviroment(remoteEnviroment);
      }

      recieveState(serializedState, enviromentProvider, productProvider, recipeProvider, scheduleProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    EnviromentProvider enviromentProvider = context.watch<FlutterEnviromentProvider>();
    ProductProvider productProvider = context.watch<FlutterProductProvider>();
    RecipeProvider recipeProvider = context.watch<FlutterRecipeProvider>();
    ScheduleProvider scheduleProvider = context.watch<FlutterScheduleProvider>();
    final AppLocalizations appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),

        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(appLoc.aviableEnviromentsWithoutConnection),
              offlineEnviromentList(context),
              SizedBox(height: 30),

              Text(appLoc.enviromentsOnOtherMachines),

              peerEnviromentList(context),
              SizedBox(height: 30),

              OutlinedButton(
                onPressed: () {
                  createNewEnviromentPopup(context);
                },
                child: Row(children: [Icon(Icons.add), SizedBox(width: 8), Text(appLoc.createEnviroment)]),
              ),
              SizedBox(height: 10),

              OutlinedButton(
                onPressed: () {
                  importNewEnviroment(context, enviromentProvider, productProvider, recipeProvider, scheduleProvider);
                },
                child: Row(children: [Icon(Icons.file_copy), SizedBox(width: 8), Text(appLoc.importEnviroment)]),
              ),
              SizedBox(height: 10),

              OutlinedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SyncView(openConnectionManager)));
                },
                child: Row(children: [Icon(Icons.add_link), SizedBox(width: 8), Text(appLoc.syncronization)]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
