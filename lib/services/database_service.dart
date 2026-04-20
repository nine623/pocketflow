import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await databaseFactory.getDatabasesPath();
    final path = join(dbPath, 'pocketflow.db');

    return await openDatabase(
      path,
      version: 2, // 🔥 เปลี่ยน version
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // 🔥 สร้างครั้งแรก
  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE assets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        balance REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT,
        amount REAL,
        category TEXT,
        note TEXT,
        date TEXT,
        assetId INTEGER
      )
    ''');

    // 🔥 สร้าง asset เริ่มต้น
    await db.insert('assets', {'name': 'Cash', 'balance': 0});
    await db.insert('assets', {'name': 'Bank', 'balance': 0});
  }

  // 🔥 upgrade (กันพัง)
  static Future<void> _onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE transactions ADD COLUMN assetId INTEGER');
      await db.execute('''
        CREATE TABLE assets (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          balance REAL
        )
      ''');

      await db.insert('assets', {'name': 'Cash', 'balance': 0});
      await db.insert('assets', {'name': 'Bank', 'balance': 0});
    }
  }

  // ===================== ASSET =====================

  static Future<List<Map<String, dynamic>>> getAssets() async {
    final db = await database;
    return await db.query('assets');
  }

  static Future<void> updateAssetBalance(
      int assetId, double amount, String type) async {
    final db = await database;

    final asset = await db.query(
      'assets',
      where: 'id = ?',
      whereArgs: [assetId],
    );

    double balance = (asset.first['balance'] as num).toDouble();

    if (type == 'income') {
      balance += amount;
    } else {
      balance -= amount;
    }

    await db.update(
      'assets',
      {'balance': balance},
      where: 'id = ?',
      whereArgs: [assetId],
    );
  }

  // ===================== TRANSACTION =====================

  static Future<int> insertTransaction(Map<String, dynamic> data) async {
    final db = await database;

    final id = await db.insert('transactions', data);

    await updateAssetBalance(
      data['assetId'],
      data['amount'],
      data['type'],
    );

    return id;
  }

  static Future<List<Map<String, dynamic>>> getTransactions() async {
    final db = await database;

    return await db.rawQuery('''
      SELECT t.*, a.name as assetName
      FROM transactions t
      LEFT JOIN assets a ON t.assetId = a.id
      ORDER BY date DESC
    ''');
  }
}
