import 'package:flutter/material.dart';
import '../services/database_service.dart';

class ExpenseFormPage extends StatefulWidget {
  const ExpenseFormPage({super.key});

  @override
  State<ExpenseFormPage> createState() => _ExpenseFormPageState();
}

class _ExpenseFormPageState extends State<ExpenseFormPage> {
  final _formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();

  final amountController = TextEditingController();
  final noteController = TextEditingController();

  String? mainCategory;
  String? subCategory;

  final mainCategories = ['Food', 'Transport', 'Shopping'];
  final subCategories = ['ทั่วไป', 'จำเป็น', 'ฟุ่มเฟือย'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Date
              ListTile(
                title: Text(
                  'Date: ${selectedDate.toLocal()}'.split(' ')[0],
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => selectedDate = picked);
                  }
                },
              ),

              // Amount
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'กรอกจำนวนเงิน';
                  }
                  return null;
                },
              ),

              // Main Category
              DropdownButtonFormField<String>(
                value: mainCategory,
                decoration: const InputDecoration(labelText: 'Main Category'),
                items: mainCategories
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => mainCategory = val),
                validator: (val) => val == null ? 'เลือกหมวดหลัก' : null,
              ),

              // Sub Category
              DropdownButtonFormField<String>(
                value: subCategory,
                decoration: const InputDecoration(labelText: 'Sub Category'),
                items: subCategories
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => subCategory = val),
                validator: (val) => val == null ? 'เลือกหมวดย่อย' : null,
              ),

              // Note
              TextFormField(
                controller: noteController,
                decoration: const InputDecoration(labelText: 'Note'),
              ),

              const SizedBox(height: 20),

              // Save
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await DatabaseService.insertTransaction({
                      'type': 'expense',
                      'amount': double.parse(amountController.text),
                      'category': '$mainCategory - $subCategory',
                      'note': noteController.text,
                      'date': selectedDate.toString(),
                    });

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
