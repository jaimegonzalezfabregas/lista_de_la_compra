import 'package:flutter/material.dart';
import 'package:jhopping_list/maps/map_list.dart';
import 'package:jhopping_list/recipies/recipe_manager.dart';
import 'package:jhopping_list/products/simple_shopping_list.dart';
import 'package:jhopping_list/schedule/schedule_manager.dart';
import 'package:jhopping_list/schedule/utils.dart';
import 'package:jhopping_list/sync/sync_manager.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
      appBar: AppBar(title: Text("Home"), backgroundColor: Theme.of(context).colorScheme.primaryContainer),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            button("Lista de la Compra", SimpleShoppinglist(), context),
            button("Lista de Recetas", RecipeManager(), context),
            button("Agenda", ScheduleManager(getCurrentWeek()), context),
            button("Sincronización", SyncManager(), context),
            button("Lista de Mapas", MapList(), context, disabled: true),
          ],
        ),
      ),
    );
  }
}
