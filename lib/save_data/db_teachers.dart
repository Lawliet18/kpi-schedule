import 'package:path/path.dart';
import 'package:schedule_kpi/Models/teachers.dart';
import 'package:schedule_kpi/save_data/table.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';

class DBTeachers with Table {
  DBTeachers._();
  final String table = 'Teachers';
  static final DBTeachers db = DBTeachers._();

  static Database? _database;
  @override
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    return db.initDB();
  }

  @override
  Future<void> delete() async {
    final db = await database;
    db!.delete(table);
  }

  @override
  Future<Database> initDB() async {
    final documentsDirectory = await getDatabasesPath();
    final path = join(documentsDirectory!, "teachers_table.db");
    return openDatabase(path, version: 1, onOpen: (db) {}, onCreate: onCreate);
  }

  @override
  Future<void> onCreate(Database db, int version) async {
    await db.execute("""
      CREATE TABLE $table (
        teacher_id TEXT PRIMARY KEY,
        teacher_name TEXT,
        teacher_full_name TEXT,
        teacher_short_name TEXT,
        teacher_url TEXT,
        teacher_rating TEXT
        ) """);
  }

  @override
  Future<List<Teachers>> select() async {
    final db = await database;
    final res = await db!.query(table);
    final list = res.isNotEmpty
        ? res.map<Teachers>((json) => Teachers.fromJson(json)).toList()
        : [] as List<Teachers>;
    return list;
  }

  Future<void> insert(Teachers teachers) async {
    final db = await database;
    await db!.insert(table, teachers.toJson());
  }

  Future<void> update(Teachers teachers) async {
    final db = await database;
    await db!.update(table, teachers.toJson(),
        where: "teacher_id = ?", whereArgs: [teachers.teacherId]);
  }
}
