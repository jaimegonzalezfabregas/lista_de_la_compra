import 'package:flutter/material.dart';
import 'package:jhopping_list/UI/maps/map_list.dart';
import 'package:jhopping_list/UI/recipies/recipe_manager.dart';
import 'package:jhopping_list/UI/products/simple_shopping_list.dart';
import 'package:jhopping_list/UI/schedule/schedule_view.dart';
import 'package:jhopping_list/UI/schedule/utils.dart';
import 'package:jhopping_list/db/database.dart';
import 'package:jhopping_list/providers/http_server_state_provider.dart';
import 'package:jhopping_list/providers/open_conection_provider.dart';
import 'package:jhopping_list/providers/pairing_provider.dart';
import 'package:jhopping_list/providers/product_provider.dart';
import 'package:jhopping_list/providers/recipe_provider.dart';
import 'package:jhopping_list/providers/schedule_provider.dart';
import 'package:jhopping_list/providers/shared_preferences_provider.dart';
import 'package:jhopping_list/sync/http_server_manager.dart';
import 'package:jhopping_list/sync/open_connection_manager.dart';
import 'package:jhopping_list/UI/sync/sync_view.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final Enviroment enviroment;
  const Home(this.enviroment, {super.key});

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
    final RecipeProvider recipeProvider = RecipeProvider();
    final ProductProvider productProvider = ProductProvider();
    final ScheduleProvider scheduleProvider = ScheduleProvider();
    final PairingProvider pairingProvider = PairingProvider();
    final SharedPreferencesProvider sharedPreferencesProvider = SharedPreferencesProvider();
    final OpenConnectionProvider openConnectionProvider = OpenConnectionProvider();

    final OpenConnectionManager openConnectionManager = OpenConnectionManager(
      pairingProvider,
      openConnectionProvider,
      productProvider,
      recipeProvider,
      scheduleProvider,
      sharedPreferencesProvider,
      enviroment,
    );

    final HttpServerManager httpServerManager = HttpServerManager(pairingProvider, openConnectionManager, enviroment);

    final HttpServerStateProvider httpServerStateProvider = HttpServerStateProvider(httpServerManager);

    return Scaffold(
      appBar: AppBar(title: Text("Home (${enviroment.name})"), backgroundColor: Theme.of(context).colorScheme.primaryContainer),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => recipeProvider),
          ChangeNotifierProvider(create: (_) => productProvider),
          ChangeNotifierProvider(create: (_) => scheduleProvider),
          ChangeNotifierProvider(create: (_) => pairingProvider),
          ChangeNotifierProvider(create: (_) => sharedPreferencesProvider),
          ChangeNotifierProvider(create: (_) => httpServerStateProvider),
          ChangeNotifierProvider(create: (_) => openConnectionProvider),
        ],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: Text("Lista de la compra", style: Theme.of(context).textTheme.titleSmall)),
                  IconButton(
                    icon: Icon(Icons.arrow_outward),
                    onPressed: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => SimpleShoppinglist(enviroment.id)))},
                  ),
                ],
              ),

              button("Lista de Recetas", RecipeView(enviroment.id), context),
              button("Agenda", ScheduleView(getCurrentWeek(), enviroment.id), context),
              button("Sincronización", SyncView(openConnectionManager, enviroment.id), context),
              button("Lista de Mapas", MapList(), context, disabled: true),
            ],
          ),
        ),
      ),
    );
  }
}
