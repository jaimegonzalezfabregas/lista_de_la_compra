import 'package:lista_de_la_compra/map_engine/tiles/tile_type.dart';
import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';
import 'package:collection/collection.dart';

Future<Map<String, TileType>> buildTileToTypeMap(List<MapTile> tiles, AisleProvider aisleProvider, String supermarketId) async {
  final aisles = await aisleProvider.getAislesBySupermarket(supermarketId);

  Map<String, TileType> ret = {};

  for (final tile in tiles) {
    Aisle? aisle = aisles.firstWhereOrNull((aisle) => aisle.mapTileId == tile.id);
    ret[tile.id] = tileTypeOf(tile, aisle?.id, aisle?.name);
  }

  return ret;
}
