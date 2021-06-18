import 'dart:async';
import 'package:sqlite3/sqlite3.dart';

/*

TABLES: prefixes

*/

final Database db = sqlite3.open('data.db');

FutureOr<void> executeSQL(String sqlString) {
  db.execute(sqlString);
}

FutureOr<void> writeToDatabase(String table, String row, String value) {}

/*
void main () {
  db.select('SELECT * WHERE ')
}

*/