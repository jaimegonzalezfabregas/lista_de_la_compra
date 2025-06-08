import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/home.dart';
import 'package:lista_de_la_compra/UI/sync/sync_view.dart';
import 'package:lista_de_la_compra/db/database.dart';
import 'package:lista_de_la_compra/enviroment_serializer.dart';
import 'package:lista_de_la_compra/providers/enviroment_provider.dart';
import 'package:lista_de_la_compra/providers/open_conection_provider.dart';
import 'package:lista_de_la_compra/providers/product_provider.dart';
import 'package:lista_de_la_compra/providers/recipe_provider.dart';
import 'package:lista_de_la_compra/providers/schedule_provider.dart';
import 'package:lista_de_la_compra/sync/open_connection.dart';
import 'package:lista_de_la_compra/sync/open_connection_manager.dart';
import 'package:provider/provider.dart';

class EnvSelect extends StatelessWidget {
  final OpenConnectionManager openConnectionManager;
  const EnvSelect(this.openConnectionManager, {super.key});

  Widget getOfflineListTile(BuildContext context, EnviromentProvider enviromentProvider, Enviroment env) {
    return ListTile(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home(env.id, openConnectionManager)));
      },
      title: Text(env.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              final formKey = GlobalKey<FormState>();

              showDialog(
                context: context,
                builder: (context) {
                  TextEditingController textControler = TextEditingController();
                  textControler.text = env.name;
                  return AlertDialog(
                    title: Text("Cambiar nombre"),
                    content: Form(
                      key: formKey,
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Nombre'),
                        controller: textControler,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'El nombre no puede estar vacío';
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
                        child: Text("Cancelar"),
                      ),
                      TextButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            enviromentProvider.setName(env.id, textControler.text.trim());
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text("Guardar"),
                      ),
                    ],
                  );
                },
              );
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
    return Builder(
      builder: (context) {
        EnviromentProvider enviromentProvider = context.watch();
        return FutureBuilder(
          future: enviromentProvider.getEnviromentList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(child: Text("Esta lista no tiene resultados"));
              }
              return ListView(shrinkWrap: true, children: snapshot.data!.map((env) => getOfflineListTile(context, enviromentProvider, env)).toList());
            } else if (snapshot.hasError) {
              return Text("$snapshot");
            } else {
              return Text("Cargando...");
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
              enviromentProvider.addEnviroment(env);
              openConnectionManager.triggerSyncPull();
            },
            icon: Icon(Icons.download),
          ),
        ],
      ),
    );
  }

  Widget peerEnviromentList(BuildContext context) {
    EnviromentProvider enviromentProvider = context.watch();
    OpenConnectionProvider openConnectionProvider = context.watch();

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
                return Center(child: Text("Esta lista no tiene resultados"));
              }
              return ListView(shrinkWrap: true, children: snapshot.data!.map((env) => getRemoteListTile(context, enviromentProvider, env)).toList());
            } else if (snapshot.hasError) {
              return Text("$snapshot");
            } else {
              return Text("Cargando...");
            }
          },
        );
      },
    );
  }

  void createNewEnviromentPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController textControler = TextEditingController();
        return AlertDialog(
          title: Text("Crear entorno"),
          content: TextField(decoration: InputDecoration(labelText: "Nombre"), controller: textControler),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                EnviromentProvider enviromentProvider = context.read();
                enviromentProvider.addEmptyEnviroment(textControler.text);
                Navigator.of(context).pop();
              },
              child: Text("Guardar"),
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
        enviromentProvider.addEnviroment(remoteEnviroment);
      }

      recieveState(serializedState, enviromentProvider, productProvider, recipeProvider, scheduleProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    EnviromentProvider enviromentProvider = context.watch();
    ProductProvider productProvider = context.watch();
    RecipeProvider recipeProvider = context.watch();
    ScheduleProvider scheduleProvider = context.watch();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),

        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Text("Entornos disponibles sin conexión"),
              offlineEnviromentList(context),
              SizedBox(height: 30),

              Text("Entornos en otras máquinas"),

              peerEnviromentList(context),
              SizedBox(height: 30),

              OutlinedButton(
                onPressed: () {
                  createNewEnviromentPopup(context);
                },
                child: Row(children: [Icon(Icons.add), SizedBox(width: 8), Text("Crear entorno")]),
              ),
              SizedBox(height: 10),

              OutlinedButton(
                onPressed: () {
                  importNewEnviroment(context, enviromentProvider, productProvider, recipeProvider, scheduleProvider);
                },
                child: Row(children: [Icon(Icons.file_copy), SizedBox(width: 8), Text("Importar entorno")]),
              ),
              SizedBox(height: 10),

              OutlinedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SyncView(openConnectionManager)));
                },
                child: Row(children: [Icon(Icons.add_link), SizedBox(width: 8), Text("Sincronización")]),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
