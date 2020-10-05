import 'package:flutter/cupertino.dart';

class Notifier extends ChangeNotifier {
  String _groupName = '';

  String get groupName => _groupName;

  void addGroupName(String name) {
    _groupName = name;

    notifyListeners();
  }

  void removeGroupName() {
    _groupName = '';

    notifyListeners();
  }
}
