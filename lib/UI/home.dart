import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/Actions/actionIndex.dart';
import 'package:lista_de_la_compra/UI/recipies/recipe_manager.dart';
import 'package:lista_de_la_compra/UI/products/simple_shopping_list.dart';
import 'package:lista_de_la_compra/UI/schedule/schedule_view.dart';
import 'package:lista_de_la_compra_http_server/src/utils.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra_http_server/src/sync/open_connection_manager.dart';

class Home extends StatefulWidget {
  final String enviromentId;
  final OpenConnectionManager openConnectionManager;

  const Home(this.enviromentId, this.openConnectionManager, {super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.add(SimpleShoppinglist(widget.enviromentId));
    _pages.add(RecipeView(widget.enviromentId));
    _pages.add(ScheduleView(getCurrentWeek(), widget.enviromentId));
    _pages.add(Actionindex(widget.enviromentId, widget.openConnectionManager));
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
          BottomNavigationBarItem(icon: Icon(Icons.list), label: appLoc.shoppingList, backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: appLoc.recipeList, backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: appLoc.agenda, backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: appLoc.actions, backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,        
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
