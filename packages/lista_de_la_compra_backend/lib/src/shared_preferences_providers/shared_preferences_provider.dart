
abstract class SharedPreferencesProvider {
  Future<String> getTerminalId() ;

  Future<String> getLocalNick();
  Future<void> setLocalNick(String nick);

  Future<void> setSelectedEnvironment(String enviromentId) ;
  Future<void> clearSelectedEnvironment();
  Future<String?> getSelectedEnvironment();

  Future<void> setSelectedSupermarket(String enviromentId, String supermarketId) ;
  Future<void> clearSelectedSupermarket(String enviromentId);
  Future<String?> getSelectedSupermarket(String enviromentId);

  void addListener( void Function() listener );
}

