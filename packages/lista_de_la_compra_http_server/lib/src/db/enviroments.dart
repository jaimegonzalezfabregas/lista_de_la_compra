import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class Enviroments extends Table {
  TextColumn get id => text().clientDefault(() => Uuid().v7())();
  TextColumn get name => text().unique()();
  IntColumn get updatedAt => integer().clientDefault(() => DateTime.now().millisecondsSinceEpoch)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
