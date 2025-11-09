import 'package:drift/drift.dart';
import 'environments.dart';
import 'supermarket_model.dart';
import 'package:uuid/uuid.dart';

class Aisles extends Table {
  TextColumn get id => text().clientDefault(() => Uuid().v7())();
  TextColumn get name => text()();
  // market that this aisle belongs to
  TextColumn get marketId => text().references(SuperMarkets, #id)();
  IntColumn get updatedAt => integer().clientDefault(() => DateTime.now().millisecondsSinceEpoch)();
  IntColumn get deletedAt => integer().nullable()();
  TextColumn get enviromentId => text().references(Enviroments, #id)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
