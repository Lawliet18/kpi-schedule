import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:schedule_kpi/Models/teacher_schedule_model.dart';

Future<Map<String, List<TeacherSchedules>>?> fetchTeacherSchedule(
    List<String> names) async {
  final List<String> forHttp = [];
  final Map<String, List<TeacherSchedules>> teachersMap = {};
  try {
    for (var i = 0; i < names.length; i++) {
      forHttp.add(names[i]);
      names[i].split(' ').join('+');
      final responce = await http
          .get('https://api.rozklad.org.ua/v2/teachers/${names[i]}/lessons');
      if (responce.statusCode == 200) {
        final parsed = jsonDecode(responce.body);
        teachersMap[forHttp[i]] = parsed['data']
            .map((Map<String, dynamic> json) => TeacherSchedules.fromJson(json))
            .toList() as List<TeacherSchedules>;
      }
    }
    return teachersMap;
  } catch (e) {
    rethrow;
  }
}
