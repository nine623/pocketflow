import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction_model.dart';

class TransactionDB {
  static final TransactionDB instance = TransactionDB._init();
  static Database? _database;

  TransactionDB._init();

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
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE transactions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      amount REAL,
      type TEXT,
      category TEXT,
      date TEXT
    )
    ''');
  }

  Future insert(TransactionModel tx) async {
    final db = await instance.database;
    await db.insert('transactions', tx.toMap());
  }

  Future<List<TransactionModel>> getMonthly() async {
    final db = await instance.database;

    final now = DateTime.now();
    final start = "${now.year}-${now.month.toString().padLeft(2, '0')}-01";

    final result = await db.query(
      'transactions',
      where: 'date >= ?',
      whereArgs: [start],
    );

    return result.map((e) => TransactionModel.fromMap(e)).toList();
  }
}
