import 'dart:async';

import 'package:jhopping_list/providers/open_conection_provider.dart';
import 'package:jhopping_list/providers/pairing_provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HttpClientManager {
  PairingProvider pairingProvider;
  OpenConnectionProvider openConnectionProvider;

  Future<void> tryConnectingToHttpServer(String host, int port) async {
    var textUrl = "http://$host:$port";

    WebSocketChannel channel = WebSocketChannel.connect(Uri.parse(textUrl));

    openConnectionProvider.socketManage(channel, (terminalId, nick) {
      pairingProvider.addHttpServerToRemoteTerminal(terminalId, host, port, nick);
    });
  }

  HttpClientManager(this.pairingProvider, this.openConnectionProvider) {
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      // Try to connect to past peers

      for (var peer in await pairingProvider.getRemoteTerminals()) {
        if (openConnectionProvider.isOpenConnection(peer.terminalId)) {
          continue;
        }

        if (peer.httpHost != null && peer.httpPort != null) {
          tryConnectingToHttpServer(peer.httpHost!, peer.httpPort!);
        }
      }

      // Try to sync with connected peers

      for (OpenConnection conection in openConnectionProvider.openConnections) {
        conection.triggerSync();
      }
    });
  }
}
