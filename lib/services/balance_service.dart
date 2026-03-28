import '../database/database_helper.dart';

class BalanceService {
  Future<double> getTotalIncome() async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.rawQuery(
        "SELECT SUM(amount) as total FROM transactions WHERE type='income'");

    final value = result.first['total'];

    if (value == null) return 0;

    return (value as num).toDouble();
  }

  Future<double> getTotalExpense() async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.rawQuery(
        "SELECT SUM(amount) as total FROM transactions WHERE type='expense'");

    final value = result.first['total'];

    if (value == null) return 0;

    return (value as num).toDouble();
  }

  Future<double> getBalance() async {
    final income = await getTotalIncome();
    final expense = await getTotalExpense();

    return income - expense;
  }
}
