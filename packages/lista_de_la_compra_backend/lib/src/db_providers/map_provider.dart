import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../lista_de_la_compra_backend.dart';

class RamMapTileProvider extends MapTileProvider with VoidEventSourceMixin {}

abstract class MapTileProvider implements VoidEventSource {
  Future<void> syncAddMap(Map<String, dynamic> serialized) async {
    final database = AppDatabaseSingleton.instance;

    await database
        .into(database.mapTiles)
        .insert(
          MapTilesCompanion(
            id: Value(serialized["id"]),
            marketId: Value(serialized["marketId"]),
            updatedAt: Value(serialized["updatedAt"]),
            deletedAt: Value(serialized["deletedAt"]),
            posX: Value(serialized["posX"]),
            posY: Value(serialized["posY"]),
            floor: Value(serialized["floor"]),
            start: Value(serialized["start"]),
            end: Value(serialized["end"]),
          ),
        );

    notifyListeners();
  }

  Future<void> syncSetDeletedMapTile(String id, int? deletedAt) async {
    final database = AppDatabaseSingleton.instance;

    await (database.update(database.mapTiles)..where((tbl) => tbl.id.equals(id))).write(MapTilesCompanion(deletedAt: Value(deletedAt)));
    notifyListeners();
  }

  Future<void> syncOverideMapTile(String id, Map<String, dynamic> serialized) async {
    final database = AppDatabaseSingleton.instance;

    await (database.update(database.mapTiles)..where((tbl) => tbl.id.equals(id))).write(
      MapTilesCompanion(
        id: Value(serialized["id"]),
        marketId: Value(serialized["marketId"]),
        updatedAt: Value(serialized["updatedAt"]),
        deletedAt: Value(serialized["deletedAt"]),
        posX: Value(serialized["posX"]),
        posY: Value(serialized["posY"]),
        floor: Value(serialized["floor"]),
        start: Value(serialized["start"]),
        end: Value(serialized["end"]),
      ),
    );

    notifyListeners();
  }

  Future<Set<int>> getFloorsOfMarket(String marketId) async {
    final database = AppDatabaseSingleton.instance;
    final q = database.select(database.mapTiles);

    q.where((mapTiles) => mapTiles.deletedAt.isNull());
    q.where((mapTiles) => mapTiles.marketId.equals(marketId));

    List<MapTile> allTiles = await q.get();

    return allTiles.map((MapTile e) => e.floor).toSet();
  }

  Future<List<MapTile>> getMapOfMarket(String marketId, int? floor) async {
    final database = AppDatabaseSingleton.instance;
    final q = database.select(database.mapTiles);

    q.where((mapTiles) => mapTiles.deletedAt.isNull());
    if (floor != null) {
      q.where((mapTiles) => mapTiles.floor.equals(floor));
    }
    q.where((mapTiles) => mapTiles.marketId.equals(marketId));

    return q.get();
  }

  Future<List<MapTile>> getSyncMapTileList(String enviromentId) async {
    final database = AppDatabaseSingleton.instance;

    final joined = database.select(database.mapTiles).join([
      innerJoin(database.superMarkets, database.superMarkets.id.equalsExp(database.mapTiles.marketId)),
    ]);

    joined.where(database.superMarkets.enviromentId.equals(enviromentId));
    joined.orderBy([OrderingTerm(expression: database.mapTiles.updatedAt, mode: OrderingMode.desc)]);

    final rows = await joined.get();
    return rows.map((r) => r.readTable(database.mapTiles)).toList();
  }

  Future<String> addTile(String name, String marketId, int posX, int posY, int floor, bool start, bool end) async {
    final database = AppDatabaseSingleton.instance;
    final String id = Uuid().v7();

    await database
        .into(database.mapTiles)
        .insert(
          MapTilesCompanion(
            id: Value(id),
            marketId: Value(marketId),
            updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
            posX: Value(posX),
            posY: Value(posY),
            floor: Value(floor),
            start: Value(start),
            end: Value(end),
          ),
        );

    notifyListeners();
    return id;
  }

  Future<void> deleteById(String supermarketId) async {
    final database = AppDatabaseSingleton.instance;

    var q = database.update(database.mapTiles);

    q.where((tbl) => tbl.id.equals(supermarketId));

    q.write(MapTilesCompanion(deletedAt: Value(DateTime.now().millisecondsSinceEpoch)));

    notifyListeners();
  }

  Future<void> deleteFloorTiles(String marketId, int floor) async {
    final database = AppDatabaseSingleton.instance;
    final now = DateTime.now().millisecondsSinceEpoch;
    await (database.update(
      database.mapTiles,
    )..where((t) => t.marketId.equals(marketId) & t.floor.equals(floor) & t.deletedAt.isNull())).write(MapTilesCompanion(deletedAt: Value(now)));
    notifyListeners();
  }

  Future<void> updateTileType(String id, {required bool start, required bool end}) async {
    final database = AppDatabaseSingleton.instance;

    await (database.update(database.mapTiles)..where((t) => t.id.equals(id))).write(
      MapTilesCompanion(start: Value(start), end: Value(end), updatedAt: Value(DateTime.now().millisecondsSinceEpoch)),
    );

    notifyListeners();
  }

  Future<MapTile?> getTileById(String id) async {
    final database = AppDatabaseSingleton.instance;

    return await (
      database.select(database.mapTiles)
        ..where((table) => table.id.equals(id))
        ..where((table) => table.deletedAt.isNull())
    ).getSingleOrNull();
  }

  Future<(MapTile, Aisle?)?> getTileByIdJoinedAisle(String tileId) async {
    final database = AppDatabaseSingleton.instance;

    var join = database.select(database.mapTiles).join([leftOuterJoin(database.aisles, database.aisles.mapTileId.equalsExp(database.mapTiles.id))]);

    join.where(database.mapTiles.id.equals(tileId));
    join.where(database.mapTiles.deletedAt.isNull());

    final results = await join.getSingleOrNull();

    if (results == null) {
      return null;
    }

    return (results.readTable(database.mapTiles), results.readTableOrNull(database.aisles));
  }
}
