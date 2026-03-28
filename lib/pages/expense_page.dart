import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../database/database_helper.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  Future<void> saveExpense() async {
    final amount = double.tryParse(amountController.text) ?? 0;

    if (amount == 0) return;

    await DatabaseHelper.instance.insertTransaction({
      "amount": amount,
      "category": "Expense",
      "type": "expense",
      "date": DateTime.now().toString(),
      "note": noteController.text
    });

    amountController.clear();
    noteController.clear();

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
              ],
              decoration: const InputDecoration(
                labelText: "Amount",
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: "Note",
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: saveExpense,
              child: const Text("Save Expense"),
            )
          ],
        ),
      ),
    );
  }
}
