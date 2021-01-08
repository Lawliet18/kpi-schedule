import 'dart:collection';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:schedule_kpi/particles/current_week.dart';

class Notifier with ChangeNotifier {
  String _groupName = '';
  String get groupName => _groupName;

  bool _darkModeOn = false;
  bool get darkModeOn => _darkModeOn;

  Week _week = Week.First;
  Week get week => _week;

  String _textData = '';

  String get textData => _textData;

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

  void addTextData(String text) {
    _textData = text;
    notifyListeners();
  }

  void darkMode(bool darkMode) {
    _darkModeOn = darkMode;
    notifyListeners();
  }

  void removeGroupName() {
    _groupName = '';
  }

  void addCurrentWeek(Week value) {
    _week = value;
  }

  void changeWeek(Week weekOnTap) {
    _week = weekOnTap.invert();
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

  void clearimagePath() {
    _list.clear();
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
