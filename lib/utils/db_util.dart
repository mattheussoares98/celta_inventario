import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DbUtil {
  static Future<sql.Database> database() async {
    var databasePath = await sql.getDatabasesPath();
    return await sql.openDatabase(
      path.join(databasePath, 'url.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE table url (id TEXT PRIMARY KEY, url TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<void> insert(
    String table,
    Map<String, String> data,
  ) async {
    final db = await DbUtil.database();

    await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, Object?>>> getData(String table) async {
    final db = await DbUtil.database();
    return db.query(table);
  }
}
