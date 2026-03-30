class StockTransaction {
  final int? id;
  final String symbol;
  final String type;
  final double price;
  final int quantity;
  final String date;

  StockTransaction({
    this.id,
    required this.symbol,
    required this.type,
    required this.price,
    required this.quantity,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'symbol': symbol,
      'type': type,
      'price': price,
      'quantity': quantity,
      'date': date,
    };
  }

  factory StockTransaction.fromMap(Map<String, dynamic> map) {
    return StockTransaction(
      id: map['id'],
      symbol: map['symbol'],
      type: map['type'],
      price: map['price'],
      quantity: map['quantity'],
      date: map['date'],
    );
  }
}
