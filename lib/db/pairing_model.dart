import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class HttpServerPairings extends Table {
  TextColumn get id => text().clientDefault(() => Uuid().v7())();
  TextColumn get nick => text()();
  TextColumn get host => text()();
  IntColumn get port => integer().clientDefault(() => 4545)();
  TextColumn get lastSync => text()();
  TextColumn get token => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}


class HttpClientPairings extends Table {
  TextColumn get id => text().clientDefault(() => Uuid().v7())();
  TextColumn get nick => text()();
  TextColumn get lastSync => text()();
  BoolColumn get accepted => boolean().withDefault(const Constant(false))();
  TextColumn get token => text()();


  @override
  Set<Column<Object>> get primaryKey => {id};
}
