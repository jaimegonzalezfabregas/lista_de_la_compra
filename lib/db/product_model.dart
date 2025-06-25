import 'package:drift/drift.dart';
import 'package:lista_de_la_compra/db/enviroments.dart';
import 'package:uuid/uuid.dart';

// TODO warn the user if 2 products have the same name

class Products extends Table {
  TextColumn get id => text().clientDefault(() => Uuid().v7())();
  TextColumn get name => text()();
  BoolColumn get needed => boolean()();
  IntColumn get updatedAt => integer().clientDefault(() => DateTime.now().millisecondsSinceEpoch)();
  IntColumn get deletedAt => integer().nullable()();
  TextColumn get enviromentId => text().references(Enviroments, #id)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
