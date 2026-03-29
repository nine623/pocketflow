import 'database_service.dart';

class BalanceService {
  static Future<double> getBalance() async {
    final db = await DatabaseService.instance.database;

    final income = await db.rawQuery(
      "SELECT SUM(amount) as total FROM transactions WHERE type = 'income'",
    );

    final expense = await db.rawQuery(
      "SELECT SUM(amount) as total FROM transactions WHERE type = 'expense'",
    );

    final incomeValue = income.first['total'];
    final expenseValue = expense.first['total'];

    double inc = incomeValue == null ? 0.0 : (incomeValue as num).toDouble();
    double exp = expenseValue == null ? 0.0 : (expenseValue as num).toDouble();

    return inc - exp;
  }
}
