import 'package:flutter/cupertino.dart';

class Notifier with ChangeNotifier {
  String _groupName = '';
  String get groupName => _groupName;

  bool _darkModeOn = false;
  bool get darkModeOn => _darkModeOn;

  String _week = '1';
  String get week => _week;

  void addGroupName(String name) {
    _groupName = name;

    notifyListeners();
  }

  void darkMode(bool darkMode) {
    _darkModeOn = darkMode;
    notifyListeners();
  }

  void removeGroupName() {
    _groupName = '';

    notifyListeners();
  }

  void addCurrentWeek(String value) {
    _week = value;
    notifyListeners();
  }

  void changeWeek(String weekOnTap) {
    weekOnTap == '1' ? _week = '2' : _week = '1';
    notifyListeners();
  }
}
