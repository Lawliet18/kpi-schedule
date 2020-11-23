import 'package:schedule_kpi/Models/lessons.dart';
import 'package:schedule_kpi/save_data/table.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBLessons with Table {
  DBLessons._();
  static final DBLessons db = DBLessons._();
  String lessonsTableName = 'Lessons';

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  @override
  initDB() async {
    final documentsDirectory = await getDatabasesPath();
    String path = join(documentsDirectory, "lesson_table.db");
    return await openDatabase(path,
        version: 1, onOpen: (db) {}, onCreate: onCreate);
  }

  @override
  onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $lessonsTableName ("
        "lesson_id TEXT PRIVATE KEY,"
        "day_name TEXT,"
        "lesson_name TEXT,"
        "lesson_number TEXT,"
        "lesson_room TEXT,"
        "lesson_type TEXT,"
        "teacher_name TEXT,"
        "lesson_week TEXT,"
        "time_start TEXT,"
        "time_end TEXT"
        ")");
  }

  insert(Lessons newLessons) async {
    final db = await database;
    var res = await db.insert('$lessonsTableName', newLessons.toJson());
    return res;
  }

  @override
  Future<List<Lessons>> select() async {
    final db = await database;
    var res = await db.query("$lessonsTableName");
    List<Lessons> list = res.isNotEmpty
        ? res.map<Lessons>((json) => Lessons.fromJson(json)).toList()
        : [];
    return list;
  }

  @override
  delete() async {
    final db = await database;
    await db.rawDelete("Delete from $lessonsTableName");
  }
}
