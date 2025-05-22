import 'package:flutter/material.dart';
import 'package:jhopping_list/sync/open_connection_manager.dart';

class OpenConnectionProvider extends ChangeNotifier {
  final Map<String, OpenConnection> _openConnections = {};

  Iterable<OpenConnection> get openConnections => _openConnections.values;

  void addOpenConnection(String terminalId, String nick, Function triggerSyncPull, Function triggerSyncPush, Function triggerHandshakePush) {
    _openConnections[terminalId] = OpenConnection(terminalId, nick, triggerSyncPull, triggerSyncPush, triggerHandshakePush);
    notifyListeners();
  }

  void refreshOpenConnection(String terminalId) {
    final connection = _openConnections[terminalId];
    if (connection != null) {
      connection.updateLastContact();
      notifyListeners();
    }
  }

  void setNickOf(String terminalId, String nick) {
    final connection = _openConnections[terminalId];
    if (connection != null) {
      connection.setNick(nick);
      notifyListeners();
    }
  }

  void removeOpenConnection(String terminalId) {
    final connection = _openConnections[terminalId];
    if (connection != null) {
      _openConnections.remove(terminalId);
      notifyListeners();
    }
  }

  bool isConnected(String terminalId) {
    return _openConnections[terminalId] != null;
  }
}
