import 'package:flutter/cupertino.dart';
import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';

import 'package:nsd/nsd.dart';


class FlutterOpenConnectionProvider extends OpenConnectionProvider with ChangeNotifier {}

class FlutterEnvironmentProvider extends EnvironmentProvider with ChangeNotifier {}

class FlutterHttpServerProvider extends HttpServerProvider with ChangeNotifier{}


class FlutterHttpServerStateProvider extends HttpServerStateProvider with ChangeNotifier{
  FlutterHttpServerStateProvider(super.serverManager, super.sharedPreferencesProvider);

  Registration? avahiRegistration;


  @override
  Future<void> tryStartServer() {
    tryStartMdns();
    return super.tryStartServer();
  }

  void tryStartMdns() async{
    String localNick = await sharedPreferencesProvider.getLocalNick();
    try {
      if (avahiRegistration != null) {
        await unregister(avahiRegistration!);
        avahiRegistration = null;
      }

      avahiRegistration = await register(Service(name: localNick, type: '_jhop._tcp', port: 4545));
    } catch (e) {
      print("no mdns on this platform");
    }

  }

  @override
  Future<void> stopServer() {
    if (avahiRegistration != null) {
      unregister(avahiRegistration!);
      avahiRegistration = null;
    }
    return super.stopServer();
  }
}

class FlutterProductProvider extends ProductProvider with ChangeNotifier{}

class FlutterRecipeProvider extends RecipeProvider with ChangeNotifier{}

class FlutterScheduleProvider extends ScheduleProvider with ChangeNotifier {}

class FlutterSuperMarketProvider extends SuperMarketProvider with ChangeNotifier {}

class FlutterAisleProvider extends AisleProvider with ChangeNotifier {}

class FlutterProductAisleProvider extends ProductAisleProvider with ChangeNotifier {}

