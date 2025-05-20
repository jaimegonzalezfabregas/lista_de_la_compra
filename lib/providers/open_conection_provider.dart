import 'package:flutter/material.dart';
import 'package:jhopping_list/sync/open_connection_manager.dart';

class OpenConnectionProvider extends ChangeNotifier {
  final List<OpenConnection> _openConnections = [];

  List<OpenConnection> get openConnections => _openConnections;

  void addOpenConnection(String terminalId, String nick, Function triggerSyncPull, Function triggerSyncPush, Function triggerHandshakePush) {
    _openConnections.add(OpenConnection(terminalId, nick, triggerSyncPull, triggerSyncPush, triggerHandshakePush));
    notifyListeners();
  }

  void refreshOpenConnection(String terminalId) {
    final connection = _openConnections.firstWhere((connection) => connection.terminalId == terminalId);
    connection.updateLastContact();
    notifyListeners();
  }

  void setNickOf(String terminalId, String nick) {
    final connection = _openConnections.firstWhere((connection) => connection.terminalId == terminalId);
    connection.setNick(nick);
    notifyListeners();
  }

  void removeOpenConnection(String terminalId) {
    _openConnections.removeWhere((connection) => connection.terminalId == terminalId);
    notifyListeners();
  }

  bool isConnected(String terminalId) {
    return _openConnections.any((connection) => connection.terminalId == terminalId);
  }
}
