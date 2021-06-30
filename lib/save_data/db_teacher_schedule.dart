import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';

import '../Models/teacher_schedule_model.dart';
import 'table.dart';

class DBTeacherSchedule with Table {
  DBTeacherSchedule._();
  static final DBTeacherSchedule db = DBTeacherSchedule._();

  String table = 'TeacherSchedule';

  static Database? _database;
  @override
  Future<Database?> get database async {
    if (_database != null) return _database;
    return initDB();
  }

  @override
  Future<void> delete() async {
    final db = await database;
    await db!.delete(table);
  }

  @override
  Future<Database> initDB() async {
    final documentDirectory = await getDatabasesPath();
    final path = join(documentDirectory, 'teacher_schedule_table.db');
    return openDatabase(path, version: 1, onOpen: (db) {}, onCreate: onCreate);
  }

  @override
  Future<void> onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        lesson_id TEXT PRIMARY KEY,
        day_name TEXT,
        lesson_full_name TEXT,
        lesson_number TEXT,
        lesson_room TEXT,
        lesson_type TEXT,
        lesson_week TEXT,
        teacher_id TEXT,
        time_start TEXT,
        time_end TEXT,
        groups TEXT
        ) ''');
  }

  @override
  Future<List<TeacherSchedules>> select() async {
    final db = await database;
    final res = await db!.query(table);
    final list = res.isNotEmpty
        ? res.map((json) => TeacherSchedules.fromJson(json)).toList()
        : <TeacherSchedules>[];
    return list;
  }

  Future<void> insert(TeacherSchedules teacherSchedules) async {
    final db = await database;
    await db!.insert(table, teacherSchedules.toJson());
  }

  Future<void> update(TeacherSchedules teachersSchedules) async {
    final db = await database;
    await db!.update(table, teachersSchedules.toJson(),
        where: 'lesson_id = ?', whereArgs: [teachersSchedules.lessonId]);
  }
}
