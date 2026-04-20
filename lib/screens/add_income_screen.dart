import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/database_service.dart';

class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({super.key});

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final _formKey = GlobalKey<FormState>();

  final amountController = TextEditingController();
  final assetController = TextEditingController();
  final savingController = TextEditingController();
  final taxController = TextEditingController();
  final noteController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  String? mainCategory;
  String? subCategory;

  Future<void> saveData() async {
    if (!_formKey.currentState!.validate()) return;

    final tx = TransactionModel(
      type: "income",
      date: selectedDate.toString(),
      asset: assetController.text,
      amount: double.parse(amountController.text),
      saving: savingController.text.isEmpty
          ? null
          : double.parse(savingController.text),
      tax: taxController.text.isEmpty ? null : double.parse(taxController.text),
      mainCategory: mainCategory!,
      subCategory: subCategory!,
      note: noteController.text,
    );

    await DatabaseService.instance.insertTransaction(tx);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("บันทึกสำเร็จ")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("เพิ่มรายรับ")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // 1 Date
              ListTile(
                title: Text("วันที่: ${selectedDate.toLocal()}".split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    setState(() => selectedDate = date);
                  }
                },
              ),

              // 2 Asset
              TextFormField(
                controller: assetController,
                decoration: const InputDecoration(labelText: "ทรัพย์สิน"),
              ),

              // 3 Amount (required)
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "จำนวนเงิน *"),
                validator: (value) =>
                    value == null || value.isEmpty ? "กรอกจำนวนเงิน" : null,
              ),

              // 4 Saving
              TextFormField(
                controller: savingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "หักเงินเก็บ"),
              ),

              // 5 Tax %
              TextFormField(
                controller: taxController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "ภาษี (%)"),
              ),

              const SizedBox(height: 10),

              // 6 Main Category
              DropdownButtonFormField<String>(
                value: mainCategory,
                hint: const Text("เลือกหมวดหลัก *"),
                items: ["เงินเดือน", "โบนัส", "อื่นๆ"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    mainCategory = value;
                  });
                },
                validator: (value) => value == null ? "เลือกหมวดหลัก" : null,
              ),

              // 7 Sub Category
              DropdownButtonFormField<String>(
                value: subCategory,
                hint: const Text("เลือกหมวดย่อย *"),
                items: ["ประจำ", "พิเศษ", "อื่นๆ"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    subCategory = value;
                  });
                },
                validator: (value) => value == null ? "เลือกหมวดย่อย" : null,
              ),

              // 8 Image (placeholder)
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                child: const Text("แนบรูป (ยังไม่เปิดใช้)"),
              ),

              // 9 Note
              TextFormField(
                controller: noteController,
                decoration: const InputDecoration(labelText: "หมายเหตุ"),
              ),

              const SizedBox(height: 20),

              // 10 Save
              ElevatedButton(
                onPressed: saveData,
                child: const Text("บันทึก"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
