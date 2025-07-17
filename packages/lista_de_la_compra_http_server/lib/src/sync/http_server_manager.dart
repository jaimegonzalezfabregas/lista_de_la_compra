import 'dart:io';

import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';

import '../db_providers/http_server_provider.dart';
import '../db_providers/http_server_state_provider.dart';
import 'open_connection_manager.dart';

class HttpServerManager {
  HttpServer? _server;
  final HttpServerProvider httpServerProvider;
  final OpenConnectionManager openConnectionManager;

  // TODO: MOVE NDS FOR AVAHI REGISTRATION

  HttpServerManager(this.httpServerProvider, this.openConnectionManager);

  Future<void> startServer(HttpServerStateProvider serverStateProvider, String localNick) async {
    if (_server != null) {
      return;
    }
    var handler = webSocketHandler((webSocket, x) async {
      openConnectionManager.socketManage(webSocket, null, "Client HTTP");
    });

    serverStateProvider.setServerStatus(ServerStatus.turningOn);

    try {
      _server = await shelf_io.serve(handler, InternetAddress.anyIPv4, 4545);

      print("the server is now running on ${InternetAddress.anyIPv4}:4545");

      serverStateProvider.setServerStatus(ServerStatus.running);
    } catch (e) {
      _server = null;
      serverStateProvider.setServerStatus(ServerStatus.error, error: "Error al iniciar el servidor: $e");
    }

  }

  Future<void> stopServer(HttpServerStateProvider serverStateProvider) async {
    serverStateProvider.setServerStatus(ServerStatus.turningOff);

    await _server?.close();
    _server = null;
    serverStateProvider.setServerStatus(ServerStatus.stopped);
  }

  bool isServerRunning() {
    return _server != null;
  }
}
