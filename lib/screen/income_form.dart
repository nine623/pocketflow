import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class IncomeFormPage extends StatefulWidget {
  const IncomeFormPage({super.key});

  @override
  State<IncomeFormPage> createState() => _IncomeFormPageState();
}

class _IncomeFormPageState extends State<IncomeFormPage> {
  final _formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();
  String? selectedAsset;
  String? mainCategory;
  String? subCategory;

  final amountController = TextEditingController();
  final savingController = TextEditingController();
  final taxController = TextEditingController();
  final noteController = TextEditingController();

  Database? db;

  @override
  void initState() {
    super.initState();
    initDB();
  }

  Future<void> initDB() async {
    final path = join(await getDatabasesPath(), 'pocketflow.db');

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE income(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT,
            asset TEXT,
            amount REAL,
            saving REAL,
            tax REAL,
            mainCategory TEXT,
            subCategory TEXT,
            note TEXT
          )
        ''');
      },
    );
  }

  Future<void> saveData() async {
    if (!_formKey.currentState!.validate()) return;

    await db!.insert('income', {
      'date': selectedDate.toString(),
      'asset': selectedAsset,
      'amount': double.parse(amountController.text),
      'saving': savingController.text.isEmpty
          ? 0
          : double.parse(savingController.text),
      'tax': taxController.text.isEmpty ? 0 : double.parse(taxController.text),
      'mainCategory': mainCategory,
      'subCategory': subCategory,
      'note': noteController.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('บันทึกสำเร็จ')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มรายรับ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // 📅 Date
              ListTile(
                title: Text("วันที่: ${selectedDate.toLocal()}".split(' ')[0]),
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

              // 💰 Asset
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Asset'),
                items: ['เงินสด', 'บัญชีธนาคาร']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => selectedAsset = value,
              ),

              // 💵 Amount
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount *'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาใส่จำนวนเงิน';
                  }
                  return null;
                },
              ),

              // 💸 Saving
              TextFormField(
                controller: savingController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Saving (optional)'),
              ),

              // 📊 Tax
              TextFormField(
                controller: taxController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Tax %'),
              ),

              // 📂 Main Category
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Main Category *'),
                items: ['เงินเดือน', 'ธุรกิจ']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                validator: (value) => value == null ? 'เลือกหมวดหลัก' : null,
                onChanged: (value) => mainCategory = value,
              ),

              // 📁 Sub Category
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Sub Category *'),
                items: ['รายรับประจำ', 'โบนัส']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                validator: (value) => value == null ? 'เลือกหมวดย่อย' : null,
                onChanged: (value) => subCategory = value,
              ),

              // 📝 Note
              TextFormField(
                controller: noteController,
                decoration: const InputDecoration(labelText: 'Note'),
              ),

              const SizedBox(height: 20),

              // 💾 Save
              ElevatedButton(
                onPressed: saveData,
                child: const Text('บันทึก'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
