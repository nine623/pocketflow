import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/graph_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double income = 0;
  double expense = 0;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final data = await GraphService.getSummary();

    setState(() {
      income = data['income']!;
      expense = data['expense']!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Income: $income'),
            Text('Expense: $expense'),
            const SizedBox(height: 30),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [
                      BarChartRodData(toY: income),
                    ]),
                    BarChartGroupData(x: 1, barRods: [
                      BarChartRodData(toY: expense),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
