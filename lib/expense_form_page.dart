import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';

class ExpenseFormPage extends StatefulWidget {
  ExpenseFormPage({super.key});

  @override
  State<ExpenseFormPage> createState() => _ExpenseFormPageState();
}

class _ExpenseFormPageState extends State<ExpenseFormPage> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  String? selectedMainCategory;
  String? selectedSubCategory;

  final List<String> mainCategories = [
    'รถยนต์',
    'มอเตอร์ไซค์',
    'บ้าน',
    'คอนโด',
    'ทรัพย์สิน',
  ];

  final Map<String, List<String>> subCategories = {
    'รถยนต์': ['เติมน้ำมัน', 'ซ่อม'],
    'มอเตอร์ไซค์': ['เติมน้ำมัน', 'ซ่อม'],
    'บ้าน': ['ค่าไฟ', 'ค่าน้ำ'],
    'คอนโด': ['ค่าส่วนกลาง'],
    'ทรัพย์สิน': ['ทั่วไป'],
  };

  double _parseAmount(String text) {
    return double.tryParse(text.replaceAll(',', '')) ?? 0;
  }

  void _msg(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _save() async {
    if (amountController.text.isEmpty) {
      _msg('กรุณาใส่จำนวนเงิน');
      return;
    }
    if (selectedMainCategory == null) {
      _msg('เลือกหมวดหลัก');
      return;
    }
    if (selectedSubCategory == null) {
      _msg('เลือกหมวดรอง');
      return;
    }

    final amount = _parseAmount(amountController.text);

    await DatabaseHelper.instance.insertTransaction({
      'amount': amount,
      'date': selectedDate.toIso8601String(),
      'type': 'expense',
      'mainCategoryId': mainCategories.indexOf(selectedMainCategory!) + 1,
      'subCategory': selectedSubCategory,
      'note': noteController.text,
      'imagePath': null,
    });

    _msg('บันทึกสำเร็จ');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat("#,##0.00", "en_US");

    return Scaffold(
      appBar: AppBar(title: const Text('Expense Form')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Date
            ListTile(
              title: const Text('Date'),
              subtitle: Text(
                DateFormat('yyyy-MM-dd').format(selectedDate),
              ),
              onTap: _pickDate,
            ),

            const SizedBox(height: 10),

            // Amount
            TextField(
              controller: amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                _DecimalFormatter(),
              ],
              onEditingComplete: () {
                final value = double.tryParse(amountController.text);
                if (value != null) {
                  amountController.text = formatter.format(value);
                }
                FocusScope.of(context).unfocus();
              },
              decoration: const InputDecoration(labelText: 'Amount'),
            ),

            const SizedBox(height: 10),

            // Main Category
            DropdownButtonFormField<String>(
              value: selectedMainCategory,
              dropdownColor: Colors.black,
              style: const TextStyle(color: Colors.white),
              items: mainCategories
                  .map<DropdownMenuItem<String>>(
                      (e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ))
                  .toList(),
              onChanged: (v) => setState(() {
                selectedMainCategory = v;
                selectedSubCategory = null;
              }),
              decoration: const InputDecoration(labelText: 'Main Category'),
            ),

            const SizedBox(height: 10),

            // Sub Category
            DropdownButtonFormField<String>(
              value: selectedSubCategory,
              dropdownColor: Colors.black,
              style: const TextStyle(color: Colors.white),
              items: (selectedMainCategory != null
                      ? subCategories[selectedMainCategory]!
                      : [])
                  .map<DropdownMenuItem<String>>(
                      (e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ))
                  .toList(),
              onChanged: (v) => setState(() => selectedSubCategory = v),
              decoration: const InputDecoration(labelText: 'Sub Category'),
            ),

            const SizedBox(height: 10),

            // Note
            TextField(
              controller: noteController,
              decoration: const InputDecoration(labelText: 'Note'),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _save,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DecimalFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(oldValue, newValue) {
    final text = newValue.text;

    if (text.isEmpty) return newValue;
    if ('.'.allMatches(text).length > 1) return oldValue;

    if (text.contains('.')) {
      final parts = text.split('.');
      if (parts[1].length > 2) return oldValue;
    }

    return newValue;
  }
}
