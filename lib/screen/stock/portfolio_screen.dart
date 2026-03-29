import 'package:flutter/material.dart';
import '../../database/stock_db.dart';
import '../../models/stock_transaction.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
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

  double sum(String type) =>
      list.where((e) => e.type == type).fold(0, (s, e) => s + e.total);

  double commissionSum =>
      list.fold(0, (s, e) => s + e.commission);

  double vatSum =>
      list.fold(0, (s, e) => s + e.vat);

  double whtSum =>
      list.fold(0, (s, e) => s + e.withholdingTax);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('รายงาน')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('ซื้อ: ${sum('buy')}'),
          Text('ขาย: ${sum('sell')}'),
          Text('ปันผล: ${sum('dividend')}'),
          const Divider(),
          Text('ค่าคอมรวม: $commissionSum'),
          Text('VAT รวม: $vatSum'),
          Text('ภาษีหัก ณ ที่จ่าย: $whtSum'),
        ],
      ),
    );
  }
}