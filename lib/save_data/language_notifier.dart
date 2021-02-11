import 'package:flutter/foundation.dart';

class LanguageNotifier extends ChangeNotifier {
  String _language = 'en';
  String get language => _language;

  void setLanguage(String lng) {
    _language = lng;
    notifyListeners();
  }
}
