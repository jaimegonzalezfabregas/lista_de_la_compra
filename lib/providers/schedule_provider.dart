import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:jhopping_list/db/database.dart';
import 'package:jhopping_list/schedule/utils.dart';

class ScheduleProvider extends ChangeNotifier {
  // Adds a new schedule entry.
  Future<void> addEntry(int week, int day, String recipeId) async {
    final database = AppDatabaseSingleton.instance;

    database.into(database.scheduleEntries).insert(ScheduleEntriesCompanion(week: Value(week), day: Value(day), recipeId: Value(recipeId))); // TODO: crash

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

    query.orderBy([
      (row) => OrderingTerm(expression: row.week, mode: OrderingMode.asc),
      (row) => OrderingTerm(expression: row.day, mode: OrderingMode.asc),
    ]);

    return await query.get();
  }

  Future<List<RecipeProduct>> futureRecipesWithProduct(String productId) async {
    final database = AppDatabaseSingleton.instance;

    var query = (database.select(database.recipeProducts)..where(
      (table) => table.productId.equals(productId),
    )).join([innerJoin(database.scheduleEntries, database.scheduleEntries.recipeId.equalsExp(database.recipeProducts.recipeId))]);

    query.where(
      (database.scheduleEntries.week.equals(getCurrentWeek()) & database.scheduleEntries.day.isBiggerOrEqualValue(DateTime.now().weekday - 1)) |
          database.scheduleEntries.week.isBiggerThanValue(getCurrentWeek()),
    );

    return (await query.get()).map((row) => row.readTable(database.recipeProducts)).toList();
  }

  Future<List<ScheduleEntry>> getEntries(int week, int day) async {
    final database = AppDatabaseSingleton.instance;

    return await (database.select(database.scheduleEntries)
          ..where((table) => table.week.equals(week))
          ..where((table) => table.day.equals(day)))
        .get();
  }

  // Removes an entry from the schedule by its id.
  Future<void> removeEntryById(String entryId) async {
    final database = AppDatabaseSingleton.instance;

    await (database.delete(database.scheduleEntries)..where((table) => table.id.equals(entryId))).go();

    notifyListeners();
  }

  Future<void> removeEntry(int week, int day, String recipeId) async {
    final database = AppDatabaseSingleton.instance;

    await (database.delete(database.scheduleEntries)
          ..where((table) => table.week.equals(week))
          ..where((table) => table.day.equals(day))
          ..where((table) => table.recipeId.equals(recipeId)))
        .go();

    notifyListeners();
  }
}
