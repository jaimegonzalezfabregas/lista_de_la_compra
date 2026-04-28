import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

QueryExecutor createUnderlyingDatabaseConnection() {
  return NativeDatabase.createInBackground(File('./persistence.sqlite'));
}
