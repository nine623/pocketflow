import 'package:flutter/material.dart';
import 'stock_form_screen.dart';
import '../database/stock_db.dart';
import '../models/stock_transaction.dart';
import 'report_screen.dart';

class StockListScreen extends StatefulWidget {
  const StockListScreen({super.key});

  @override
  State<StockListScreen> createState() => _StockListScreenState();
}

class _StockListScreenState extends State<StockListScreen> {
  List<StockTransaction> _list = [];

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    _list = await StockDB.instance.getAll();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('รายการหุ้น')),
      body: ListView.builder(
        itemCount: _list.length,
        itemBuilder: (context, index) {
          final tx = _list[index];
          return ListTile(
            title: Text(tx.symbol),
            subtitle: Text('${tx.type} | ${tx.quantity} @ ${tx.price}'),
            trailing: Text(tx.total.toStringAsFixed(2)),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StockFormScreen()),
              );
              fetch();
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'report',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReportScreen()),
              );
            },
            child: const Icon(Icons.bar_chart),
          ),
        ],
      ),
    );
  }
}
