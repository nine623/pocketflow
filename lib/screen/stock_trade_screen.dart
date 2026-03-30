import 'package:flutter/material.dart';
import '../database/stock_transaction_db.dart';
import '../models/stock_transaction.dart';

class StockTradeScreen extends StatefulWidget {
  const StockTradeScreen({super.key});

  @override
  State<StockTradeScreen> createState() => _StockTradeScreenState();
}

class _StockTradeScreenState extends State<StockTradeScreen> {
  final symbolCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final qtyCtrl = TextEditingController();

  String type = 'buy';

  @override
  Widget build(BuildContext context) {
    final isThai = Localizations.localeOf(context).languageCode == 'th';

    return Scaffold(
      appBar: AppBar(
        title: Text(isThai ? 'ซื้อ/ขายหุ้น' : 'Trade Stock'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: symbolCtrl,
              decoration: InputDecoration(
                labelText: isThai ? 'ชื่อหุ้น' : 'Symbol',
              ),
            ),
            TextField(
              controller: priceCtrl,
              decoration: InputDecoration(
                labelText: isThai ? 'ราคา' : 'Price',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: qtyCtrl,
              decoration: InputDecoration(
                labelText: isThai ? 'จำนวน' : 'Quantity',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: type,
              items: [
                DropdownMenuItem(
                  value: 'buy',
                  child: Text(isThai ? 'ซื้อ' : 'Buy'),
                ),
                DropdownMenuItem(
                  value: 'sell',
                  child: Text(isThai ? 'ขาย' : 'Sell'),
                ),
              ],
              onChanged: (v) => setState(() => type = v!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // ✅ VALIDATE
                if (symbolCtrl.text.isEmpty ||
                    priceCtrl.text.isEmpty ||
                    qtyCtrl.text.isEmpty) {
                  showError(
                      isThai ? 'กรอกข้อมูลให้ครบ' : 'Please fill all fields');
                  return;
                }

                final price = double.tryParse(priceCtrl.text);
                final qty = int.tryParse(qtyCtrl.text);

                if (price == null || qty == null) {
                  showError(isThai ? 'ตัวเลขไม่ถูกต้อง' : 'Invalid number');
                  return;
                }

                try {
                  await StockTransactionDB.instance.insert(
                    StockTransaction(
                      symbol: symbolCtrl.text.toUpperCase(),
                      type: type,
                      price: price,
                      quantity: qty,
                      date: DateTime.now().toString(),
                    ),
                  );

                  // ✅ success
                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text(isThai ? 'บันทึกสำเร็จ' : 'Saved successfully'),
                    ),
                  );

                  Navigator.pop(context);
                } catch (e) {
                  showError(e.toString());
                }
              },
              child: Text(isThai ? 'บันทึก' : 'Save'),
            )
          ],
        ),
      ),
    );
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
      ),
    );
  }
}
