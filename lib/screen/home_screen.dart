import 'package:flutter/material.dart';
import 'income_form_screen.dart';
import 'expense_form.dart'; // สร้างคล้ายกันกับ IncomeFormScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double balance = 0.0;

  void _openIncomeForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const IncomeFormScreen()),
    ).then((_) {
      // Refresh balance หลังกลับมาจากฟอร์ม
      setState(() {});
    });
  }

  void _openExpenseForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ExpenseFormScreen()),
    ).then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PocketFlow Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              color: Colors.blue.shade100,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'ยอดคงเหลือ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '฿ ${balance.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _openIncomeForm,
                  icon: const Icon(Icons.add),
                  label: const Text('รายรับ +'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24)),
                ),
                ElevatedButton.icon(
                  onPressed: _openExpenseForm,
                  icon: const Icon(Icons.remove),
                  label: const Text('รายจ่าย -'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
