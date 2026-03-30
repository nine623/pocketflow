import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../database/transaction_db.dart';
import '../models/transaction_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double totalIncome = 0;
  double totalExpense = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future loadData() async {
    final data = await TransactionDB.instance.getMonthly();

    double income = 0;
    double expense = 0;

    for (var tx in data) {
      if (tx.type == 'income') {
        income += tx.amount;
      } else {
        expense += tx.amount;
      }
    }

    setState(() {
      totalIncome = income;
      totalExpense = expense;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profit = totalIncome - totalExpense;

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 💰 Summary Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text("Income: $totalIncome"),
                    Text("Expense: $totalExpense"),
                    Text(
                      "Profit: $profit",
                      style: TextStyle(
                        color: profit >= 0 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 📊 Chart
            Expanded(
              child: BarChart(
                BarChartData(
                  barGroups: [
                    _bar(0, totalIncome, Colors.blue),
                    _bar(1, totalExpense, Colors.red),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text("Income");
                            case 1:
                              return const Text("Expense");
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _bar(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 20,
          color: color,
        )
      ],
    );
  }
}
