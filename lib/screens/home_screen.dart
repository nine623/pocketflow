import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../services/balance_service.dart';
import 'transaction_screen.dart';
import 'dashboard_screen.dart'; // ✅ เพิ่ม

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> list = [];
  double balance = 0;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final db = await DatabaseService.instance.database;
    final data = await db.query('transactions', orderBy: 'date DESC');
    final b = await BalanceService.getBalance();

    setState(() {
      list = data;
      balance = b;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PocketFlow'),

        // 🔥 ปุ่ม Dashboard อยู่ตรงนี้
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DashboardScreen(),
                ),
              );
              load(); // กลับมา refresh
            },
          ),
        ],
      ),

      body: Column(
        children: [
          // 💰 BALANCE
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Balance: $balance',
              style: const TextStyle(fontSize: 20),
            ),
          ),

          // 📋 LIST
          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final t = list[index];

                return ListTile(
                  title: Text('${t['mainCategory']} - ${t['subCategory']}'),
                  subtitle: Text(t['note'] ?? ''),
                  trailing: Text(
                    t['amount'].toString(),
                    style: TextStyle(
                      color: t['type'] == 'income' ? Colors.green : Colors.red,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // ➕ เพิ่มรายการ
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TransactionScreen(),
            ),
          );
          load();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
