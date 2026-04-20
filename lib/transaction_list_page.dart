import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';
import 'expense_form_page.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({super.key});

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  List<Map<String, dynamic>> transactions = [];

  final formatter = NumberFormat("#,##0.00", "en_US");

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await DatabaseHelper.instance.getTransactions();
    setState(() {
      transactions = data;
    });
  }

  Future<void> _delete(int id) async {
    await DatabaseHelper.instance.deleteTransaction(id);
    _loadData();
  }

  String _getCategory(int id) {
    switch (id) {
      case 1:
        return 'รถยนต์';
      case 2:
        return 'มอเตอร์ไซค์';
      case 3:
        return 'บ้าน';
      case 4:
        return 'คอนโด';
      case 5:
        return 'ทรัพย์สิน';
      default:
        return 'อื่น ๆ';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('รายการทั้งหมด'),
        backgroundColor: Colors.black,
      ),

      // 🔥 ปุ่มเพิ่มรายการ
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ExpenseFormPage()),
          );
          _loadData();
        },
        child: const Icon(Icons.add),
      ),

      body: transactions.isEmpty
          ? const Center(
              child: Text(
                'ไม่มีข้อมูล',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final item = transactions[index];

                return Dismissible(
                  key: Key(item['id'].toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => _delete(item['id']),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    title: Text(
                      formatter.format(item['amount']),
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      '${_getCategory(item['mainCategoryId'])} • ${item['subCategory'] ?? ''}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: Text(
                      DateFormat('yyyy-MM-dd')
                          .format(DateTime.parse(item['date'])),
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
