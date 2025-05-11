import 'package:flutter/material.dart';
import 'package:jhopping_list/providers/open_conection_provider.dart';
import 'package:jhopping_list/providers/pairing_provider.dart';
import 'package:jhopping_list/sync/http_server_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ServerStatus { running, stopped, turningOn, turningOff, error }

class HttpServerStateProvider extends ChangeNotifier {
  HttpServerStateProvider(
    PairingProvider pairingProvider,
    OpenConnectionProvider openConnectionProvider,
  ) {
    _serverManager ??= HttpServerManager(
      this,
      pairingProvider,
      openConnectionProvider,
    );
    tryStartServer();
  }

  static HttpServerManager? _serverManager;
  static ServerStatus status = ServerStatus.stopped;
  static String statusError = "Error desconocido";

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
    return _serverManager!.isServerRunning();
  }

  Future<void> tryStartServer() async {
    final prefs = await SharedPreferences.getInstance();

    String? localNick = prefs.getString('LocalNick');

    if (localNick == null) {
      setServerStatus(ServerStatus.error, error: "Introduzca un nick");
      return;
    }

    String? roomKey = prefs.getString('RoomKey');

    if (roomKey == null) {
      setServerStatus(ServerStatus.error, error: "Introduzca una clave de sala");
      return;
    }

    _serverManager!.startServer();

    notifyListeners();
  }

  Future<void> stopServer() async {
    _serverManager!.stopServer();

    notifyListeners();
  }

  void setServerStatus(ServerStatus newStatus, {String error = ""}) async {
    status = newStatus;
    statusError = error;
    notifyListeners();
  }
}
