import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../database/stock_db.dart';
import '../../models/stock_transaction.dart';
import '../../utils/stock_calculator.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<StockTransaction> list = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future load() async {
    list = await StockDB.instance.getAll();
    setState(() {});
  }

  DateTime now = DateTime.now();

  List<StockTransaction> get daily => list
      .where((e) =>
          e.date.year == now.year &&
          e.date.month == now.month &&
          e.date.day == now.day)
      .toList();

  List<StockTransaction> get monthly =>
      list.where((e) => e.date.month == now.month).toList();

  List<StockTransaction> get yearly =>
      list.where((e) => e.date.year == now.year).toList();

  Widget buildChart(List<StockTransaction> data) {
    final buy = StockCalculator.sumByType(data, 'buy');
    final sell = StockCalculator.sumByType(data, 'sell');
    final div = StockCalculator.sumByType(data, 'dividend');

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          barGroups: [
            BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: buy)]),
            BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: sell)]),
            BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: div)]),
          ],
        ),
      ),
    );
  }

  Widget section(String title, List<StockTransaction> data) {
    final pnl = StockCalculator.calculatePnL(data);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 18)),
            Text('PnL: $pnl'),
            buildChart(data),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalPnL = StockCalculator.calculatePnL(list);

    return Scaffold(
      appBar: AppBar(title: const Text('รายงาน')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('PnL รวมทั้งหมด: $totalPnL',
              style: const TextStyle(fontSize: 20)),
          section('รายวัน', daily),
          section('รายเดือน', monthly),
          section('รายปี', yearly),
        ],
      ),
    );
  }
}
