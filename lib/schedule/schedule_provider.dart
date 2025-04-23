import 'package:flutter/material.dart';
import 'package:jhopping_list/db_singleton.dart';

class ScheduleEntry {
  final int id;
  final int week;
  final int day;
  final int recipeId;

  ScheduleEntry({
    required this.id,
    required this.week,
    required this.day,
    required this.recipeId,
  });

  factory ScheduleEntry.fromMap(Map<String, dynamic> map) {
    return ScheduleEntry(
      id: map['id'] as int,
      week: map['week'] as int,
      day: map['day'] as int,
      recipeId: map['recipe_id'] as int,
    );
  }
}

class ScheduleProvider extends ChangeNotifier {
  // Adds a new schedule entry.
  Future<void> addEntry(int week, int day, int recipeId) async {
    final db = await DbStatic.getDb();

    try {
      await db.rawInsert(
        '''
      INSERT INTO Schedule (week, day, recipe_id)
      VALUES (?, ?, ?, ?)
      ''',
        [week, day, recipeId],
      );
    } catch (e) {
      // Handle errors appropriately.
      rethrow;
    } finally {
      await db.close();
    }
  }

  Future<List<ScheduleEntry>> getEntries(int week, int day) async {
    final db = await DbStatic.getDb();

    try {
      final result = await db.rawQuery(
        '''
      SELECT * FROM Schedule
      WHERE week = ? AND day = ?
      ''',
        [week, day],
      );

      return result.map((row) => ScheduleEntry.fromMap(row)).toList();
    } catch (e) {
      // Handle errors appropriately.
      rethrow;
    } finally {
      await db.close();
    }
  }

  Future<void> changeEntryRecipeById(int entryId, int newRecipeId) async {
    final db = await DbStatic.getDb();

    try {
      await db.rawUpdate(
        '''
      UPDATE Schedule
      SET recipe_id = ?
      WHERE id = ?
      ''',
        [newRecipeId, entryId],
      );
    } catch (e) {
      // Handle errors as needed.
      rethrow;
    } finally {
      await db.close();
    }
  }

  // Removes an entry from the schedule by its id.
  Future<void> removeEntryById(int entryId) async {
    final db = await DbStatic.getDb();

    try {
      await db.rawDelete(
        '''
      DELETE FROM Schedule
      WHERE id = ?
      ''',
        [entryId],
      );
    } catch (e) {
      // Handle errors appropriately.
      rethrow;
    } finally {
      await db.close();
    }
  }

  Future cacheInvalidation() async {}
}
