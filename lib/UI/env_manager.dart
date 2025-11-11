import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/sync/sync_view.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra/shared_preference_providers/persistant_shared_preferences_provider.dart';
import 'package:provider/provider.dart';
import '../flutter_providers/flutter_providers.dart';

import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';

class EnvSelect extends StatelessWidget {
  final OpenConnectionManager openConnectionManager;
  const EnvSelect(this.openConnectionManager, {super.key});

  void showEditEnvironmentDialog(BuildContext context, EnvironmentProvider environmentProvider, Environment env) {
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
                  environmentProvider.setName(env.id, textControler.text.trim());
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
    EnvironmentProvider environmentProvider,
    Environment env,
    SharedPreferencesProvider sharedPreferencesProvider,
  ) {
    return ListTile(
      onTap: () {
        sharedPreferencesProvider.setSelectedEnvironment(env.id);
      },
      title: Text(env.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              showEditEnvironmentDialog(context, environmentProvider, env);
            },
            icon: Icon(Icons.edit),
          ),

          IconButton(
            onPressed: () {
              environmentProvider.deleteById(env.id);
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  Widget offlineEnvironmentList(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;
    SharedPreferencesProvider sharedPreferencesProvider = context.watch<PersistantSharedPreferencesProvider>();

    return Builder(
      builder: (context) {
        EnvironmentProvider environmentProvider = context.watch<FlutterEnvironmentProvider>();
        return FutureBuilder(
          future: environmentProvider.getEnvironmentList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(child: Text(appLoc.thisListHasNoResults));
              }
              return ListView(
                shrinkWrap: true,
                children: snapshot.data!.map((env) => getOfflineListTile(context, environmentProvider, env, sharedPreferencesProvider)).toList(),
              );
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

  Widget getRemoteListTile(BuildContext context, EnvironmentProvider environmentProvider, Environment env) {
    return ListTile(
      title: Text(env.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              environmentProvider.upsertEnvironment(env);
              openConnectionManager.triggerSyncPull();
            },
            icon: Icon(Icons.download),
          ),
        ],
      ),
    );
  }

  Widget peerEnvironmentList(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;

    EnvironmentProvider environmentProvider = context.watch<FlutterEnvironmentProvider>();
    OpenConnectionProvider openConnectionProvider = context.watch<FlutterOpenConnectionProvider>();

    Future<Iterable<Environment>> getPeerEnvironmentList() async {
      Map<String, Environment> remoteEnvironments = {};

      for (OpenConnection openConnection in openConnectionProvider.openConnections.values) {
        for (Environment remoteEnvironment in openConnection.environmentList) {
          if (await environmentProvider.getEnvironmentById(remoteEnvironment.id) != null) {
            continue;
          }

          var alreadyAddedEnvironment = remoteEnvironments[remoteEnvironment.id];
          if (alreadyAddedEnvironment == null || alreadyAddedEnvironment.updatedAt < remoteEnvironment.updatedAt) {
            remoteEnvironments[remoteEnvironment.id] = remoteEnvironment;
          }
        }
      }
      return remoteEnvironments.values;
    }

    return Builder(
      builder: (context) {
        return FutureBuilder(
          future: getPeerEnvironmentList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(child: Text(appLoc.thisListHasNoResults));
              }
              return ListView(shrinkWrap: true, children: snapshot.data!.map((env) => getRemoteListTile(context, environmentProvider, env)).toList());
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

  void createNewEnvironmentPopup(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) {
        TextEditingController textControler = TextEditingController();
        return AlertDialog(
          title: Text(appLoc.createEnvironment),
          content: TextField(
            decoration: InputDecoration(labelText: appLoc.name),
            controller: textControler,
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
                EnvironmentProvider environmentProvider = context.read<FlutterEnvironmentProvider>();
                environmentProvider.addEmptyEnvironment(textControler.text);
                Navigator.of(context).pop();
              },
              child: Text(appLoc.save),
            ),
          ],
        );
      },
    );
  }

  void importNewEnvironment(
    BuildContext context,
    EnvironmentProvider environmentProvider,
    ProductProvider productProvider,
    RecipeProvider recipeProvider,
    ScheduleProvider scheduleProvider,
    SuperMarketProvider supermarketProvider,
    AisleProvider aisleProvider,
    ProductAisleProvider productAisleProvider,
  ) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(withData: true);

    if (result != null) {
      PlatformFile file = result.files.first;

      final Map<String, dynamic> serializedState = jsonDecode(utf8.decode(file.bytes!.toList()));

      Environment remoteEnvironment = Environment.fromJson(serializedState["environment"]);
      Environment? currentEnvironment = await environmentProvider.getEnvironmentById(remoteEnvironment.id);
      if (currentEnvironment == null) {
        environmentProvider.upsertEnvironment(remoteEnvironment);
      }

      recieveState(
        serializedState,
        environmentProvider,
        productProvider,
        recipeProvider,
        scheduleProvider,
        supermarketProvider,
        aisleProvider,
        productAisleProvider,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    EnvironmentProvider environmentProvider = context.watch<FlutterEnvironmentProvider>();
    ProductProvider productProvider = context.watch<FlutterProductProvider>();
    RecipeProvider recipeProvider = context.watch<FlutterRecipeProvider>();
    ScheduleProvider scheduleProvider = context.watch<FlutterScheduleProvider>();
    SuperMarketProvider supermarketProvider = context.watch<FlutterSuperMarketProvider>();
    AisleProvider aisleProvider = context.watch<FlutterAisleProvider>();
    ProductAisleProvider productAisleProvider = context.watch<FlutterProductAisleProvider>();
    final AppLocalizations appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),

        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(appLoc.availableEnvironmentsWithoutConnection),
              offlineEnvironmentList(context),
              SizedBox(height: 30),

              Text(appLoc.environmentsOnOtherMachines),

              peerEnvironmentList(context),
              SizedBox(height: 30),

              OutlinedButton(
                onPressed: () {
                  createNewEnvironmentPopup(context);
                },
                child: Row(children: [Icon(Icons.add), SizedBox(width: 8), Text(appLoc.createEnvironment)]),
              ),
              SizedBox(height: 10),

              OutlinedButton(
                onPressed: () {
                  importNewEnvironment(
                    context,
                    environmentProvider,
                    productProvider,
                    recipeProvider,
                    scheduleProvider,
                    supermarketProvider,
                    aisleProvider,
                    productAisleProvider,
                  );
                },
                child: Row(children: [Icon(Icons.file_copy), SizedBox(width: 8), Text(appLoc.importEnvironment)]),
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
