import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IncomeBox extends StatefulWidget {
  const IncomeBox({super.key});

  @override
  State<IncomeBox> createState() => _IncomeBoxState();
}

class _IncomeBoxState extends State<IncomeBox> {
  final amountController = TextEditingController();
  final taxController = TextEditingController();
  final savingController = TextEditingController();

  double netIncome = 0;

  void calculate() {
    double amount = double.tryParse(amountController.text) ?? 0;
    double taxPercent = double.tryParse(taxController.text) ?? 0;
    double saving = double.tryParse(savingController.text) ?? 0;

    double tax = amount * (taxPercent / 100);
    setState(() {
      netIncome = amount - tax - saving;
    });
  }

  InputDecoration inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white24),
      ),
    );
  }

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
        color: const Color(0xFF1E2D24),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.greenAccent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Income",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.greenAccent,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            inputFormatters: decimalFormatter(),
            decoration: inputStyle("Amount"),
            onChanged: (_) => calculate(),
          ),
          TextField(
            controller: taxController,
            keyboardType: TextInputType.number,
            inputFormatters: decimalFormatter(),
            decoration: inputStyle("Tax %"),
            onChanged: (_) => calculate(),
          ),
          TextField(
            controller: savingController,
            keyboardType: TextInputType.number,
            inputFormatters: decimalFormatter(),
            decoration: inputStyle("Saving Deduction"),
            onChanged: (_) => calculate(),
          ),
          const SizedBox(height: 20),
          Text(
            "Net Income: ${netIncome.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.greenAccent,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
