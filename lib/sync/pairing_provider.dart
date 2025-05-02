import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:jhopping_list/db/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

enum ServerStatus { running, stopped, turningOn, turningOff, error }

class ServerManager {
  HttpServer? _server;
  String? _localNick;
  String? _roomKey;
  final PairingProvider pairingProvider;

  ServerManager(this.pairingProvider);

  Future<Response> serverHandler(Request request) async {
    switch (request.requestedUri.path) {
      case "/get_room_key":
        return Response.ok(_roomKey, headers: {"Content-Type": "text/plain"});
      case "/get_nick":
        return Response.ok(_localNick, headers: {"Content-Type": "text/plain"});
      case "/add_pairing":
        var body = await request.readAsString();
        var parts = body.split(",");
        if (parts.length != 3) {
          return Response.badRequest(body: "Invalid request");
        }
        String nick = parts[0];
        String host = parts[1];
        int port = int.parse(parts[2]);
        await pairingProvider.addEntry(nick, host, port);
        return Response.ok("Pairing added");

      default:
        return Response.notFound("Not found");
    }
  }

  Future<void> startServer(String localNick, String roomKey) async {
    if (_server != null) {
      return;
    }

    if (localNick.length < 4) {
      pairingProvider.setServerStatus(ServerStatus.error, error: "Introduzca un nick de más de 4 caracteres (nick actual: $localNick)");
      return;
    }

    if (roomKey.length < 10) {
      pairingProvider.setServerStatus(ServerStatus.error, error: "Introduzca una clave de sala de más de 10 caracteres (clave de sala actual: $roomKey)");
      return;
    }

    _localNick = localNick;
    _roomKey = roomKey;

    var handler = const Pipeline().addMiddleware(logRequests()).addHandler((r) => serverHandler(r));

    pairingProvider.setServerStatus(ServerStatus.turningOn);

    _server = await shelf_io.serve(handler, InternetAddress.anyIPv4, 4545);

    pairingProvider.setServerStatus(ServerStatus.running);
  }

  Future<void> stopServer() async {
    pairingProvider.setServerStatus(ServerStatus.turningOff);

    await _server?.close();
    _server = null;
    pairingProvider.setServerStatus(ServerStatus.stopped);
  }

  bool isServerRunning() {
    return _server != null;
  }
}

class PairingProvider extends ChangeNotifier {
  static ServerManager? _serverManager;
  static ServerStatus status = ServerStatus.stopped;
  static String statusError = "Error desconocido";

  PairingProvider() {
    _serverManager ??= ServerManager(this);
    tryStartServer();
  }

  Future<void> addEntry(String nick, String host, int port) async {
    final database = AppDatabaseSingleton.instance;

    database.into(database.pairing).insert(PairingCompanion(nick: Value(nick), host: Value(host), port: Value(port)));

    notifyListeners();
  }

  Future<String?> getLocalNick() async {
    final prefs = await SharedPreferences.getInstance();
    var ret = prefs.getString('LocalNick');
    print(ret);
    return ret;
  }

  Future<void> setLocalNick(String nick) async {
    var shouldRestartServer = isServerRunning();

    if (shouldRestartServer) {
      await stopServer();
    }

    final prefs = await SharedPreferences.getInstance();
    var success = await prefs.setString('LocalNick', nick);

    print("LocalNick set: $success $nick");

    if (shouldRestartServer) {
      await tryStartServer();
    }

    notifyListeners();
  }

  Future<String?> getRoomKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('RoomKey');
  }

  Future<void> setRoomKey(String nick) async {
    var shouldRestartServer = isServerRunning();

    if (shouldRestartServer) {
      await stopServer();
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('RoomKey', nick);

    if (shouldRestartServer) {
      await tryStartServer();
    }

    notifyListeners();
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

    print("Starting server with $localNick and $roomKey");

    _serverManager!.startServer(localNick, roomKey);

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

  Future<List<PairingData>> getPairings() async {
    final database = AppDatabaseSingleton.instance;

    return await database.select(database.pairing).get();
  }

  Future<void> deletePairingById(String id) async {
    final database = AppDatabaseSingleton.instance;

    await (database.delete(database.pairing)..where((table) => table.id.equals(id))).go();
  }

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
}
