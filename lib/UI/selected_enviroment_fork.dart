import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/env_manager.dart';
import 'package:lista_de_la_compra/UI/home.dart';
import 'package:lista_de_la_compra/shared_preference_providers/shared_preferences_provider.dart';
import 'package:lista_de_la_compra/sync/open_connection_manager.dart';
import 'package:provider/provider.dart';

class SelectedEnviromentFork extends StatelessWidget {
  final OpenConnectionManager openConnectionManager;

  const SelectedEnviromentFork(this.openConnectionManager, {super.key});

  @override
  Widget build(BuildContext context) {
    SharedPreferencesProvider sharedPreferencesProvider = context.watch();

    return FutureBuilder(
      future: sharedPreferencesProvider.getSelectedEnviroment(),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.done) {
          String? selectedEnviroment = asyncSnapshot.data;

          if (selectedEnviroment == null) {
            return EnvSelect(openConnectionManager);
          } else {
            return Home(selectedEnviroment, openConnectionManager);
          }
        }
        if (asyncSnapshot.hasError) {
          return Text("$asyncSnapshot");
        } else {
          return Scaffold();
        }
      },
    );
  }
}
