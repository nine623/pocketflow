class StockTransaction {
  final int? id;
  final String symbol;
  final double quantity;
  final double price;
  final double total;
  final double commission;
  final double vat;
  final double withholdingTax;
  final String type; // buy sell dividend
  final String note;
  final DateTime date;

  StockTransaction({
    this.id,
    required this.symbol,
    required this.quantity,
    required this.price,
    required this.total,
    required this.commission,
    required this.vat,
    required this.withholdingTax,
    required this.type,
    required this.note,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'symbol': symbol,
      'quantity': quantity,
      'price': price,
      'total': total,
      'commission': commission,
      'vat': vat,
      'withholdingTax': withholdingTax,
      'type': type,
      'note': note,
      'date': date.toIso8601String(),
    };
  }

  factory StockTransaction.fromMap(Map<String, dynamic> map) {
    return StockTransaction(
      id: map['id'],
      symbol: map['symbol'],
      quantity: (map['quantity'] as num).toDouble(),
      price: (map['price'] as num).toDouble(),
      total: (map['total'] as num).toDouble(),
      commission: (map['commission'] as num).toDouble(),
      vat: (map['vat'] as num).toDouble(),
      withholdingTax: (map['withholdingTax'] as num).toDouble(),
      type: map['type'],
      note: map['note'] ?? '',
      date: DateTime.parse(map['date']),
    );
  }
}
