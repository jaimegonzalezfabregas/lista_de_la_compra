import 'package:drift/drift.dart';
import 'product_model.dart';
import 'aisle_model.dart';
import 'package:uuid/uuid.dart';

class ProductAisles extends Table {
  TextColumn get id => text().clientDefault(() => Uuid().v7())();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get aisleId => text().references(Aisles, #id)();
  IntColumn get updatedAt => integer().clientDefault(() => DateTime.now().millisecondsSinceEpoch)();
  IntColumn get deletedAt => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
