import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransactionDialog extends StatefulWidget {
  final Function(double income, double expense) onSave;

  const TransactionDialog({super.key, required this.onSave});

  @override
  State<TransactionDialog> createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<TransactionDialog> {
  final incomeAmount = TextEditingController();
  final taxPercent = TextEditingController();
  final saving = TextEditingController();
  final expenseAmount = TextEditingController();

  double netIncome = 0;

  List<TextInputFormatter> decimalFormatter() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
    ];
  }

  void calculate() {
    double amount = double.tryParse(incomeAmount.text) ?? 0;
    double tax = double.tryParse(taxPercent.text) ?? 0;
    double save = double.tryParse(saving.text) ?? 0;

    double taxValue = amount * (tax / 100);

    setState(() {
      netIncome = amount - taxValue - save;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E1E1E),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: 700,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.greenAccent),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Income",
                          style: TextStyle(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold)),
                      TextField(
                        controller: incomeAmount,
                        inputFormatters: decimalFormatter(),
                        decoration: const InputDecoration(labelText: "Amount"),
                        onChanged: (_) => calculate(),
                      ),
                      TextField(
                        controller: taxPercent,
                        inputFormatters: decimalFormatter(),
                        decoration: const InputDecoration(labelText: "Tax %"),
                        onChanged: (_) => calculate(),
                      ),
                      TextField(
                        controller: saving,
                        inputFormatters: decimalFormatter(),
                        decoration: const InputDecoration(labelText: "Saving"),
                        onChanged: (_) => calculate(),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Net: ${netIncome.toStringAsFixed(2)}",
                        style: const TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.redAccent),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Expense",
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold)),
                      TextField(
                        controller: expenseAmount,
                        inputFormatters: decimalFormatter(),
                        decoration: const InputDecoration(labelText: "Amount"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
