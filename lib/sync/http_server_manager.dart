import 'dart:io';

import 'package:jhopping_list/providers/http_server_state_provider.dart';
import 'package:jhopping_list/providers/open_conection_provider.dart';
import 'package:jhopping_list/providers/pairing_provider.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';

class HttpServerManager {
  HttpServer? _server;
  final HttpServerStateProvider serverStateProvider;
  final PairingProvider pairingProvider;
  final OpenConnectionProvider openConnectionProvider;

  HttpServerManager(
    this.serverStateProvider,
    this.pairingProvider,
    this.openConnectionProvider,
  );

  Future<void> startServer() async {
    if (_server != null) {
      await stopServer();
    }

    var handler = webSocketHandler((webSocket, x) async {
      openConnectionProvider.socketManage(webSocket, (terminalId, nick) {
        pairingProvider.addHttpClientToRemoteTerminal(terminalId, nick);
      });
    });

    serverStateProvider.setServerStatus(ServerStatus.turningOn);

    try {
      _server = await shelf_io.serve(handler, InternetAddress.anyIPv4, 4545);

      serverStateProvider.setServerStatus(ServerStatus.running);
    } catch (e) {
      serverStateProvider.setServerStatus(ServerStatus.error, error: "Error al iniciar el servidor: $e");
    }
  }

  Future<void> stopServer() async {
    serverStateProvider.setServerStatus(ServerStatus.turningOff);

    await _server?.close();
    _server = null;
    serverStateProvider.setServerStatus(ServerStatus.stopped);
  }

  bool isServerRunning() {
    return _server != null;
  }
}
