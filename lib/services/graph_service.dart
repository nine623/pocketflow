import '../services/database_helper.dart';

class GraphService {
  Future<double> getTotalIncome() async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.rawQuery(
        "SELECT SUM(amount) as total FROM transactions WHERE type='income'");

    return (result.first['total'] ?? 0) as double;
  }

  Future<double> getTotalExpense() async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.rawQuery(
        "SELECT SUM(amount) as total FROM transactions WHERE type='expense'");

    return (result.first['total'] ?? 0) as double;
  }
}
