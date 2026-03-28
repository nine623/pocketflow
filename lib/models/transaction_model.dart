class TransactionModel {
  final int? id;
  final String type;
  final String mainCategory;
  final String subCategory;
  final double amount;
  final String date;
  final String note;

  TransactionModel({
    this.id,
    required this.type,
    required this.mainCategory,
    required this.subCategory,
    required this.amount,
    required this.date,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "type": type,
      "mainCategory": mainCategory,
      "subCategory": subCategory,
      "amount": amount,
      "date": date,
      "note": note,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map["id"],
      type: map["type"],
      mainCategory: map["mainCategory"],
      subCategory: map["subCategory"],
      amount: map["amount"],
      date: map["date"],
      note: map["note"],
    );
  }
}
