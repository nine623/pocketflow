import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExpenseBox extends StatefulWidget {
  const ExpenseBox({super.key});

  @override
  State<ExpenseBox> createState() => _ExpenseBoxState();
}

class _ExpenseBoxState extends State<ExpenseBox> {
  final amountController = TextEditingController();

  List<TextInputFormatter> decimalFormatter() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.redAccent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Expense",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            inputFormatters: decimalFormatter(),
            decoration: const InputDecoration(
              labelText: "Amount",
              labelStyle: TextStyle(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
