
abstract class SelectedHousesProvider {
  Future<void> setSelectedHouses(String enviromentId, List<String> houseIds);
  Future<List<String>> getSelectedHouses(String enviromentId);

  void addListener(void Function() listener);
}
