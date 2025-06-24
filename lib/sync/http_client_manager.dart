import 'dart:async';

import 'package:lista_de_la_compra/providers/http_server_provider.dart';
import 'package:lista_de_la_compra/providers/open_conection_provider.dart';
import 'package:lista_de_la_compra/sync/open_connection.dart';
import 'package:lista_de_la_compra/sync/open_connection_manager.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HttpClientManager {
  final OpenConnectionProvider openConnectionProvider;
  final OpenConnectionManager openConnectionManager;
  final HttpServerProvider httpServerProvider;

  Future<void> tryConnectingToHttpServer(String httpServerId, String host, int port) async {
    var textUrl = "ws://$host:$port";
    Completer<void> completer = Completer<void>();
    try {
      WebSocketChannel channel = WebSocketChannel.connect(Uri.parse(textUrl));

      await channel.ready;

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
    } catch (e) {}
  }

  Future<void> connectionRound() async {
    List<Future<void>> connectionFutures = [];
    for (var httpServer in await httpServerProvider.getHttpServers()) {
      if (openConnectionProvider.openConnections.values.any((OpenConnection c) => c.connectionSourceId == httpServer.id)) {
        continue;
      }
      connectionFutures.add(tryConnectingToHttpServer(httpServer.id, httpServer.httpHost, httpServer.httpPort));
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

  HttpClientManager(this.openConnectionProvider, this.openConnectionManager, this.httpServerProvider) {
    connectionRoundLoop();
  }
}
