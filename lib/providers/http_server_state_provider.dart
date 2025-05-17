import 'package:flutter/material.dart';
import 'package:jhopping_list/sync/http_server_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ServerStatus { running, stopped, turningOn, turningOff, error }

class HttpServerStateProvider extends ChangeNotifier {
  HttpServerManager serverManager;

  HttpServerStateProvider(this.serverManager);

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

  Future<void> tryStartServer(String enviromentId) async {
    final prefs = await SharedPreferences.getInstance();



    String? localNick = prefs.getString('LocalNick');

    if (localNick == null) {
      setServerStatus(ServerStatus.error, error: "Introduzca un nick");
      return;
    }

    serverManager.startServer(this, enviromentId);

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
