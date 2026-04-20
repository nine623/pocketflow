import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final result = await DatabaseHelper.instance.getTransactions();
    setState(() {
      data = result;
    });
  }

  void deleteItem(int id) async {
    await DatabaseHelper.instance.deleteTransaction(id);
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("รายการย้อนหลัง")),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];

          return Dismissible(
            key: Key(item['id'].toString()),
            background: Container(color: Colors.red),
            onDismissed: (_) => deleteItem(item['id']),
            child: ListTile(
              title: Text("${item['amount']}"),
              subtitle: Text(item['note'] ?? ""),
              trailing: Text(item['type']),
            ),
          );
        },
      ),
    );
  }
}
