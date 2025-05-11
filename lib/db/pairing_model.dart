import 'package:drift/drift.dart';

class RemoteTerminals extends Table {
  TextColumn get terminalId => text()();
  TextColumn get nick => text()();
  TextColumn get httpHost => text().nullable()();
  IntColumn get httpPort => integer().nullable()();
  TextColumn get lastSync => text().nullable()();
  BoolColumn get accepted => boolean().withDefault(const Constant(false))();
  BoolColumn get isHttpServer => boolean().withDefault(const Constant(false))();
  BoolColumn get isHttpClient => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {terminalId};
}
