import 'package:flutter/cupertino.dart';
import 'package:lista_de_la_compra_backend/src/sync/open_conection_provider.dart';
import 'package:lista_de_la_compra_backend/src/db_providers/enviroment_provider.dart';
import 'package:lista_de_la_compra_backend/src/db_providers/http_server_provider.dart';
import 'package:lista_de_la_compra_backend/src/db_providers/http_server_state_provider.dart';
import 'package:lista_de_la_compra_backend/src/db_providers/product_provider.dart';
import 'package:lista_de_la_compra_backend/src/db_providers/recipe_provider.dart';
import 'package:lista_de_la_compra_backend/src/db_providers/schedule_provider.dart';


class FlutterOpenConnectionProvider extends OpenConnectionProvider with ChangeNotifier {}

class FlutterEnviromentProvider extends EnviromentProvider with ChangeNotifier {}

class FlutterHttpServerProvider extends HttpServerProvider with ChangeNotifier{}


class FlutterHttpServerStateProvider extends HttpServerStateProvider with ChangeNotifier{
  FlutterHttpServerStateProvider(super.serverManager, super.sharedPreferencesProvider);
}

class FlutterProductProvider extends ProductProvider with ChangeNotifier{}

class FlutterRecipeProvider extends RecipeProvider with ChangeNotifier{}

class FlutterScheduleProvider extends ScheduleProvider with ChangeNotifier {}


