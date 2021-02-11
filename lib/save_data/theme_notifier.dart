import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;
  setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
  }

  bool _darkModeOn = false;
  bool get darkModeOn => _darkModeOn;
  void darkMode(bool value) {
    _darkModeOn = value;
    notifyListeners();
  }
}
