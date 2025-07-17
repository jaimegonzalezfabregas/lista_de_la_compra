import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lista_de_la_compra_http_server/src/db_providers/http_server_provider.dart';
import 'package:lista_de_la_compra_http_server/src/sync/open_conection_provider.dart';
import 'package:lista_de_la_compra_http_server/src/sync/open_connection_manager.dart';
import 'package:lista_de_la_compra_http_server/lista_de_la_compra_http_server.dart';
import 'package:web_socket_channel/web_socket_channel.dart';


class FlutterHttpClientService extends HttpClientService with ChangeNotifier {
  FlutterHttpClientService(super.openConnectionProvider, super.openConnectionManager, super.httpServerProvider);
}

class RamHttpClientService extends HttpClientService with VoidEventSourceMixin {
  RamHttpClientService(super.openConnectionProvider, super.openConnectionManager, super.httpServerProvider);
}


abstract class HttpClientService  implements VoidEventSource{
  final OpenConnectionProvider openConnectionProvider;
  final OpenConnectionManager openConnectionManager;
  final HttpServerProvider httpServerProvider;

  Set<String> runningAttempts = {};

  Future<void> tryConnectingToHttpServer(String httpServerId, String host, int port) async {
    if (runningAttempts.contains(httpServerId)) {
      return;
    }

    runningAttempts.add(httpServerId);
    notifyListeners();

    var textUrl = "ws://$host:$port";
    Completer<void> completer = Completer<void>();
    try {
      WebSocketChannel channel = WebSocketChannel.connect(Uri.parse(textUrl));

      var timeout = false;

      await channel.ready.timeout(
        Duration(seconds: 3),
        onTimeout: () {
          timeout = true;
        },
      );
      if (timeout) {
        throw "socket connection timeout";
      }

      openConnectionManager.socketManage(
        channel,
        httpServerId,
        "Server HTTP",
        afterHandshakeNickCb: (String nick) {
          httpServerProvider.setNick(httpServerId, nick);
          if (!completer.isCompleted) {
            completer.complete();
          }
        },
      );
      await completer.future;
    } catch (e) {
      // print("error: $e");
    }

    runningAttempts.remove(httpServerId);
    notifyListeners();
  }

  Future<void> connectionRound() async {
    List<Future<void>> connectionFutures = [];
    for (var httpServer in await httpServerProvider.getHttpServers()) {
      if (openConnectionProvider.anyOpenConnectionOfSource(httpServer.id)) {
        continue;
      }
      Future<void> connectionAttempt = tryConnectingToHttpServer(httpServer.id, httpServer.httpHost, httpServer.httpPort);
      connectionFutures.add(connectionAttempt);
    }

    await Future.wait(connectionFutures);
  }

  void connectionRoundLoop() async {
    // TODO toggle this cyclic routine
    while (true) {
      await connectionRound();
      await Future.delayed(Duration(seconds: 2));
    }
  }

  HttpClientService(this.openConnectionProvider, this.openConnectionManager, this.httpServerProvider) {
    connectionRoundLoop();
  }
}
