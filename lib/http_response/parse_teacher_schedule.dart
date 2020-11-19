import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:schedule_kpi/Models/teacher_schedule_model.dart';

Future<List<TeacherSchedules>> fetchTeacherSchedule(String name) async {
  try {
    name.split(' ')..join('+');
    final responce =
        await http.get('https://api.rozklad.org.ua/v2/teachers/$name/lessons');
    if (responce.statusCode == 200) {
      final parsed = jsonDecode(responce.body);
      return parsed['data']
          .map<TeacherSchedules>((json) => TeacherSchedules.fromJson(json))
          .toList();
    } else {
      return [];
    }
  } catch (e) {
    print(e);
    print('something wrong - fetchTeacherSchedule');
  }
  return [];
}
