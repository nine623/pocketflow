import 'package:intl/intl.dart';

class MoneyFormatter {
  static final NumberFormat _formatter = NumberFormat("#,##0.00");

  static String format(double value) {
    return _formatter.format(value);
  }
}
