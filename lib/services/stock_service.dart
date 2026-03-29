import '../models/stock_transaction.dart';

class StockSummary {
  double totalBuy = 0;
  double totalSell = 0;
  double totalDividend = 0;
  double totalShares = 0;
  double avgCost = 0;
  double realizedProfit = 0;

  double get netProfit => realizedProfit + totalDividend;
}

class StockService {
  static StockSummary calculate(List<StockTransaction> list) {
    final summary = StockSummary();

    for (var tx in list) {
      if (tx.type == 'buy') {
        summary.totalBuy += tx.total;
        summary.totalShares += tx.quantity;
      }

      if (tx.type == 'sell') {
        summary.totalSell += tx.total;

        if (summary.totalShares > 0) {
          final avgCost = summary.totalBuy / summary.totalShares;
          final cost = avgCost * tx.quantity;

          final profit = tx.total - cost;

          summary.realizedProfit += profit;

          summary.totalShares -= tx.quantity;
          summary.totalBuy -= cost;
        }
      }

      if (tx.type == 'dividend') {
        summary.totalDividend += tx.total;
      }
    }

    if (summary.totalShares > 0) {
      summary.avgCost = summary.totalBuy / summary.totalShares;
    }

    return summary;
  }
}
