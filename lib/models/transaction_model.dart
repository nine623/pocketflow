class TransactionModel {
  final int? id;
  final String type; // income / expense
  final String date;
  final String asset;
  final double amount;
  final double? saving;
  final double? tax;
  final String mainCategory;
  final String subCategory;
  final String? note;
  final String? imagePath;

  TransactionModel({
    this.id,
    required this.type,
    required this.date,
    required this.asset,
    required this.amount,
    this.saving,
    this.tax,
    required this.mainCategory,
    required this.subCategory,
    this.note,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'date': date,
      'asset': asset,
      'amount': amount,
      'saving': saving,
      'tax': tax,
      'mainCategory': mainCategory,
      'subCategory': subCategory,
      'note': note,
      'imagePath': imagePath,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      type: map['type'],
      date: map['date'],
      asset: map['asset'],
      amount: map['amount'],
      saving: map['saving'],
      tax: map['tax'],
      mainCategory: map['mainCategory'],
      subCategory: map['subCategory'],
      note: map['note'],
      imagePath: map['imagePath'],
    );
  }
}
