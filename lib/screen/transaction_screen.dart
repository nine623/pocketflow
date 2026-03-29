import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/database_service.dart';
import '../services/category_ai_service.dart';

// 🔥 FORMATTER แบบลื่น (ไม่เด้ง ไม่ค้าง)
class AmountInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;

    // อนุญาตเฉพาะตัวเลข + จุด
    if (!RegExp(r'^\d*\.?\d{0,2}$').hasMatch(text)) {
      return oldValue;
    }

    return newValue;
  }
}

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  String type = 'expense';
  String mainCategory = 'Food';
  String subCategory = 'Eat';

  final List<String> mainList = ['Food', 'Transport', 'Income'];

  final Map<String, List<String>> subMap = {
    'Food': ['Eat', 'Drink'],
    'Transport': ['Taxi', 'Fuel'],
    'Income': ['Salary', 'Bonus'],
  };

  void autoDetect() {
    final result = CategoryAIService.detect(noteController.text);
    if (result != null) {
      setState(() {
        mainCategory = result['main']!;
        subCategory = result['sub']!;
      });
    }
  }

  void save() async {
    final amount = double.tryParse(amountController.text) ?? 0;
    if (amount <= 0) return;

    await DatabaseService.instance.insertTransaction(
      type: type,
      amount: amount,
      mainCategory: mainCategory,
      subCategory: subCategory,
      note: noteController.text,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton(
              value: type,
              items: const [
                DropdownMenuItem(value: 'income', child: Text('Income')),
                DropdownMenuItem(value: 'expense', child: Text('Expense')),
              ],
              onChanged: (v) => setState(() => type = v! as String),
            ),

            // ✅ ช่องเงิน (ลื่น ใช้ได้จริง)
            TextField(
              controller: amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                AmountInputFormatter(),
              ],
              decoration: const InputDecoration(labelText: 'Amount'),
            ),

            DropdownButton(
              value: mainCategory,
              items: mainList
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) {
                setState(() {
                  mainCategory = v! as String;
                  subCategory = subMap[mainCategory]!.first;
                });
              },
            ),

            DropdownButton(
              value: subCategory,
              items: subMap[mainCategory]!
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => subCategory = v! as String),
            ),

            TextField(
              controller: noteController,
              decoration: const InputDecoration(labelText: 'Note'),
              onChanged: (v) => autoDetect(),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: save,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
