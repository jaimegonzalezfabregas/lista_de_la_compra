import 'package:drift/drift.dart';

QueryExecutor createUnderlyingDatabaseConnection(){
  throw UnsupportedError('No database available on this platform!');
}
