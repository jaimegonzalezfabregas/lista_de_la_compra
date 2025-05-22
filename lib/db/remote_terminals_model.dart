import 'package:drift/drift.dart';

class RemoteTerminals extends Table {
  TextColumn get terminalId => text()();
  TextColumn get nick => text()();
  TextColumn get httpHost => text().nullable()();
  IntColumn get httpPort => integer().nullable()();
  BoolColumn get isHttpServer => boolean().withDefault(const Constant(false))();
  BoolColumn get isHttpClient => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {terminalId};
}