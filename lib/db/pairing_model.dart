import 'package:drift/drift.dart';

class RemoteTerminals extends Table {
  TextColumn get id => text()();
  TextColumn get nick => text()();
  TextColumn get http_host => text().nullable()();
  TextColumn get http_port => text().nullable()();
  TextColumn get http_cookie => text()();
  TextColumn get lastSync => text().nullable()();
  BoolColumn get accepted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
