import 'dart:convert';
import 'dart:io';

import 'package:jhopping_list/sync/pairing_provider.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:uuid/uuid.dart';

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
        var json = jsonDecode(body);
        String nick = json["nick"];

        String token = Uuid().v7();

        await pairingProvider.addHttpClientEntry(nick, token);
        return Response.ok(jsonEncode({"token": token}), headers: {"Content-Type": "application/json"});

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
      pairingProvider.setServerStatus(
        ServerStatus.error,
        error: "Introduzca una clave de sala de más de 10 caracteres (clave de sala actual: $roomKey)",
      );
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
