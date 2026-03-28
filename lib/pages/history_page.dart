import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> transactions = [];

  void loadTransactions() async {
    final data = await DatabaseHelper.instance.getTransactions();

    setState(() {
      transactions = data;
    });
  }

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
      ),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final item = transactions[index];

          return ListTile(
            title: Text(item['amount'].toString()),
            subtitle: Text(item['type']),
          );
        },
      ),
    );
  }
}
