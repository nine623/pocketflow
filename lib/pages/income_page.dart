import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../utils/amount_formatter.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  final amountController = TextEditingController();
  final savingController = TextEditingController();
  final taxController = TextEditingController();
  final noteController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  String? selectedAsset;

  String? selectedMainCategory;
  String? selectedSubCategory;

  final List<String> assets = ["Cash", "Bank", "Wallet", "Credit Card"];

  final Map<String, List<String>> categories = {
    "Salary": ["Monthly Salary", "Bonus"],
    "Business": ["Sales", "Service"],
    "Investment": ["Stock", "Crypto", "Interest"]
  };

  Future<void> pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Income"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Date",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: pickDate,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('yyyy-MM-dd').format(selectedDate),
                    ),
                    const Icon(Icons.calendar_today)
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Asset",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedAsset,
              items: assets.map((asset) {
                return DropdownMenuItem(
                  value: asset,
                  child: Text(asset),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedAsset = value;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Amount",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'[0-9.]'),
                ),
                AmountInputFormatter()
              ],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "0.00",
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Saving Deduction",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: savingController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
              ],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "0.00",
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Tax %",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: taxController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "0 - 100",
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Main Category",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedMainCategory,
              items: categories.keys.map((main) {
                return DropdownMenuItem(
                  value: main,
                  child: Text(main),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedMainCategory = value;
                  selectedSubCategory = null;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Sub Category",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedSubCategory,
              items: selectedMainCategory == null
                  ? []
                  : categories[selectedMainCategory]!
                      .map((sub) => DropdownMenuItem(
                            value: sub,
                            child: Text(sub),
                          ))
                      .toList(),
              onChanged: (value) {
                setState(() {
                  selectedSubCategory = value;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Receipt / Image",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Center(
                child: Text("Attach Image"),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Note",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (amountController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Amount required")),
                    );

                    return;
                  }

                  if (selectedMainCategory == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Select main category")),
                    );

                    return;
                  }

                  if (selectedSubCategory == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Select sub category")),
                    );

                    return;
                  }

                  String amount = amountController.text.replaceAll(",", "");

                  print("DATE: $selectedDate");
                  print("ASSET: $selectedAsset");
                  print("AMOUNT: $amount");
                  print("SAVING: ${savingController.text}");
                  print("TAX: ${taxController.text}");
                  print("MAIN: $selectedMainCategory");
                  print("SUB: $selectedSubCategory");
                  print("NOTE: ${noteController.text}");

                  Navigator.pop(context);
                },
                child: const Text(
                  "Save",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
