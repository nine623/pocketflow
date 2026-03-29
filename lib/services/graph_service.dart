import 'database_service.dart';

class GraphService {
  static Future<Map<String, double>> getSummary() async {
    final db = await DatabaseService.instance.database;

    final income = await db.rawQuery(
        "SELECT SUM(amount) as total FROM transactions WHERE type = 'income'");

    final expense = await db.rawQuery(
        "SELECT SUM(amount) as total FROM transactions WHERE type = 'expense'");

    double inc = (income.first['total'] == null)
        ? 0
        : (income.first['total'] as num).toDouble();

    double exp = (expense.first['total'] == null)
        ? 0
        : (expense.first['total'] as num).toDouble();

    return {
      'income': inc,
      'expense': exp,
    };
  }
}
