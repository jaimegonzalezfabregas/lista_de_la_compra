import 'dart:convert';
import 'dart:math' as math;

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:jhopping_list/providers/pairing_provider.dart';
import 'package:jhopping_list/providers/product_provider.dart';
import 'package:jhopping_list/providers/recipe_provider.dart';
import 'package:jhopping_list/providers/schedule_provider.dart';
import 'package:jhopping_list/providers/shared_preferences_provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class OpenConnection {
  final String terminalId;
  final String nick;
  final Function cascadeTriggerSync;

  DateTime lastContact = DateTime.now();

  OpenConnection(this.terminalId, this.nick, this.cascadeTriggerSync);

  void triggerSync() {
    print("triggering sync with $nick");
    cascadeTriggerSync();
  }

  void updateLastContact() {
    lastContact = DateTime.now();
  }
}

class OpenConnectionProvider extends ChangeNotifier {
  final List<OpenConnection> _openConnections = [];

  List<OpenConnection> get openConnections => _openConnections;

  void addOpenConnection(String terminalId, String nick, Function triggerSync) {
    _openConnections.add(OpenConnection(terminalId, nick, triggerSync));
    notifyListeners();
  }

  void refreshOpenConnection(String terminalId) {
    final connection = _openConnections.firstWhere((connection) => connection.terminalId == terminalId);
    connection.updateLastContact();
    notifyListeners();
  }

  void removeOpenConnection(String terminalId) {
    _openConnections.removeWhere((connection) => connection.terminalId == terminalId);
    notifyListeners();
  }

  bool isOpenConnection(String terminalId) {
    return _openConnections.any((connection) => connection.terminalId == terminalId);
  }
}
