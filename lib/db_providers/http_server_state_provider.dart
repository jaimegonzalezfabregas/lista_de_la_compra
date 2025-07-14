import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/shared_preference_providers/shared_preferences_provider.dart';
import 'package:lista_de_la_compra/sync/http_server_manager.dart';
import 'package:lista_de_la_compra_http_server/lista_de_la_compra_http_server.dart';

enum ServerStatus { running, stopped, turningOn, turningOff, error }


class FlutterHttpServerStateProvider extends HttpServerStateProvider with ChangeNotifier{
  FlutterHttpServerStateProvider(super.serverManager, super.sharedPreferencesProvider);
}
class RamHttpServerStateProvider extends HttpServerStateProvider with VoidEventSourceMixin {
  RamHttpServerStateProvider(super.serverManager, super.sharedPreferencesProvider);
}


abstract class HttpServerStateProvider implements VoidEventSource{
  HttpServerManager serverManager;
  SharedPreferencesProvider sharedPreferencesProvider;


  HttpServerStateProvider(this.serverManager, this.sharedPreferencesProvider);

  ServerStatus status = ServerStatus.stopped;
  String statusError = "Error desconocido";

  ServerStatus getServerStatus() {
    return status;
  }

  String? getServerError() {
    if (status != ServerStatus.error) {
      return null;
    }
    return statusError;
  }

  bool isServerRunning() {
    return serverManager.isServerRunning();
  }

  Future<void> tryStartServer() async {


    serverManager.startServer(this, await sharedPreferencesProvider.getLocalNick());

    notifyListeners();
  }

  Future<void> stopServer() async {
    serverManager.stopServer(this);

    notifyListeners();
  }

  void setServerStatus(ServerStatus newStatus, {String error = ""}) async {
    status = newStatus;
    statusError = error;
    notifyListeners();
  }
}
