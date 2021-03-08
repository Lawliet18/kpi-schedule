import 'package:sqflite/sqflite.dart';

abstract class Table {
  Future<Database?> get database;
  Future<Database> initDB();
  Future<void> onCreate(Database db, int version);
  Future<void> delete();
  Future<List> select();
}
