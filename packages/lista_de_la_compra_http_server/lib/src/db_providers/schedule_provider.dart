import 'package:drift/drift.dart';
import '/lista_de_la_compra_http_server.dart';

import '../db/database.dart';
import '../utils.dart';



class RamScheduleProvider extends ScheduleProvider with VoidEventSourceMixin {}


abstract class ScheduleProvider  implements VoidEventSource {
  // Adds a new schedule entry.
  Future<void> addEntry(int week, int day, String recipeId) async {
    final database = AppDatabaseSingleton.instance;


    await database
        .into(database.scheduleEntries)
        .insert(
          ScheduleEntriesCompanion(
            week: Value(week),
            day: Value(day),
            recipeId: Value(recipeId),
            updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
          ),
        );


    notifyListeners();
  }

  Future<void> syncAddEntry(Map<String, dynamic> serializedScheduleEntry) async {
    final database = AppDatabaseSingleton.instance;

    await database
        .into(database.scheduleEntries)
        .insert(
          ScheduleEntriesCompanion(
            id: Value(serializedScheduleEntry["id"]),
            week: Value(serializedScheduleEntry["week"]),
            day: Value(serializedScheduleEntry["day"]),
            recipeId: Value(serializedScheduleEntry["recipeId"]),
            updatedAt: Value(serializedScheduleEntry["updatedAt"]),
            deletedAt: Value(serializedScheduleEntry["deletedAt"]),
          ),
        );
    notifyListeners();
  }

  Future<void> syncSetDeleted(String id, int? deletedAt) async {
    final database = AppDatabaseSingleton.instance;

    await (database.update(database.scheduleEntries)
      ..where((table) => table.id.equals(id))).write(ScheduleEntriesCompanion(deletedAt: Value(deletedAt)));
    notifyListeners();
  }

  Future<void> syncOveride(String id, Map<String, dynamic> serializedScheduleEntry) async {
    final database = AppDatabaseSingleton.instance;

    await (database.update(database.scheduleEntries)..where((table) => table.id.equals(id))).write(
      ScheduleEntriesCompanion(
        id: Value(serializedScheduleEntry["id"]),
        week: Value(serializedScheduleEntry["week"]),
        day: Value(serializedScheduleEntry["day"]),
        recipeId: Value(serializedScheduleEntry["recipeId"]),
        updatedAt: Value(serializedScheduleEntry["updatedAt"]),
        deletedAt: Value(serializedScheduleEntry["deletedAt"]),
      ),
    );
    notifyListeners();
  }

  Future<List<ScheduleEntry>> getEntriesForRecipe(String recipeId, bool showPast) async {
    final database = AppDatabaseSingleton.instance;

    final query = database.select(database.scheduleEntries)..where((table) => table.recipeId.equals(recipeId));

    if (!showPast) {
      query.where(
        (table) =>
            (table.week.equals(getCurrentWeek()) & table.day.isBiggerOrEqualValue(DateTime.now().weekday - 1)) |
            table.week.isBiggerThanValue(getCurrentWeek()),
      );
    }

    query.where((table) => table.deletedAt.isNull());

    query.orderBy([
      (row) => OrderingTerm(expression: row.week, mode: OrderingMode.asc),
      (row) => OrderingTerm(expression: row.day, mode: OrderingMode.asc),
    ]);

    return await query.get();
  }

  Future<List<RecipeProduct>> getFutureRecipesWithProduct(String productId) async {
    final database = AppDatabaseSingleton.instance;

    var query = (database.select(database.recipeProducts)..where(
      (table) => table.productId.equals(productId),
    )).join([innerJoin(database.scheduleEntries, database.scheduleEntries.recipeId.equalsExp(database.recipeProducts.recipeId))]);

    query.where(database.scheduleEntries.deletedAt.isNull());
    query.where(database.recipeProducts.deletedAt.isNull());

    query.where(
      (database.scheduleEntries.week.equals(getCurrentWeek()) & database.scheduleEntries.day.isBiggerOrEqualValue(DateTime.now().weekday - 1)) |
          database.scheduleEntries.week.isBiggerThanValue(getCurrentWeek()),
    );

    return (await query.get()).map((row) => row.readTable(database.recipeProducts)).toList();
  }

  Future<List<ScheduleEntry>> getEntries(int week, int day, String enviromentId) async {
    final database = AppDatabaseSingleton.instance;

    var query = database.select(database.scheduleEntries).join([
      innerJoin(database.recipes, database.recipes.id.equalsExp(database.scheduleEntries.recipeId)),
    ]);

    query.where(database.recipes.enviromentId.equals(enviromentId));
    query.where(database.scheduleEntries.week.equals(week));
    query.where(database.scheduleEntries.day.equals(day));
    query.where(database.scheduleEntries.deletedAt.isNull());
    query.where(database.recipes.deletedAt.isNull());

    return await (query.map((row) => row.readTable(database.scheduleEntries))).get();
  }

  Future<List<ScheduleEntry>> getSyncEntryList(String enviromentId) async {
    final database = AppDatabaseSingleton.instance;

    var query = database.select(database.scheduleEntries);
    query.orderBy([(u) => OrderingTerm(expression: u.updatedAt, mode: OrderingMode.desc)]);

    return await query.get();
  }

  Future<void> removeEntryById(String entryId) async {
    final database = AppDatabaseSingleton.instance;

    await (database.update(database.scheduleEntries)
      ..where((table) => table.id.equals(entryId))).write(ScheduleEntriesCompanion(deletedAt: Value(DateTime.now().millisecondsSinceEpoch)));

    notifyListeners();
  }

  Future<void> removeEntry(int week, int day, String recipeId) async {
    final database = AppDatabaseSingleton.instance;

    await (database.update(database.scheduleEntries)
          ..where((table) => table.week.equals(week))
          ..where((table) => table.day.equals(day))
          ..where((table) => table.recipeId.equals(recipeId)))
        .write(ScheduleEntriesCompanion(deletedAt: Value(DateTime.now().millisecondsSinceEpoch)));

    notifyListeners();
  }
}
