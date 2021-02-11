import 'package:path/path.dart';
import 'package:schedule_kpi/Models/teacher_schedule_model.dart';
import 'package:schedule_kpi/save_data/table.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';

class DBTeacherSchedule with Table {
  DBTeacherSchedule._();
  static final DBTeacherSchedule db = DBTeacherSchedule._();
  String table = 'TeacherSchedule';

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  @override
  delete() async {
    final db = await database;
    db!.delete(table);
  }

  @override
  initDB() async {
    final documentDirectory = await getDatabasesPath();
    String path = join(documentDirectory!, 'teacher_schedule_table.db');
    return await openDatabase(path,
        version: 1, onOpen: (db) {}, onCreate: onCreate);
  }

  @override
  onCreate(Database db, int version) {
    db.execute("CREATE TABLE $table ("
        "lesson_id TEXT PRIMARY KEY,"
        "day_name TEXT,"
        "lesson_full_name TEXT,"
        "lesson_number TEXT,"
        "lesson_room TEXT,"
        "lesson_type TEXT,"
        "lesson_week TEXT,"
        "teacher_id TEXT,"
        "time_start TEXT,"
        "time_end TEXT,"
        "groups TEXT"
        ")");
  }

  @override
  Future<List<TeacherSchedules>> select() async {
    final db = await database;
    final res = await db!.query(table);
    List<TeacherSchedules> list = res.isNotEmpty
        ? res.map((json) => TeacherSchedules.fromJson(json)).toList()
        : [];
    return list;
  }

  insert(TeacherSchedules teacherSchedules) async {
    final db = await database;
    var res = db!.insert(table, teacherSchedules.toJson());
    return res;
  }

  update(TeacherSchedules teachersSchedules) async {
    final db = await database;
    var res = await db!.update(table, teachersSchedules.toJson(),
        where: "lesson_id = ?", whereArgs: [teachersSchedules.lessonId]);
    return res;
  }
}
