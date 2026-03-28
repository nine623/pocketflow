import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    sqfliteFfiInit();

    var databaseFactory = databaseFactoryFfi;

    final dbPath = await databaseFactory.getDatabasesPath();
    final path = join(dbPath, 'pocketflow.db');

    _database = await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: _createDB,
      ),
    );

    return _database!;
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE categories (
id INTEGER PRIMARY KEY AUTOINCREMENT,
name TEXT,
type TEXT
)
''');

    await db.execute('''
CREATE TABLE transactions (
id INTEGER PRIMARY KEY AUTOINCREMENT,
amount REAL,
type TEXT,
category_id INTEGER,
note TEXT,
date TEXT
)
''');
  }
}
