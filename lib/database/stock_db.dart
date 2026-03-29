import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/stock_transaction.dart';

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
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE stock (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  symbol TEXT,
  type TEXT,
  quantity REAL,
  price REAL,
  total REAL,
  commission REAL,
  vat REAL,
  withholdingTax REAL,
  note TEXT,
  date TEXT
)
''');
  }

  Future<void> insert(StockTransaction tx) async {
    final db = await instance.database;
    await db.insert('stock', tx.toMap());
  }

  Future<List<StockTransaction>> getAll() async {
    final db = await instance.database;
    final maps = await db.query('stock', orderBy: 'date DESC');
    return maps.map((map) => StockTransaction.fromMap(map)).toList();
  }
}
