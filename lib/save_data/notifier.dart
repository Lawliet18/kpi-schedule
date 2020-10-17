import 'package:flutter/cupertino.dart';

class Notifier with ChangeNotifier {
  String _groupName = '';
  String get groupName => _groupName;

  bool _darkModeOn = false;
  bool get darkModeOn => _darkModeOn;

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
}
