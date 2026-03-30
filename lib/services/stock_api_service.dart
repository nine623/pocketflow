import 'dart:convert';
import 'package:http/http.dart' as http;

class StockApiService {
  // 🔥 ใช้ API ฟรี (Yahoo Finance)
  static Future<double> getPrice(String symbol) async {
    try {
      final url = Uri.parse(
          'https://query1.finance.yahoo.com/v7/finance/quote?symbols=$symbol');

      final response = await http.get(url);

      final data = json.decode(response.body);

      final price = data['quoteResponse']['result'][0]['regularMarketPrice'];

      return price.toDouble();
    } catch (e) {
      return 0;
    }
  }
}
