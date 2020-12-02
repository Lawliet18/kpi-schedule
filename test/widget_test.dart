// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:schedule_kpi/Models/lessons.dart';

import 'package:schedule_kpi/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    List<Lessons> list1 = [
      Lessons(
          lessonId: '1',
          lessonName: 'we',
          lessonNumber: '12',
          lessonType: 'tr'),
      Lessons(
          lessonId: '1',
          lessonName: 'we',
          lessonNumber: '12',
          lessonType: 'tr'),
      Lessons(
          lessonId: '1',
          lessonName: 'we',
          lessonNumber: '12',
          lessonType: 'tr'),
      Lessons(
          lessonId: '1',
          lessonName: 'we',
          lessonNumber: '12',
          lessonType: 'tr'),
      Lessons(
          lessonId: '1',
          lessonName: 'we',
          lessonNumber: '12',
          lessonType: 'tr'),
    ];
    List<Lessons> list2 = [
      Lessons(
          lessonId: '1',
          lessonName: 'we',
          lessonNumber: '12',
          lessonType: 'tr'),
      Lessons(
          lessonId: '1',
          lessonName: 'we',
          lessonNumber: '12',
          lessonType: 'tr'),
      Lessons(
          lessonId: '1',
          lessonName: 'we',
          lessonNumber: '12',
          lessonType: 'tr'),
      Lessons(
          lessonId: '1',
          lessonName: 'wwerw',
          lessonNumber: '12',
          lessonType: 'tr'),
      Lessons(
          lessonId: '1',
          lessonName: 'we',
          lessonNumber: '12',
          lessonType: 'tr'),
    ];

    assert(listEquals(list1, list2) == false);
  });
}
