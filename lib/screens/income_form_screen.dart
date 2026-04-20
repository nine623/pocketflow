import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';

class IncomeFormScreen extends StatefulWidget {
  const IncomeFormScreen({super.key});

  @override
  State<IncomeFormScreen> createState() => _IncomeFormScreenState();
}

class _IncomeFormScreenState extends State<IncomeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _taxController = TextEditingController();
  String? _selectedCategory;
  File? _selectedFile;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  void _saveIncome() async {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);
      final tax =
          _taxController.text.isEmpty ? 0.0 : double.parse(_taxController.text);
      final category = _selectedCategory ?? 'อื่นๆ';
      final db = await DatabaseHelper.instance.database;

      await db.insert('transaction', {
        'amount': amount,
        'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'type': 'income',
        'mainCategoryId': 1, // ต่อไปจะทำ dropdown เชื่อม category จริง
        'subCategory': category,
        'note': '',
        'imagePath': _selectedFile?.path ?? '',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('บันทึกรายรับเรียบร้อยแล้ว')),
      );
      _amountController.clear();
      _taxController.clear();
      setState(() {
        _selectedFile = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เพิ่มรายรับ')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'จำนวนเงิน',
                  border: OutlineInputBorder(),
                  prefixText: '฿ ',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาใส่จำนวนเงิน';
                  }
                  final regex = RegExp(r'^\d+(\.\d{1,2})?$');
                  if (!regex.hasMatch(value)) {
                    return 'จำนวนเงินต้องเป็นตัวเลข และทศนิยมสูงสุด 2 ตำแหน่ง';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _taxController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'เปอร์เซ็นต์ภาษี (ถ้ามี)',
                  border: OutlineInputBorder(),
                  suffixText: '%',
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final regex = RegExp(r'^\d+(\.\d{1,2})?$');
                    if (!regex.hasMatch(value)) {
                      return 'กรอกตัวเลขได้สูงสุด 2 ทศนิยม';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: const [
                  DropdownMenuItem(
                      value: 'เงินเดือน', child: Text('เงินเดือน')),
                  DropdownMenuItem(value: 'โบนัส', child: Text('โบนัส')),
                  DropdownMenuItem(value: 'อื่นๆ', child: Text('อื่นๆ')),
                ],
                onChanged: (val) {
                  setState(() {
                    _selectedCategory = val;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'หมวดหมู่',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาเลือกหมวดหมู่';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickFile,
                    child: const Text('แนบรูป'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      _selectedFile != null
                          ? _selectedFile!.path.split('/').last
                          : 'ยังไม่ได้เลือกไฟล์',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveIncome,
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('บันทึกรายรับ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
