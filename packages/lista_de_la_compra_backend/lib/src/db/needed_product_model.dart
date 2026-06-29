import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'house_model.dart';
import 'product_model.dart';

class NeededProducts extends Table {
  TextColumn get id => text().clientDefault(() => Uuid().v7())();
  TextColumn get houseId => text().references(Houses, #id)();
  TextColumn get productId => text().references(Products, #id)();
  IntColumn get updatedAt => integer().clientDefault(() => DateTime.now().millisecondsSinceEpoch)();
  IntColumn get deletedAt => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
