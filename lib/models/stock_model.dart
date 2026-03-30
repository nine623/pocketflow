class StockModel {
  final int? id;
  final String symbol; // เช่น AAPL, TSLA
  final double buyPrice;
  final double currentPrice;
  final int quantity;

  StockModel({
    this.id,
    required this.symbol,
    required this.buyPrice,
    required this.currentPrice,
    required this.quantity,
  });

  double get totalCost => buyPrice * quantity;
  double get totalValue => currentPrice * quantity;
  double get profit => totalValue - totalCost;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'symbol': symbol,
      'buyPrice': buyPrice,
      'currentPrice': currentPrice,
      'quantity': quantity,
    };
  }

  factory StockModel.fromMap(Map<String, dynamic> map) {
    return StockModel(
      id: map['id'],
      symbol: map['symbol'],
      buyPrice: map['buyPrice'],
      currentPrice: map['currentPrice'],
      quantity: map['quantity'],
    );
  }
}
