import 'package:flutter/material.dart';
import '../database/stock_transaction_db.dart';
import '../services/stock_calculator.dart';
import '../services/stock_api_service.dart';
import 'stock_trade_screen.dart';

class StockReportScreen extends StatefulWidget {
  const StockReportScreen({super.key});

  @override
  State<StockReportScreen> createState() => _StockReportScreenState();
}

class _StockReportScreenState extends State<StockReportScreen> {
  Map<String, StockSummary> summary = {};

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future loadData() async {
    final txList = await StockTransactionDB.instance.getAll();

    // 🔥 ดึงราคาหุ้น
    Map<String, double> prices = {};

    final symbols = txList.map((e) => e.symbol).toSet().toList();

    for (var s in symbols) {
      final price = await StockApiService.getPrice(s);
      prices[s] = price;
    }

    final result = StockCalculator.calculate(txList, prices);

    setState(() {
      summary = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isThai = Localizations.localeOf(context).languageCode == 'th';

    return Scaffold(
      appBar: AppBar(
        title: Text(isThai ? 'พอร์ตหุ้น' : 'Portfolio'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const StockTradeScreen(),
            ),
          );
          loadData();
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: DataTable(
          columns: [
            DataColumn(label: Text(isThai ? 'หุ้น' : 'Symbol')),
            DataColumn(label: Text(isThai ? 'จำนวน' : 'Qty')),
            DataColumn(label: Text(isThai ? 'ต้นทุน' : 'Avg')),
            DataColumn(label: Text(isThai ? 'ราคา' : 'Price')),
            DataColumn(label: Text(isThai ? 'กำไรยังไม่ขาย' : 'Unreal')),
            DataColumn(label: Text(isThai ? 'กำไรขายแล้ว' : 'Realized')),
          ],
          rows: summary.entries.map((e) {
            final s = e.value;

            return DataRow(cells: [
              DataCell(Text(e.key)),
              DataCell(Text(s.totalQty.toString())),
              DataCell(Text(s.avgCost.toStringAsFixed(2))),
              DataCell(Text(s.currentPrice.toStringAsFixed(2))),
              DataCell(Text(
                s.unrealizedProfit.toStringAsFixed(2),
                style: TextStyle(
                    color: s.unrealizedProfit >= 0 ? Colors.green : Colors.red),
              )),
              DataCell(Text(
                s.realizedProfit.toStringAsFixed(2),
                style: TextStyle(
                    color: s.realizedProfit >= 0 ? Colors.green : Colors.red),
              )),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
