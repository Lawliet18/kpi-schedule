import 'dart:convert';

import 'package:http/http.dart' as http;
import '../Models/teacher_schedule_model.dart';

Future<Map<String, List<TeacherSchedules>>?> fetchTeacherSchedule(
    List<String> names) async {
  final forHttp = <String>[];
  final teachersMap = <String, List<TeacherSchedules>>{};
  try {
    for (var i = 0; i < names.length; i++) {
      forHttp.add(names[i]);
      names[i].split(' ').join('+');
      final responce = await http.get(
          Uri.https('api.rozklad.org.ua', 'v2/teachers/${names[i]}/lessons'));
      if (responce.statusCode == 200) {
        final parsed = jsonDecode(responce.body);
        final parsedData = parsed['data'];
        teachersMap[forHttp[i]] = parsedData
            .map<TeacherSchedules>((json) => TeacherSchedules.fromJson(json))
            .toList();
      }
    }
    return teachersMap;
  } on http.ClientException catch (_) {
    rethrow;
  }
}
