import 'package:flutter/material.dart';
import 'package:jhopping_list/db/database.dart';
import 'package:jhopping_list/sync/open_connection.dart';

class OpenConnectionProvider extends ChangeNotifier {
  final Map<String, OpenConnection> _openConnections = {};

  Map<String, OpenConnection> get openConnections => _openConnections;

  void addOpenConnection(
    String terminalId,
    String nick,
    Function triggerSyncPull,
    Function triggerSyncPush,
    Function triggerHandshakePush,
    Function abortConnection,
    List<Enviroment> enviromentList,
  ) {
    _openConnections[terminalId] = OpenConnection(
      terminalId,
      nick,
      triggerSyncPull,
      triggerSyncPush,
      triggerHandshakePush,
      abortConnection,
      enviromentList,
    );
    notifyListeners();
  }

  void abortConnection(String terminalId) {
    _openConnections[terminalId]?.abortConnection();
  }

  void removeOpenConnection(String terminalId) {
    final connection = _openConnections[terminalId];
    if (connection != null) {
      _openConnections.remove(terminalId);
      notifyListeners();
    }
  }

  void setLatency(String terminalId, num latency) {
    _openConnections[terminalId]?.latency = latency;
    notifyListeners();
  }

  bool isConnected(String terminalId) {
    return _openConnections[terminalId] != null;
  }
}
