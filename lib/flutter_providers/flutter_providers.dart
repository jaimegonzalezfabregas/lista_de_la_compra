import 'package:flutter/cupertino.dart';

class FlutterOpenConnectionProvider extends OpenConnectionProvider with ChangeNotifier {}

class FlutterEnviromentProvider extends EnviromentProvider with ChangeNotifier {}

class FlutterHttpServerProvider extends HttpServerProvider with ChangeNotifier{}


class FlutterHttpServerStateProvider extends HttpServerStateProvider with ChangeNotifier{
  FlutterHttpServerStateProvider(super.serverManager, super.sharedPreferencesProvider);
}

class FlutterProductProvider extends ProductProvider with ChangeNotifier{}

class FlutterRecipeProvider extends RecipeProvider with ChangeNotifier{}

class FlutterScheduleProvider extends ScheduleProvider with ChangeNotifier {}


