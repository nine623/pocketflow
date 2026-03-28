import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardChart extends StatelessWidget {
  final double income;
  final double expense;

  const DashboardChart({
    super.key,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          sections: [
            PieChartSectionData(
              color: Colors.green,
              value: income,
              title: "Income",
              radius: 60,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            PieChartSectionData(
              color: Colors.red,
              value: expense,
              title: "Expense",
              radius: 60,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
