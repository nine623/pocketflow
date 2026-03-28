import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AmountInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat("#,##0.##");

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // เอา comma ออกก่อน
    String text = newValue.text.replaceAll(",", "");

    // ตรวจสอบตัวเลข + decimal
    if (!RegExp(r'^\d*\.?\d{0,2}$').hasMatch(text)) {
      return oldValue;
    }

    // แยกทศนิยม
    if (text.contains(".")) {
      List<String> parts = text.split(".");
      String integerPart = parts[0];
      String decimalPart = parts[1];

      String formattedInt = _formatter.format(int.parse(integerPart));

      String result = "$formattedInt.$decimalPart";

      return TextEditingValue(
        text: result,
        selection: TextSelection.collapsed(offset: result.length),
      );
    }

    String formatted = _formatter.format(int.parse(text));

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
