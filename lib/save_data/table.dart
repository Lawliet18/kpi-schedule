import 'package:sqflite/sqflite.dart';

abstract class Table {
  Future<Database?> get database;
  initDB();
  onCreate(Database db, int version);
  delete();
  Future<List> select();
}
