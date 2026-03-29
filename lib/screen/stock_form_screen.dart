import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../database/stock_db.dart';
import '../../models/stock_transaction.dart';

class StockFormScreen extends StatefulWidget {
  const StockFormScreen({super.key});

  @override
  State<StockFormScreen> createState() => _StockFormScreenState();
}

class _StockFormScreenState extends State<StockFormScreen> {
  final symbolController = TextEditingController();
  final qtyController = TextEditingController();
  final priceController = TextEditingController();
  final noteController = TextEditingController();

  String type = 'buy';
  final formatter =
      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'));

  double get qty => double.tryParse(qtyController.text) ?? 0;
  double get price => double.tryParse(priceController.text) ?? 0;
  double get total => qty * price;
  double get commission => total * 0.00157;
  double get vat => commission * 0.07;
  double get wht => type == 'dividend' ? total * 0.10 : 0;

  Future<void> save() async {
    final tx = StockTransaction(
      symbol: symbolController.text,
      quantity: qty,
      price: price,
      total: total,
      commission: commission,
      vat: vat,
      withholdingTax: wht,
      type: type,
      note: noteController.text,
      date: DateTime.now(),
    );
    await StockDB.instance.insert(tx);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เพิ่มรายการหุ้น')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              value: type,
              items: const [
                DropdownMenuItem(value: 'buy', child: Text('ซื้อ')),
                DropdownMenuItem(value: 'sell', child: Text('ขาย')),
                DropdownMenuItem(value: 'dividend', child: Text('ปันผล')),
              ],
              onChanged: (value) => setState(() => type = value!),
              decoration: const InputDecoration(labelText: 'ประเภท'),
            ),
            const SizedBox(height: 10),
            TextField(
                controller: symbolController,
                decoration: const InputDecoration(labelText: 'ชื่อหุ้น')),
            TextField(
              controller: qtyController,
              inputFormatters: [formatter],
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'จำนวนหุ้น'),
              onChanged: (_) => setState(() {}),
            ),
            TextField(
              controller: priceController,
              inputFormatters: [formatter],
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'ราคาต่อหุ้น'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Text('รวม: ${total.toStringAsFixed(2)}'),
            Text('ค่าคอม: ${commission.toStringAsFixed(2)}'),
            Text('VAT 7%: ${vat.toStringAsFixed(2)}'),
            if (type == 'dividend')
              Text('ภาษีหัก ณ ที่จ่าย: ${wht.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            TextField(
                controller: noteController,
                decoration: const InputDecoration(labelText: 'สำหรับใคร')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: save, child: const Text('บันทึก')),
          ],
        ),
      ),
    );
  }
}
