import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/actions/action_home.dart';
import 'package:lista_de_la_compra/UI/recipies/recipe_home.dart';
import 'package:lista_de_la_compra/UI/products/product_home.dart';
import 'package:lista_de_la_compra/UI/schedule/schedule_home.dart';
import 'package:lista_de_la_compra/UI/supermarket/supermarket_home.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';

import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';

class Home extends StatefulWidget {
  final String enviromentId;
  final OpenConnectionManager openConnectionManager;

  const Home(this.enviromentId, this.openConnectionManager, {super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.add(ProductHome(widget.enviromentId));
    _pages.add(RecipeHome(widget.enviromentId));
    _pages.add(ScheduleHome(getCurrentWeek(), widget.enviromentId));
    _pages.add(SupermarketHome(widget.enviromentId));
    _pages.add(ActionHome(widget.enviromentId, widget.openConnectionManager));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLoc = AppLocalizations.of(context)!;
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: appLoc.shoppingList,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: appLoc.recipeList,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: appLoc.agenda,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: appLoc.supermarketList,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: appLoc.actions,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
