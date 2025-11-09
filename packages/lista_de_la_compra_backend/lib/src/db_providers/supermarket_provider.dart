import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../lista_de_la_compra_backend.dart';

class RamSuperMarketProvider extends SuperMarketProvider with VoidEventSourceMixin {}

abstract class SuperMarketProvider implements VoidEventSource {
  Future<void> syncAddSuperMarket(Map<String, dynamic> serialized) async {
    final database = AppDatabaseSingleton.instance;

    await database
        .into(database.superMarkets)
        .insert(
          SuperMarketsCompanion(
            id: Value(serialized["id"]),
            name: Value(serialized["name"]),
            updatedAt: Value(serialized["updatedAt"]),
            deletedAt: Value(serialized["deletedAt"]),
            enviromentId: Value(serialized["enviromentId"]),
          ),
        );

    notifyListeners();
  }

  Future<void> syncSetDeletedSuperMarket(String id, int? deletedAt) async {
    final database = AppDatabaseSingleton.instance;

    await (database.update(database.superMarkets)..where((tbl) => tbl.id.equals(id))).write(SuperMarketsCompanion(deletedAt: Value(deletedAt)));
    notifyListeners();
  }

  Future<void> syncOverideSuperMarket(String id, Map<String, dynamic> serialized) async {
    final database = AppDatabaseSingleton.instance;

    await (database.update(database.superMarkets)..where((tbl) => tbl.id.equals(id))).write(
      SuperMarketsCompanion(
        id: Value(serialized["id"]),
        name: Value(serialized["name"]),
        updatedAt: Value(serialized["updatedAt"]),
        deletedAt: Value(serialized["deletedAt"]),
        enviromentId: Value(serialized["enviromentId"]),
      ),
    );

    notifyListeners();
  }

  Future<List<SuperMarket>> getDisplaySuperMarketList(String enviromentId) async {
    final database = AppDatabaseSingleton.instance;

    return await (database.select(database.superMarkets)
          ..where((t) => t.deletedAt.isNull())
          ..where((t) => t.enviromentId.equals(enviromentId)))
        .get();
  }

  Future<List<SuperMarket>> getSyncSuperMarketList(String enviromentId) async {
    final database = AppDatabaseSingleton.instance;

    var q = database.select(database.superMarkets);
    q.where((t) => t.enviromentId.equals(enviromentId));
    q.orderBy([(u) => OrderingTerm(expression: u.updatedAt, mode: OrderingMode.desc)]);

    return await q.get();
  }

  Future<String> addSuperMarket(String rawName, String enviromentId) async {
    final database = AppDatabaseSingleton.instance;
    final String id = Uuid().v7();

    String name = rawName.trim().capitalize();

    await database
        .into(database.superMarkets)
        .insert(
          SuperMarketsCompanion(
            id: Value(id),
            name: Value(name),
            enviromentId: Value(enviromentId),
            updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
          ),
        );

    notifyListeners();
    return id;
  }

  Future<SuperMarket?> getSuperMarketById(String supermarketId) async {
    final database = AppDatabaseSingleton.instance;

    return await (database.select(database.superMarkets)
          ..where((table) => table.id.equals(supermarketId))
          ..where((table) => table.deletedAt.isNull()))
        .getSingleOrNull();
  }

  Future<void> deleteById(String supermarketId) async {
    final database = AppDatabaseSingleton.instance;

    var q = database.update(database.superMarkets);

    q.where((tbl) => tbl.id.equals(supermarketId));

    q.write(SuperMarketsCompanion(deletedAt: Value(DateTime.now().millisecondsSinceEpoch)));

    notifyListeners();
  }

}
