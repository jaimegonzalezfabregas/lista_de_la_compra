import 'dart:io';

import 'package:lista_de_la_compra/providers/http_server_state_provider.dart';
import 'package:lista_de_la_compra/providers/http_server_provider.dart';
import 'package:lista_de_la_compra/sync/open_connection_manager.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:nsd/nsd.dart';

class HttpServerManager {
  HttpServer? _server;
  final HttpServerProvider httpServerProvider;
  final OpenConnectionManager openConnectionManager;
  Registration? avahiRegistration;

  HttpServerManager(this.httpServerProvider, this.openConnectionManager);

  Future<void> startServer(HttpServerStateProvider serverStateProvider, String localNick) async {
    if (_server != null) {
      return;
    }

    var handler = webSocketHandler((webSocket, x) async {
      openConnectionManager.socketManage(webSocket, null);
    });

    serverStateProvider.setServerStatus(ServerStatus.turningOn);

    try {
      _server = await shelf_io.serve(handler, InternetAddress.anyIPv4, 4545);

      serverStateProvider.setServerStatus(ServerStatus.running);
    } catch (e) {
      _server = null;
      serverStateProvider.setServerStatus(ServerStatus.error, error: "Error al iniciar el servidor: $e");
    }
    if (avahiRegistration != null) {
      await unregister(avahiRegistration!);
      avahiRegistration = null;
    }

    avahiRegistration = await register(Service(name: localNick, type: '_jhop._tcp', port: 4545));
  }

  Future<void> stopServer(HttpServerStateProvider serverStateProvider) async {
    serverStateProvider.setServerStatus(ServerStatus.turningOff);

    if (avahiRegistration != null) {
      await unregister(avahiRegistration!);
      avahiRegistration = null;
    }
    await _server?.close();
    _server = null;
    serverStateProvider.setServerStatus(ServerStatus.stopped);
  }

  bool isServerRunning() {
    return _server != null;
  }
}
