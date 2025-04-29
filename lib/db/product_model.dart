import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class Products extends Table {
  TextColumn get id => text().clientDefault(() => Uuid().v7())();
  TextColumn get name => text().unique()();
  BoolColumn get needed => boolean()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
