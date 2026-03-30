import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/stock_model.dart';

class StockDB {
  static final StockDB instance = StockDB._init();
  static Database? _database;

  StockDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('stock.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final path = join(await getDatabasesPath(), filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE stocks (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          symbol TEXT,
          buyPrice REAL,
          currentPrice REAL,
          quantity INTEGER
        )
        ''');
      },
    );
  }

  Future insert(StockModel stock) async {
    final db = await instance.database;
    await db.insert('stocks', stock.toMap());
  }

  Future<List<StockModel>> getAll() async {
    final db = await instance.database;
    final result = await db.query('stocks');
    return result.map((e) => StockModel.fromMap(e)).toList();
  }
}
