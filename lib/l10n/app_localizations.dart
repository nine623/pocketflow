import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  String get stockList =>
      locale.languageCode == 'th' ? 'รายการหุ้น' : 'Stock List';

  String get addStock =>
      locale.languageCode == 'th' ? 'เพิ่มหุ้น' : 'Add Stock';

  String get symbol => locale.languageCode == 'th' ? 'ชื่อหุ้น' : 'Symbol';

  String get quantity => locale.languageCode == 'th' ? 'จำนวน' : 'Quantity';

  String get price => locale.languageCode == 'th' ? 'ราคา' : 'Price';

  String get commission =>
      locale.languageCode == 'th' ? 'ค่าคอม' : 'Commission';

  String get save => locale.languageCode == 'th' ? 'บันทึก' : 'Save';

  String get portfolio => locale.languageCode == 'th' ? 'พอร์ต' : 'Portfolio';

  String get total => locale.languageCode == 'th' ? 'มูลค่ารวม' : 'Total Value';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['th', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(old) => false;
}
