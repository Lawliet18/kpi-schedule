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

  bool _textFieldValue = false;
  bool get textFieldValue => _textFieldValue;

  bool _editingType = false;
  bool get editingType => _editingType;

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
    _textFieldValue = !_textFieldValue;
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

  void changeEditingType() {
    _editingType = !editingType;
    notifyListeners();
  }
}
