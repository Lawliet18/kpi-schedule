import 'package:path/path.dart';
import 'package:schedule_kpi/Models/lessons.dart';

import 'package:schedule_kpi/save_data/table.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';

class DBNotes implements Table {
  DBNotes._();
  static final DBNotes db = DBNotes._();
  String table = 'Notes';

  static Database? _database;

  @override
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  @override
  delete() async {
    final db = await database;
    await db!.delete(table);
  }

  @override
  initDB() async {
    final documentsDirectory = await getDatabasesPath();
    String path = join(documentsDirectory!, "notes.db");
    return await openDatabase(path,
        version: 1, onOpen: (db) {}, onCreate: onCreate);
  }

  @override
  onCreate(Database db, int version) {
    db.execute(""" 
      CREATE TABLE $table (
        lesson_id TEXT PRIMARY KEY,
        day_name TEXT,
        lesson_name TEXT,
        lesson_number TEXT,
        lesson_room TEXT,
        lesson_type TEXT,
        teacher_name TEXT,
        lesson_week TEXT,
        time_start TEXT,
        time_end TEXT,
        description TEXT,
        image_path TEXT,
        notes_date TEXT
      )
    """);
  }

  @override
  Future<List<Lessons>> select() async {
    final db = await database;
    final res = await db!.query(table);
    List<Lessons> list =
        res.isNotEmpty ? res.map((c) => Lessons.fromJson(c)).toList() : [];
    return list;
  }

  insert(Lessons lessons, String? description, String? imagePath,
      String? date) async {
    final db = await database;
    lessons.dateNotes = date;
    lessons.description = description;
    lessons.imagePath = imagePath;
    var res = await db!.insert(table, lessons.toJson());
    return res;
  }

  updateNotes(Lessons lessons, String? description, String? imagePath,
      String? date) async {
    final db = await database;
    var res = await db!.rawUpdate("""
    UPDATE $table
    SET description = ? , image_path = ? , notes_date = ?
    WHERE lesson_id = ?
    """, [description, imagePath, date, lessons.lessonId]);
    return res;
  }

  deleteNote(Lessons lessons) async {
    final db = await database;
    db!.delete(table, where: "lesson_id = ${lessons.lessonId}");
  }
}