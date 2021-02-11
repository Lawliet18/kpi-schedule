import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:schedule_kpi/particles/current_week.dart';

class Notifier with ChangeNotifier {
  String _groupName = '';
  String get groupName => _groupName;

  Week _currentWeek = Week.First;
  Week get currentWeek => _currentWeek;

  Week _week = Week.First;
  Week get week => _week;

  String _textData = '';

  String get textData => _textData;

  bool _editingType = true;
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

  void addImagePath(String path) {
    final imageList = path.split(' ');
    if (imageList.length > 1) {
      _list.addAll(imageList);
    }
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

  void notifier() {
    notifyListeners();
  }

  void setWeek(Week value) {
    _currentWeek = value;
  }
}
