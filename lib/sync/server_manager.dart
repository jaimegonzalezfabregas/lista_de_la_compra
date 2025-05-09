import 'dart:convert';
import 'dart:io';

import 'package:jhopping_list/providers/http_server_state_provider.dart';
import 'package:jhopping_list/providers/pairing_provider.dart';
import 'package:jhopping_list/providers/shared_preferences_provider.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:uuid/uuid.dart';

class ServerManager {
  HttpServer? _server;
  final HttpServerStateProvider serverStateProvider;
  final PairingProvider pairingProvider;
  final SharedPreferencesProvider sharedPreferencesProvider;

  ServerManager(this.serverStateProvider, this.sharedPreferencesProvider, this.pairingProvider);

  Future<Response> serverHandler(Request request) async {
    switch (request.requestedUri.path) {
      case "/add_pairing":
        var body = await request.readAsString();
        var json = jsonDecode(body);
        String nick = json["nick"];
        String terminalId = json["terminalId"];

        String token = Uuid().v7();

        await pairingProvider.addHttpClientToRemoteTerminal(terminalId, nick, token);
        return Response.ok(
          jsonEncode({
            "token": token,
            "terminalId": await sharedPreferencesProvider.getTerminalId(),
            "nick": await sharedPreferencesProvider.getLocalNick(),
          }),
          headers: {"Content-Type": "application/json"},
        );

      default:
        return Response.notFound("Not found");
    }
  }

  Future<void> startServer() async {
    if (_server != null) {
      await stopServer();
    }

    var handler = const Pipeline().addMiddleware(logRequests()).addHandler((r) => serverHandler(r));

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
