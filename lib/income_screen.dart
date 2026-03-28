import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final amountController = TextEditingController();
  final savingController = TextEditingController();
  final taxController = TextEditingController();
  final noteController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  String asset = "Cash";
  String mainCategory = "Salary";
  String subCategory = "Monthly Salary";

  File? imageFile;

  Database? db;

  @override
  void initState() {
    super.initState();
    initDB();
  }

  Future<void> initDB() async {
    final dir = await getApplicationDocumentsDirectory();

    final path = "${dir.path}/pocketflow.db";

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE income(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT,
          asset TEXT,
          amount REAL,
          saving REAL,
          tax REAL,
          mainCategory TEXT,
          subCategory TEXT,
          note TEXT,
          image TEXT
        )
        ''');
      },
    );
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return;

    setState(() {
      imageFile = File(image.path);
    });
  }

  Future<void> saveIncome() async {
    double amount = double.tryParse(amountController.text) ?? 0;

    double saving = double.tryParse(savingController.text) ?? 0;

    double tax = double.tryParse(taxController.text) ?? 0;

    String note = noteController.text;

    await db!.insert(
      "income",
      {
        "date": selectedDate.toString(),
        "asset": asset,
        "amount": amount,
        "saving": saving,
        "tax": tax,
        "mainCategory": mainCategory,
        "subCategory": subCategory,
        "note": note,
        "image": imageFile?.path ?? ""
      },
    );

    debugPrint("DATE: $selectedDate");
    debugPrint("ASSET: $asset");
    debugPrint("AMOUNT: $amount");
    debugPrint("SAVING: $saving");
    debugPrint("TAX: $tax");
    debugPrint("MAIN: $mainCategory");
    debugPrint("SUB: $subCategory");
    debugPrint("NOTE: $note");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Saved successfully")),
    );
  }

  InputDecoration fieldStyle(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Income"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: amountController,
              decoration: fieldStyle("Amount"),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: savingController,
              decoration: fieldStyle("Saving"),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: taxController,
              decoration: fieldStyle("Tax %"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: noteController,
              decoration: fieldStyle("Note"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickImage,
              child: const Text("Select Image"),
            ),
            const SizedBox(height: 10),
            if (imageFile != null)
              Image.file(
                imageFile!,
                height: 200,
              ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: saveIncome,
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}
