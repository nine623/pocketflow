import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/stock_transaction.dart';

class StockTransactionDB {
  static final StockTransactionDB instance = StockTransactionDB._init();

  static Database? _database;

  StockTransactionDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await openDatabase(
      join(await getDatabasesPath(), 'stock_tx.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE stock_tx (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          symbol TEXT,
          type TEXT,
          price REAL,
          quantity INTEGER,
          date TEXT
        )
        ''');
      },
    );

    return _database!;
  }

  Future insert(StockTransaction tx) async {
    final db = await instance.database;
    await db.insert('stock_tx', tx.toMap());
  }

  Future<List<StockTransaction>> getAll() async {
    final db = await instance.database;
    final result = await db.query('stock_tx');
    return result.map((e) => StockTransaction.fromMap(e)).toList();
  }
}
