import 'package:path/path.dart';
import 'package:schedule_kpi/Models/teachers.dart';
import 'package:schedule_kpi/save_data/table.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';

class DBTeachers with Table {
  DBTeachers._();
  String table = 'Teachers';
  static final DBTeachers db = DBTeachers._();

  static Database _database;
  @override
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await db.initDB();
    return _database;
  }

  @override
  delete() async {
    final db = await database;
    db.delete(table);
  }

  @override
  initDB() async {
    final documentsDirectory = await getDatabasesPath();
    String path = join(documentsDirectory, "teachers_table.db");
    return await openDatabase(path,
        version: 1, onOpen: (db) {}, onCreate: onCreate);
  }

  @override
  onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $table ("
        "teacher_id TEXT PRIMARY KEY,"
        "teacher_name TEXT,"
        "teacher_full_name TEXT,"
        "teacher_short_name TEXT,"
        "teacher_url TEXT,"
        "teacher_rating TEXT"
        ")");
  }

  @override
  Future<List<Teachers>> select() async {
    final db = await database;
    var res = await db.query(table);
    List<Teachers> list = res.isNotEmpty
        ? res.map<Teachers>((json) => Teachers.fromJson(json)).toList()
        : [];
    return list;
  }

  insert(Teachers teachers) async {
    final db = await database;
    var res = db.insert(table, teachers.toJson());
    return res;
  }
}
