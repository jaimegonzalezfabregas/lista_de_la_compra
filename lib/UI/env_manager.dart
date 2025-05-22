import 'package:flutter/material.dart';
import 'package:jhopping_list/UI/home.dart';
import 'package:jhopping_list/UI/sync/sync_view.dart';
import 'package:jhopping_list/db/database.dart';
import 'package:jhopping_list/providers/enviroment_provider.dart';
import 'package:jhopping_list/providers/open_conection_provider.dart';
import 'package:jhopping_list/sync/open_connection_manager.dart';
import 'package:provider/provider.dart';

// TODO el nombre del env no se pasa a terminales nuevos

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
              showDialog(
                context: context,
                builder: (context) {
                  TextEditingController textControler = TextEditingController();
                  textControler.text = env.name;
                  return AlertDialog(
                    title: Text("Cambiar nombre"),
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
                          enviromentProvider.setName(env.id, textControler.text.trim());
                          Navigator.of(context).pop();
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
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home(env.id, openConnectionManager)));
      },
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

      for (OpenConnection openConnection in openConnectionProvider.openConnections) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Entornos locales"),
            offlineEnviromentList(context),
            Text("Entornos en maquinas sincronizadas"),

            peerEnviromentList(context),

            OutlinedButton(
              onPressed: () {
                createNewEnviromentPopup(context);
              },
              child: Row(children: [Icon(Icons.add), SizedBox(width: 8), Text("Crear entorno")]),
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
    );
  }
}
