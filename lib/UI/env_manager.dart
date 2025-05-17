import 'package:flutter/material.dart';
import 'package:jhopping_list/UI/home.dart';
import 'package:jhopping_list/UI/share_enviroment.dart';
import 'package:jhopping_list/db/database.dart';
import 'package:jhopping_list/providers/enviroment_provider.dart';
import 'package:provider/provider.dart';

class EnvSelect extends StatelessWidget {
  const EnvSelect({super.key});

  @override
  Widget build(BuildContext context) {
    EnviromentProvider enviromentProvider = context.watch();

    Future<List<Enviroment>> enviroment_list_future = enviromentProvider.getEnviromentList();

    return Scaffold(
      body: FutureBuilder(
        future: enviroment_list_future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children:
                          snapshot.data!
                              .map(
                                (env) => ListTile(
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
                                                      enviromentProvider.setName(env.id, textControler.text);
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
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => Home(env)));
                                        },
                                        icon: Icon(Icons.arrow_outward),
                                      ),

                                      IconButton(
                                        icon: Icon(Icons.share),
                                        onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => ShareEnviroment(env)));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OutlinedButton(
                        onPressed: () {
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
                                      enviromentProvider.addEnviroment(textControler.text);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Guardar"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Row(children: [Icon(Icons.add), SizedBox(width: 8), Text("Crear entorno")]),
                      ),
                      SizedBox(height: 10),
                      OutlinedButton(onPressed: () {}, child: Row(children: [Icon(Icons.download), SizedBox(width: 8), Text("Cargar entorno")])),
                    ],
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text("$snapshot");
          } else {
            return Text("Cargando...");
          }
        },
      ),
    );
  }
}
