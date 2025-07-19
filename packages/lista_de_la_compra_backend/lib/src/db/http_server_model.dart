import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class HttpServer extends Table {
  TextColumn get id => text().clientDefault(() => Uuid().v7())();
  TextColumn get httpHost => text()();
  IntColumn get httpPort => integer()();
  TextColumn get nick => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
