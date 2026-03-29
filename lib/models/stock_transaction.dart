class StockTransaction {
  final int? id;
  final String symbol;
  final String type;
  final double quantity;
  final double price;
  final double total;
  final double commission;
  final double vat;
  final double withholdingTax;
  final String note;
  final DateTime date;

  StockTransaction({
    this.id,
    required this.symbol,
    required this.type,
    required this.quantity,
    required this.price,
    required this.total,
    required this.commission,
    required this.vat,
    required this.withholdingTax,
    required this.note,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'symbol': symbol,
        'type': type,
        'quantity': quantity,
        'price': price,
        'total': total,
        'commission': commission,
        'vat': vat,
        'withholdingTax': withholdingTax,
        'note': note,
        'date': date.toIso8601String(),
      };

  factory StockTransaction.fromMap(Map<String, dynamic> map) {
    return StockTransaction(
      id: map['id'],
      symbol: map['symbol'],
      type: map['type'],
      quantity: map['quantity'],
      price: map['price'],
      total: map['total'],
      commission: map['commission'],
      vat: map['vat'],
      withholdingTax: map['withholdingTax'],
      note: map['note'],
      date: DateTime.parse(map['date']),
    );
  }
}
