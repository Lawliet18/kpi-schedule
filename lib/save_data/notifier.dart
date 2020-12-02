import 'dart:collection';
import 'dart:io';

import 'package:flutter/cupertino.dart';

class Notifier with ChangeNotifier {
  String _groupName = '';
  String get groupName => _groupName;

  bool _darkModeOn = false;
  bool get darkModeOn => _darkModeOn;

  String _week = '1';
  String get week => _week;

  List<bool> _textFieldCounter = [];
  UnmodifiableListView<bool> get textFieldCounter =>
      UnmodifiableListView(_textFieldCounter);

  List<String> _list = [];
  UnmodifiableListView<String> get list => UnmodifiableListView(_list);

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
  }

  void addCurrentWeek(String value) {
    _week = value;
    notifyListeners();
  }

  void changeWeek(String weekOnTap) {
    weekOnTap == '1' ? _week = '2' : _week = '1';
    notifyListeners();
  }

  void addTextField() {
    _textFieldCounter.add(true);
    notifyListeners();
  }

  void addImagePath(String path) {
    _list.add(path);
    notifyListeners();
  }

  void deleteImagePath(int index) {
    _list.removeAt(index);
    notifyListeners();
  }

  void deleteTextField(int index) {
    _textFieldCounter[index] = false;
    notifyListeners();
  }
}
