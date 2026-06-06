import 'package:drift/drift.dart';
import 'package:lista_de_la_compra_backend/src/db/aisle_model.dart';
import 'supermarket_model.dart';
import 'package:uuid/uuid.dart';

class MapTiles extends Table {
  TextColumn get id => text().clientDefault(() => Uuid().v7())();
  // market that this aisle belongs to
  TextColumn get marketId => text().references(SuperMarkets, #id)();
  IntColumn get updatedAt => integer().clientDefault(() => DateTime.now().millisecondsSinceEpoch)();
  IntColumn get deletedAt => integer().nullable()();

  IntColumn get posX => integer()();
  IntColumn get posY => integer()();
  IntColumn get floor => integer()();
  
  BoolColumn get start => boolean()();
  BoolColumn get end => boolean()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
