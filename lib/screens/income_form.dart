import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/database_service.dart';

class IncomeFormPage extends StatefulWidget {
  const IncomeFormPage({super.key});

  @override
  State<IncomeFormPage> createState() => _IncomeFormPageState();
}

class _IncomeFormPageState extends State<IncomeFormPage> {
  final _formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();

  final titleController = TextEditingController(); // 🔥 ตัวนี้ใช้ detect
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  int? selectedAssetId;
  String? mainCategory;
  String? subCategory;

  final mainCategories = ['Salary', 'Bonus'];
  final subCategories = ['Monthly', 'Extra'];

  // 🔥 Keyword Map (หัวใจของระบบ)
  final Map<String, Map<String, String>> keywordMap = {
    'เงินเดือน': {'main': 'Salary', 'sub': 'Monthly'},
    'salary': {'main': 'Salary', 'sub': 'Monthly'},
    'โบนัส': {'main': 'Bonus', 'sub': 'Extra'},
    'bonus': {'main': 'Bonus', 'sub': 'Extra'},
  };

  // 🔥 ฟังก์ชัน detect
  void autoDetectCategory(String text) {
    final lower = text.toLowerCase();

    for (var key in keywordMap.keys) {
      if (lower.contains(key)) {
        setState(() {
          mainCategory = keywordMap[key]!['main'];
          subCategory = keywordMap[key]!['sub'];
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Income')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // 🔥 Title (ใช้ detect)
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'ชื่อรายการ'),
                onChanged: autoDetectCategory,
              ),

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

              // Asset
              FutureBuilder(
                future: DatabaseService.getAssets(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  final assets = snapshot.data as List;

                  return DropdownButtonFormField<int>(
                    value: selectedAssetId,
                    decoration: const InputDecoration(labelText: 'Asset'),
                    items: assets.map((e) {
                      return DropdownMenuItem<int>(
                        value: e['id'],
                        child: Text('${e['name']} (฿${e['balance']})'),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => selectedAssetId = val),
                    validator: (val) => val == null ? 'เลือกบัญชี' : null,
                  );
                },
              ),

              // Amount
              TextFormField(
                controller: amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration: const InputDecoration(labelText: 'Amount'),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'กรอกจำนวนเงิน';
                  }
                  if (double.tryParse(val) == null) {
                    return 'ใส่ตัวเลขเท่านั้น';
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
                    final amount = double.tryParse(amountController.text) ?? 0;

                    await DatabaseService.insertTransaction({
                      'type': 'income',
                      'amount': amount,
                      'category': '$mainCategory - $subCategory',
                      'note': noteController.text,
                      'date': selectedDate.toString(),
                      'assetId': selectedAssetId,
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
