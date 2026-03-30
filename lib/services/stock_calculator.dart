import '../models/stock_transaction.dart';

class StockSummary {
  double totalQty = 0;
  double avgCost = 0;
  double realizedProfit = 0;
  double unrealizedProfit = 0;
  double currentPrice = 0;
}

class StockCalculator {
  static Map<String, StockSummary> calculate(
    List<StockTransaction> list,
    Map<String, double> prices,
  ) {
    final Map<String, StockSummary> result = {};

    for (var tx in list) {
      result.putIfAbsent(tx.symbol, () => StockSummary());
      final s = result[tx.symbol]!;

      if (tx.type == 'buy') {
        final totalCost = (s.avgCost * s.totalQty) + (tx.price * tx.quantity);
        s.totalQty += tx.quantity;
        s.avgCost = totalCost / s.totalQty;
      } else if (tx.type == 'sell') {
        final profit = (tx.price - s.avgCost) * tx.quantity;
        s.realizedProfit += profit;
        s.totalQty -= tx.quantity;
      }
    }

    // 🔥 คำนวณ unrealized
    result.forEach((symbol, s) {
      final price = prices[symbol] ?? 0;
      s.currentPrice = price;
      s.unrealizedProfit = (price - s.avgCost) * s.totalQty;
    });

    return result;
  }
}
