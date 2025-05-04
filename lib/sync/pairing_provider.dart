import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:jhopping_list/db/database.dart';
import 'package:jhopping_list/sync/server_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:uuid/uuid.dart';

enum ServerStatus { running, stopped, turningOn, turningOff, error }

class PairingProvider extends ChangeNotifier {
  static ServerManager? _serverManager;
  static ServerStatus status = ServerStatus.stopped;
  static String statusError = "Error desconocido";

  PairingProvider() {
    _serverManager ??= ServerManager(this);
    tryStartServer();
  }

  Future<void> addHttpServerEntry(String host, int port, String tocken) async {
    final database = AppDatabaseSingleton.instance;

    database.into(database.httpServerPairings).insert(HttpServerPairingsCompanion(host: Value(host), port: Value(port)));

    notifyListeners();
  }

  Future<void> addHttpClientEntry(String nick, String token) async {
    final database = AppDatabaseSingleton.instance;

    database.into(database.httpClientPairings).insert(HttpClientPairingsCompanion(nick: Value(nick), token: Value(token)));

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

  Future<List<HttpServerPairing>> getHttpServerPairings() async {
    final database = AppDatabaseSingleton.instance;

    return await database.select(database.httpServerPairings).get();
  }

  Future<List<HttpClientPairing>> getHttpClientPairings() async {
    final database = AppDatabaseSingleton.instance;

    return await database.select(database.httpClientPairings).get();
  }

  Future<void> deleteHttpServerPairingsById(String id) async {
    final database = AppDatabaseSingleton.instance;

    await (database.delete(database.httpServerPairings)..where((table) => table.id.equals(id))).go();
  }

  Future<void> deleteHttpClientPairingsById(String id) async {
    final database = AppDatabaseSingleton.instance;
    await (database.delete(database.httpClientPairings)..where((table) => table.id.equals(id))).go();
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
