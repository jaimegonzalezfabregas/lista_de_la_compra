
abstract class SelectedMarketProvider {

  Future<void> setSelectedSupermarket(String enviromentId, String supermarketId) ;
  Future<void> clearSelectedSupermarket(String enviromentId);
  Future<String?> getSelectedSupermarket(String enviromentId);

  void addListener( void Function() listener );
}

