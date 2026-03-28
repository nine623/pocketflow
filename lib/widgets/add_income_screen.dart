import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/database_service.dart';

class AddIncomeScreen extends StatefulWidget {
  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final TextEditingController controller = TextEditingController();

  Future<void> saveIncome() async {
    if (controller.text.isEmpty) return;

    final amount = double.parse(controller.text);

    await DatabaseService.instance.insertTransaction(
      type: 'income',
      amount: amount,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Add Income')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^\d+\.?\d{0,2}'),
                ),
              ],
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Amount',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: saveIncome,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
