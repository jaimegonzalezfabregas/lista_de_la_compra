import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/recipies/recipe_manager.dart';
import 'package:lista_de_la_compra/UI/products/simple_shopping_list.dart';
import 'package:lista_de_la_compra/UI/schedule/schedule_view.dart';
import 'package:lista_de_la_compra/UI/schedule/utils.dart';
import 'package:lista_de_la_compra/providers/enviroment_provider.dart';
import 'package:lista_de_la_compra/sync/open_connection_manager.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final String enviromentId;
  final OpenConnectionManager openConnectionManager;
  const Home(this.enviromentId, this.openConnectionManager, {super.key});

  Widget button(String lable, Widget page, BuildContext context, {bool disabled = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: disabled ? null : () => {Navigator.push(context, MaterialPageRoute(builder: (context) => page))},
          child: Text(lable),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    EnviromentProvider enviromentProvider = context.watch();
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.surfaceContainer, title: FutureBuilder(
          future: enviromentProvider.getEnviromentById(enviromentId),
          builder: (context, snapshot) {
            String envName = "Cargando...";
            if (snapshot.hasData) {
              envName = snapshot.data!.name;
            }

            if (snapshot.hasError) {
              envName = "error!";
            }

            return Text("Home ($envName)");
          },
        ),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            button("Lista de la compra", SimpleShoppinglist(enviromentId), context),
            button("Lista de Recetas", RecipeView(enviromentId), context),
            button("Agenda", ScheduleView(getCurrentWeek(), enviromentId), context),
          ],
        ),
      ),
    );
  }
}
