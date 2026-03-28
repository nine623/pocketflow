import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/transaction_model.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final _amountController = TextEditingController();
  final _taxController = TextEditingController();
  final _savingController = TextEditingController();
  final _noteController = TextEditingController();

  String type = "income";
  String asset = "Cash";
  String mainCategory = "General";
  String subCategory = "Other";
  String date = DateTime.now().toString().substring(0, 10);

  double netIncome = 0;

  double round2(double value) {
    return double.parse(value.toStringAsFixed(2));
  }

  void calculateNetIncome() {
    double amount = double.tryParse(_amountController.text) ?? 0;
    double taxPercent = double.tryParse(_taxController.text) ?? 0;
    double saving = double.tryParse(_savingController.text) ?? 0;

    double taxAmount = amount * (taxPercent / 100);
    double result = amount - taxAmount - saving;

    setState(() {
      netIncome = round2(result);
    });
  }

  Future<void> saveTransaction() async {
    double amount = double.tryParse(_amountController.text) ?? 0;
    double taxPercent = double.tryParse(_taxController.text) ?? 0;
    double saving = double.tryParse(_savingController.text) ?? 0;

    double taxAmount = amount * (taxPercent / 100);
    double finalNet = amount - taxAmount - saving;

    if (type == "expense") {
      taxPercent = 0;
      saving = 0;
      finalNet = amount;
    }

    TransactionModel transaction = TransactionModel(
      type: type,
      asset: asset,
      amount: round2(amount),
      taxPercent: round2(taxPercent),
      savingDeduction: round2(saving),
      netAmount: round2(finalNet),
      mainCategory: mainCategory,
      subCategory: subCategory,
      note: _noteController.text,
      date: date,
    );

    await DatabaseHelper.instance.insertTransaction(transaction);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    bool isIncome = type == "income";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Transaction"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            DropdownButtonFormField(
              value: type,
              dropdownColor: Colors.black,
              style: const TextStyle(color: Colors.white),
              items: const [
                DropdownMenuItem(value: "income", child: Text("Income")),
                DropdownMenuItem(value: "expense", child: Text("Expense")),
              ],
              onChanged: (value) {
                setState(() {
                  type = value!;
                  calculateNetIncome();
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Amount",
                labelStyle: TextStyle(color: Colors.white),
              ),
              onChanged: (_) => calculateNetIncome(),
            ),
            if (isIncome) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _taxController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Tax %",
                  labelStyle: TextStyle(color: Colors.white),
                ),
                onChanged: (_) => calculateNetIncome(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _savingController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Saving Deduction",
                  labelStyle: TextStyle(color: Colors.white),
                ),
                onChanged: (_) => calculateNetIncome(),
              ),
              const SizedBox(height: 16),
              Text(
                "Net Income: ${netIncome.toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.green, fontSize: 18),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: saveTransaction,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
