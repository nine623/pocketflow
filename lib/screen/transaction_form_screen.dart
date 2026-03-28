import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/database_service.dart';

class TransactionFormScreen extends StatefulWidget {
  const TransactionFormScreen({super.key});

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  String type = 'income';
  String asset = 'Cash';

  String mainCategory = 'General';
  String subCategory = 'Other';

  final TextEditingController amountController = TextEditingController();
  final TextEditingController savingController = TextEditingController();
  final TextEditingController taxController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  final Map<String, List<String>> categories = {
    'General': ['Other', 'Misc'],
    'Food': ['Restaurant', 'Coffee', 'Snack'],
    'Transport': ['Fuel', 'Taxi', 'Bus'],
    'Salary': ['Monthly', 'Bonus']
  };

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  InputDecoration inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
    );
  }

  Future<void> saveTransaction() async {
    final originalAmount = double.tryParse(amountController.text) ?? 0.0;

    if (originalAmount <= 0) return;

    double savingAmount = 0.0;
    double taxAmount = 0.0;
    double finalAmount = originalAmount;

    if (type == 'income') {
      savingAmount = double.tryParse(savingController.text) ?? 0.0;

      final taxPercent = double.tryParse(taxController.text) ?? 0.0;

      taxAmount = originalAmount * (taxPercent / 100);

      finalAmount = originalAmount - savingAmount - taxAmount;
    }

    await DatabaseService.insertTransaction(
      type: type,
      date: selectedDate.toIso8601String(),
      asset: asset,
      originalAmount: originalAmount,
      amount: finalAmount,
      savingAmount: savingAmount,
      taxAmount: taxAmount,
      mainCategory: mainCategory,
      subCategory: subCategory,
      note: noteController.text,
    );

    Navigator.pop(context);
  }

  Widget numberField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(color: Colors.white),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(r'^\d*\.?\d{0,2}'),
        ),
      ],
      decoration: inputStyle(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Transaction',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: pickDate,
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.white),
                    ),
                  ),
                  child: Text(
                    "วันที่: ${selectedDate.toLocal().toString().split(' ')[0]}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                dropdownColor: Colors.grey[900],
                value: asset,
                items: const [
                  DropdownMenuItem(
                    value: 'Cash',
                    child: Text('Cash', style: TextStyle(color: Colors.white)),
                  ),
                  DropdownMenuItem(
                    value: 'Bank',
                    child: Text('Bank', style: TextStyle(color: Colors.white)),
                  ),
                  DropdownMenuItem(
                    value: 'Wallet',
                    child:
                        Text('Wallet', style: TextStyle(color: Colors.white)),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    asset = value!;
                  });
                },
                decoration: inputStyle('Asset'),
              ),
              const SizedBox(height: 20),
              numberField(amountController, 'Amount'),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                dropdownColor: Colors.grey[900],
                value: type,
                items: const [
                  DropdownMenuItem(
                    value: 'income',
                    child:
                        Text('รายรับ', style: TextStyle(color: Colors.white)),
                  ),
                  DropdownMenuItem(
                    value: 'expense',
                    child:
                        Text('รายจ่าย', style: TextStyle(color: Colors.white)),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    type = value!;
                  });
                },
                decoration: inputStyle('ประเภท'),
              ),
              const SizedBox(height: 20),
              if (type == 'income') ...[
                numberField(savingController, 'Saving Deduction'),
                const SizedBox(height: 20),
                numberField(taxController, 'Tax %'),
                const SizedBox(height: 20),
              ],
              DropdownButtonFormField<String>(
                dropdownColor: Colors.grey[900],
                value: mainCategory,
                items: categories.keys
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e,
                              style: const TextStyle(color: Colors.white)),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    mainCategory = value!;
                    subCategory = categories[value]!.first;
                  });
                },
                decoration: inputStyle('Main Category'),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                dropdownColor: Colors.grey[900],
                value: subCategory,
                items: categories[mainCategory]!
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e,
                              style: const TextStyle(color: Colors.white)),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    subCategory = value!;
                  });
                },
                decoration: inputStyle('Subcategory'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: noteController,
                style: const TextStyle(color: Colors.white),
                decoration: inputStyle('Note'),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: saveTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  'บันทึก',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
