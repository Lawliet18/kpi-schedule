import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  bool _darkModeOn = false;
  bool get darkModeOn => _darkModeOn;
  void darkMode({required bool darkMode}) {
    _darkModeOn = darkMode;
    notifyListeners();
  }
}
