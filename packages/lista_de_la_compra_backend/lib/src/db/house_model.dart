import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'environments.dart';

class Houses extends Table {
  TextColumn get id => text().clientDefault(() => Uuid().v7())();
  TextColumn get name => text()();
  TextColumn get enviromentId => text().references(Enviroments, #id)();
  IntColumn get updatedAt => integer().clientDefault(() => DateTime.now().millisecondsSinceEpoch)();
  IntColumn get deletedAt => integer().nullable()();
  IntColumn get color => integer().clientDefault(() => 0xFFF44336)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
