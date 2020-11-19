import 'package:sqflite/sqflite.dart';

abstract class Table {
  String table;
  static Database _database;
  Future<Database> get database;
  initDB();
  onCreate(Database db, int version);
  delete();
  Future<List> select();
}
