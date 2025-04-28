import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:jhopping_list/db/database.dart';
import 'package:jhopping_list/schedule/utils.dart';

class ScheduleProvider extends ChangeNotifier {
  // Adds a new schedule entry.
  Future<void> addEntry(int week, int day, int recipeId) async {
    final database = AppDatabaseSingleton.instance;

    database.into(database.schedule).insert(ScheduleCompanion(week: Value(week), day: Value(day), recipeId: Value(recipeId)));

    notifyListeners();
  }

  Future<List<ScheduleData>> getEntriesForRecipe(int recipeId, bool showPast) async {
    final database = AppDatabaseSingleton.instance;

    final query = database.select(database.schedule)..where((table) => table.recipeId.equals(recipeId));

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

  Future<List<RecipeProduct>> futureRecipesWithProduct(int productId) async {
    final database = AppDatabaseSingleton.instance;

    var query = (database.select(database.recipeProducts)..where(
      (table) => table.productId.equals(productId),
    )).join([innerJoin(database.schedule, database.schedule.recipeId.equalsExp(database.recipeProducts.recipeId))]);

    query.where(
      (database.schedule.week.equals(getCurrentWeek()) & database.schedule.day.isBiggerOrEqualValue(DateTime.now().weekday - 1)) |
          database.schedule.week.isBiggerThanValue(getCurrentWeek()),
    );

    return (await query.get()).map((row) => row.readTable(database.recipeProducts)).toList();
  }

  Future<List<ScheduleData>> getEntries(int week, int day) async {
    final database = AppDatabaseSingleton.instance;

    return await (database.select(database.schedule)
          ..where((table) => table.week.equals(week))
          ..where((table) => table.day.equals(day)))
        .get();
  }

  // Removes an entry from the schedule by its id.
  Future<void> removeEntryById(int entryId) async {
    final database = AppDatabaseSingleton.instance;

    await (database.delete(database.schedule)..where((table) => table.id.equals(entryId))).go();

    notifyListeners();
  }

  Future<void> removeEntry(int week, int day, int recipeId) async {
    final database = AppDatabaseSingleton.instance;

    await (database.delete(database.schedule)
          ..where((table) => table.week.equals(week))
          ..where((table) => table.day.equals(day))
          ..where((table) => table.recipeId.equals(recipeId)))
        .go();

    notifyListeners();
  }
}
