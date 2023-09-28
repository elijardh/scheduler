import 'dart:developer';
import 'package:scheduler/app/database/student_lecture_model.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE lectures(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        lectureCode TEXT,
        lectureTitle TEXT,
        date INTEGER,
        department TEXT,
        lecturer TEXT,
        level TEXT,
        status TEXT,
        time TEXT,
        theater TEXT,
        long TEXT,
        lat TEXT,
        uuid TEXT
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'student.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item
  static Future<int> createItem(StudentLectureModel lectureModel) async {
    final db = await SQLHelper.db();

    final data = await getItem(lectureModel.uuid!);

    if (data.isEmpty) {
      final id = await db.insert('lectures', lectureModel.toJson(),
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
      return id;
    } else {
      final update = await updateItem(data.first["id"], lectureModel);
      log(update.toString());
      return update;
    }
  }

  // Read all items
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();

    final response = await db.query('lectures', orderBy: "id");
    log("Database: ${response.toString()}");
    return response;
  }

  // Update an item by id
  static Future<List<Map<String, dynamic>>> getFilteredItems(
      String status, String status2) async {
    final db = await SQLHelper.db();
    return db.query(
      'lectures',
      where: "status = ?",
      whereArgs: [status, "AND", status2],
    );
  }

  static Future<List<Map<String, dynamic>>> getItem(String id) async {
    final db = await SQLHelper.db();
    return db.query('lectures', where: "uuid = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
      int id, StudentLectureModel studentLectureModel) async {
    final db = await SQLHelper.db();

    final result = await db.update('lectures', studentLectureModel.toJson(),
        where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(String id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("lectures", where: "uuid = ?", whereArgs: [id]);
    } catch (err) {
      log("Something went wrong when deleting an item: $err");
    }
  }

  // Delete all
  static Future<void> deleteAll() async {
    final db = await SQLHelper.db();

    try {
      await db.execute("delete from items");
    } catch (e) {
      log(e.toString());
    }
  }
}
