import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';

class CategoryDB {
  static final CategoryDB instance = CategoryDB._init();
  CategoryDB._init();

  Future<int> insertCategory(Map<String, dynamic> data) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('category', data);
  }

  Future<List<Map<String, dynamic>>> getMainCategories() async {
    final db = await DatabaseHelper.instance.database;
    return await db.query('category', where: 'parentId IS NULL');
  }

  Future<List<Map<String, dynamic>>> getSubCategories(int parentId) async {
    final db = await DatabaseHelper.instance.database;
    return await db.query(
      'category',
      where: 'parentId = ?',
      whereArgs: [parentId],
    );
  }
}
