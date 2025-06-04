import 'package:drift/drift.dart';
import 'package:lista_de_la_compra/db/enviroments.dart';
import 'package:uuid/uuid.dart';

class Products extends Table {
  TextColumn get id => text().clientDefault(() => Uuid().v7())();
  TextColumn get name => text().unique()();
  BoolColumn get needed => boolean()();
  IntColumn get updatedAt => integer().clientDefault(() => DateTime.now().millisecondsSinceEpoch)();
  IntColumn get deletedAt => integer().nullable()();
  TextColumn get enviromentId => text().references(Enviroments, #id)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
