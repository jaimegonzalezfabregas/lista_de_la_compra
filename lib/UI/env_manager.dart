import 'package:flutter/material.dart';
import 'package:jhopping_list/UI/home.dart';
import 'package:jhopping_list/db/database.dart';
import 'package:jhopping_list/providers/enviroment_provider.dart';
import 'package:jhopping_list/providers/shared_preferences_provider.dart';
import 'package:provider/provider.dart';

class EnvSelect extends StatelessWidget {
  const EnvSelect({super.key});

  @override
  Widget build(BuildContext context) {
    SharedPreferencesProvider sharedPreferencesProvider = context.watch();
    EnviromentProvider enviromentProvider = context.watch();

    Future<Enviroment?> currentEnviromentId = sharedPreferencesProvider.getCurrnetEnviromentId().then(
      (String? id) async => id == null ? null : await enviromentProvider.getProductById(id),
    );

    return FutureBuilder(
      future: currentEnviromentId,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(title: Text("Home"), backgroundColor: Theme.of(context).colorScheme.primaryContainer),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  FilledButton(
                    onPressed: () {
                      Enviroment? env = snapshot.data;
                      if (env != null) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Home(env)));
                      }
                    },
                    child: Text("Entrar en el entorno"),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Text("Cargando...");
        }
      },
    );
  }
}
