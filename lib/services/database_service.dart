import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pocketflow.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS income');
        await db.execute('DROP TABLE IF EXISTS transactions');
        await _createDB(db, newVersion);
      },
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        amount REAL NOT NULL,
        mainCategory TEXT,
        subCategory TEXT,
        date TEXT NOT NULL,
        note TEXT
      )
    ''');
  }

  Future<void> insertTransaction({
    required String type,
    required double amount,
    String? mainCategory,
    String? subCategory,
    String? note,
  }) async {
    final db = await instance.database;

    await db.insert(
      'transactions',
      {
        'type': type,
        'amount': amount,
        'mainCategory': mainCategory,
        'subCategory': subCategory,
        'date': DateTime.now().toIso8601String(),
        'note': note,
      },
    );
  }

  Future<double> getTotalIncome() async {
    final db = await instance.database;

    final result = await db.rawQuery(
      "SELECT SUM(amount) as total FROM transactions WHERE type = 'income'",
    );

    final value = result.first['total'];
    if (value == null) return 0.0;

    return (value as num).toDouble();
  }
}
