import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

QueryExecutor createUnderlyingDatabaseConnection(){
  return DatabaseConnection.delayed(Future(() async {
    final db = await WasmDatabase.open(
      databaseName: 'todo-app',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );

    if (db.missingFeatures.isNotEmpty) {
      print('Using ${db.chosenImplementation} due to unsupported browser features: ${db.missingFeatures}');
    }

    return db.resolvedExecutor;
  }));
}
