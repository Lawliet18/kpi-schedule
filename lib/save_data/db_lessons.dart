import 'package:schedule_kpi/Models/lessons.dart';
import 'package:schedule_kpi/save_data/table.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBLessons implements Table {
  DBLessons._();
  static final DBLessons db = DBLessons._();
  String table = 'Lessons';

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  @override
  initDB() async {
    final documentsDirectory = await getDatabasesPath();
    String path = join(documentsDirectory!, "lessons_table.db");
    return await openDatabase(path,
        version: 1, onOpen: (db) {}, onCreate: onCreate);
  }

  @override
  onCreate(Database db, int version) async {
    await db.execute("""
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
        )""");
  }

  insert(Lessons newLessons) async {
    final db = await database;
    var res = await db!.insert(table, newLessons.toJson());
    return res;
  }

  @override
  Future<List<Lessons>> select() async {
    final db = await database;
    final res = await db!.query(table);
    List<Lessons> list = res.isNotEmpty
        ? res.map<Lessons>((json) => Lessons.fromJson(json)).toList()
        : [];
    return list;
  }

  @override
  delete() async {
    final db = await database;
    await db!.delete(table);
  }

  update(Lessons lessons) async {
    final db = await database;
    var res = await db!.update(table, lessons.toJson(),
        where: "lesson_id = ?", whereArgs: [lessons.lessonId]);
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

  deleteNotes() async {
    final db = await database;
    await db!.rawUpdate("""
    UPDATE $table
    SET description = ? , image_path = ? , notes_date = ?
    WHERE notes_date IS NOT NULL
    """, [null, null, null]);
  }
}
