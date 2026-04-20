import '../database/stock_db.dart';

class PortfolioSummary {
  final double totalCost;
  final double currentValue;
  final double profit;
  final double percent;

  PortfolioSummary({
    required this.totalCost,
    required this.currentValue,
    required this.profit,
    required this.percent,
  });
}

class PortfolioService {
  static Future<PortfolioSummary> getSummary() async {
    final db = await StockDB().database;

    final result = await db.rawQuery('''
      SELECT 
        SUM(quantity * buyPrice) as totalCost,
        SUM(quantity * currentPrice) as currentValue
      FROM stocks
    ''');

    final totalCost = (result.first['totalCost'] as num?)?.toDouble() ?? 0;
    final currentValue =
        (result.first['currentValue'] as num?)?.toDouble() ?? 0;

    final profit = currentValue - totalCost;
    final percent = totalCost == 0 ? 0 : (profit / totalCost) * 100;

    return PortfolioSummary(
      totalCost: totalCost,
      currentValue: currentValue,
      profit: profit,
      percent: percent,
    );
  }
}
