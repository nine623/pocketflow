import '../models/stock_transaction.dart';

class StockCalculator {
  // 🧠 PnL (ใช้ Average Cost)
  static double calculatePnL(List<StockTransaction> list) {
    Map<String, double> avgCost = {};
    Map<String, double> qty = {};
    double pnl = 0;

    for (var tx in list) {
      final s = tx.symbol;

      if (tx.type == 'buy') {
        final totalCost = (avgCost[s] ?? 0) * (qty[s] ?? 0) + tx.total;
        qty[s] = (qty[s] ?? 0) + tx.quantity;
        avgCost[s] = totalCost / qty[s]!;
      }

      if (tx.type == 'sell') {
        final cost = (avgCost[s] ?? 0) * tx.quantity;
        pnl += (tx.total - cost);
        qty[s] = (qty[s] ?? 0) - tx.quantity;
      }

      if (tx.type == 'dividend') {
        pnl += tx.total - tx.withholdingTax;
      }
    }

    return pnl;
  }

  // 📊 filter ตามช่วงเวลา
  static List<StockTransaction> filterByRange(
      List<StockTransaction> list, DateTime from, DateTime to) {
    return list
        .where((e) => e.date.isAfter(from) && e.date.isBefore(to))
        .toList();
  }

  // 📊 sum ตาม type
  static double sumByType(List<StockTransaction> list, String type) {
    return list.where((e) => e.type == type).fold(0, (s, e) => s + e.total);
  }
}
