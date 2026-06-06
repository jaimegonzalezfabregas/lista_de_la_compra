import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';

abstract class TileType {
  String getAsset();
}

class TileFloor extends TileType {
  @override
  String getAsset() {
    return 'floor.png';
  }
}

class TileStart extends TileType {
  @override
  String getAsset() {
    return 'entry.png';
  }
}

class TileEnd extends TileType {
  @override
  String getAsset() {
    return 'exit.png';
  }
}

class TileAisle extends TileType {
  final String aisleId;
  final String aisleName;

  TileAisle(this.aisleId, this.aisleName);
  @override
  String getAsset() {
    return 'isle.png';
  }
}

TileType tileTypeOf(MapTile t, String? aisleId, String? asileName) {
  if (t.start) return TileStart();
  if (t.end) return TileEnd();
  if (aisleId != null) return TileAisle(aisleId, asileName!);
  return TileFloor();
}
