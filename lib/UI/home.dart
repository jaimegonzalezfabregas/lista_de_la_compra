import 'package:flutter/material.dart';
import 'package:jhopping_list/UI/maps/map_list.dart';
import 'package:jhopping_list/UI/recipies/recipe_manager.dart';
import 'package:jhopping_list/UI/products/simple_shopping_list.dart';
import 'package:jhopping_list/UI/schedule/schedule_view.dart';
import 'package:jhopping_list/UI/schedule/utils.dart';
import 'package:jhopping_list/db/database.dart';
import 'package:jhopping_list/sync/open_connection_manager.dart';
import 'package:jhopping_list/UI/sync/sync_view.dart';

class Home extends StatelessWidget {
  final Enviroment enviroment;
  final OpenConnectionManager openConnectionManager;
  const Home(this.enviroment, this.openConnectionManager, {super.key});

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
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.surfaceContainer, title: Text("Home")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            button("Lista de la compra", SimpleShoppinglist(enviroment.id), context),
            button("Lista de Recetas", RecipeView(enviroment.id), context),
            button("Agenda", ScheduleView(getCurrentWeek(), enviroment.id), context),
            button("Sincronización", SyncView(openConnectionManager, enviroment.id), context),
            button("Lista de Mapas", MapList(), context, disabled: true),
          ],
        ),
      ),
    );
  }
}
