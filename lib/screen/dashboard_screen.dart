import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../database/database_helper.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<FlSpot> incomeSpots = [];
  List<FlSpot> expenseSpots = [];

  @override
  void initState() {
    super.initState();
    loadChartData();
  }

  Future<void> loadChartData() async {
    final data = await DatabaseHelper.instance.getTransactions();

    Map<int, double> incomeMap = {};
    Map<int, double> expenseMap = {};

    for (var item in data) {
      DateTime date = DateTime.parse(item['date']);
      int day = date.day;

      if (item['type'] == 'income') {
        incomeMap[day] = (incomeMap[day] ?? 0) + item['amount'];
      } else {
        expenseMap[day] = (expenseMap[day] ?? 0) + item['amount'];
      }
    }

    setState(() {
      incomeSpots = incomeMap.entries
          .map((e) => FlSpot(e.key.toDouble(), e.value))
          .toList();

      expenseSpots = expenseMap.entries
          .map((e) => FlSpot(e.key.toDouble(), e.value))
          .toList();
    });
  }

  Widget buildChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(show: true),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: incomeSpots,
            isCurved: true,
            color: Colors.greenAccent,
            barWidth: 3,
            dotData: FlDotData(show: false),
          ),
          LineChartBarData(
            spots: expenseSpots,
            isCurved: true,
            color: Colors.redAccent,
            barWidth: 3,
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  Widget buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.circle, color: Colors.greenAccent, size: 12),
        SizedBox(width: 6),
        Text("Income"),
        SizedBox(width: 20),
        Icon(Icons.circle, color: Colors.redAccent, size: 12),
        SizedBox(width: 6),
        Text("Expense"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "รายรับ vs รายจ่าย (รายวัน)",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),

            buildLegend(), // 🔥 Legend สวย ๆ

            const SizedBox(height: 20),

            SizedBox(
              height: 300,
              child: buildChart(),
            ),
          ],
        ),
      ),
    );
  }
}
