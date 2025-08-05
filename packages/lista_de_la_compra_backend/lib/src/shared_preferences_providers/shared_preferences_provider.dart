
abstract class SharedPreferencesProvider {
  Future<String> getTerminalId() ;

  Future<String> getLocalNick();
  Future<void> setLocalNick(String nick);

  Future<void> setSelectedEnviroment(String enviromentId) ;
  Future<void> clearSelectedEnviroment();
  Future<String?> getSelectedEnviroment();

  void addListener( void Function() listener );
}

