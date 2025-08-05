
abstract class SharedPreferencesProvider {
  Future<String> getTerminalId() ;

  Future<String> getLocalNick();
  Future<void> setLocalNick(String nick);

  Future<void> setSelectedEnvironment(String enviromentId) ;
  Future<void> clearSelectedEnvironment();
  Future<String?> getSelectedEnvironment();

  void addListener( void Function() listener );
}

