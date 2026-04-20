import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pocketflow/services/portfolio_service.dart';

class PortfolioDashboard extends StatefulWidget {
  const PortfolioDashboard({super.key});

  @override
  State<PortfolioDashboard> createState() => _PortfolioDashboardState();
}

class _PortfolioDashboardState extends State<PortfolioDashboard> {
  PortfolioSummary? summary;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await PortfolioService.getSummary();
    setState(() {
      summary = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final s = summary!;

    return Scaffold(
      appBar: AppBar(title: const Text("Portfolio Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _summaryCard(s),
            const SizedBox(height: 20),
            Expanded(child: _chart()),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(PortfolioSummary s) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _row("เงินต้น", s.totalCost),
            _row("มูลค่าปัจจุบัน", s.currentValue),
            const Divider(),
            _row("กำไร/ขาดทุน", s.profit),
            _row("%", s.percent),
          ],
        ),
      ),
    );
  }

  Widget _row(String title, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(value.toStringAsFixed(2)),
      ],
    );
  }

  Widget _chart() {
    final spots = [
      FlSpot(0, summary!.totalCost),
      FlSpot(1, summary!.currentValue),
    ];

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
          ),
        ],
      ),
    );
  }
}
