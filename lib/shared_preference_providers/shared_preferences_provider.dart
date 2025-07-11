import 'package:flutter/material.dart';

abstract class SharedPreferencesProvider extends ChangeNotifier {
  Future<String> getTerminalId() ;

  Future<String> getLocalNick();
  Future<void> setLocalNick(String nick);

  Future<void> setSelectedEnviroment(String enviromentId) ;
  Future<void> clearSelectedEnviroment();
  Future<String?> getSelectedEnviroment();
}
