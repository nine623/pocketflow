import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../database/database_helper.dart';
import '../models/transaction_model.dart';
import '../services/category_ai_service.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  String _type = "expense";
  String _mainCategory = "";
  String _subCategory = "";

  @override
  void initState() {
    super.initState();
    _noteController.addListener(_runAI);
  }

  void _runAI() {
    final result = CategoryAIService.detect(_noteController.text);

    if (result != null) {
      setState(() {
        _mainCategory = result["main"]!;
        _subCategory = result["sub"]!;
      });
    }
  }

  void saveTransaction() async {
    final tx = TransactionModel(
      type: _type,
      mainCategory: _mainCategory,
      subCategory: _subCategory,
      amount: double.parse(_amountController.text),
      date: DateTime.now().toString(),
      note: _noteController.text,
    );

    await DatabaseHelper.instance.insertTransaction(tx);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Transaction"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _type,
              items: const [
                DropdownMenuItem(
                  value: "income",
                  child: Text("Income"),
                ),
                DropdownMenuItem(
                  value: "expense",
                  child: Text("Expense"),
                ),
              ],
              onChanged: (v) {
                setState(() {
                  _type = v!;
                });
              },
            ),
            TextField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
              ],
              decoration: const InputDecoration(
                labelText: "Amount",
              ),
            ),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: "Note",
              ),
            ),
            const SizedBox(height: 20),
            Text("Main Category: $_mainCategory"),
            Text("Sub Category: $_subCategory"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveTransaction,
              child: const Text("SAVE"),
            )
          ],
        ),
      ),
    );
  }
}
