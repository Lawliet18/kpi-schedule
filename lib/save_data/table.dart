import 'package:sqflite/sqflite.dart';

abstract class Table {
  Future<Database?> get database;
  late String table;
  initDB();
  onCreate(Database db, int version);
  delete();
  Future<List> select();
}
