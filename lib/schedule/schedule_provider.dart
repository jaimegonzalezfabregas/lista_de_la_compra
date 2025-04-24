import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:jhopping_list/db/database.dart';

class ScheduleProvider extends ChangeNotifier {
  // Adds a new schedule entry.
  Future<void> addEntry(int week, int day, int recipeId) async {
    final database = AppDatabaseSingleton.instance;

    database
        .into(database.schedule)
        .insert(
          ScheduleCompanion(
            week: Value(week),
            day: Value(day),
            recipeId: Value(recipeId),
          ),
        );

    notifyListeners();
  }

  Future<List<ScheduleData>> getEntries(int week, int day) async {
    final database = AppDatabaseSingleton.instance;

    return await (database.select(database.schedule)
          ..where((table) => table.week.equals(week))
          ..where((table) => table.day.equals(day)))
        .get();
  }

  Future<void> changeEntryRecipeById(int entryId, int newRecipeId) async {
    final database = AppDatabaseSingleton.instance;

    await (database.update(database.schedule)..where(
      (table) => table.id.equals(entryId),
    )).write(ScheduleCompanion(recipeId: Value(newRecipeId)));

    notifyListeners();
  }

  // Removes an entry from the schedule by its id.
  Future<void> removeEntryById(int entryId) async {
    final database = AppDatabaseSingleton.instance;

    await (database.delete(database.schedule)
      ..where((table) => table.id.equals(entryId))).go();

    notifyListeners();
  }
}
