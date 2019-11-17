import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:vcard_manager/vcard_data.dart';

class DBManager {
  static final table = 'vcard';
  DBManager._privateConstructor();
  static DBManager instance = DBManager._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    var pathName = await getDatabasesPath();
    String pn = p.join(pathName, 'vcardmanager_database.db');
    return await openDatabase(
      pn,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE $table(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, "
          "designation TEXT, phone TEXT, email TEXT, address TEXT, image TEXT)",
        );
      },
      version: 1,
    );
  }

  void insert(VCardData data) async {
    final Database db = await database;
    await db.insert(
      table,
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void update(VCardData data) async {
    final Database db = await database;
    await db.update(
      table,
      data.toMap(),
      where: 'id',
      whereArgs: [1],
    );
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  //void close() async {
  //  final Database db = await database;
  //  db.close();
  //}
}
