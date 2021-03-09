import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:schedule_kpi/Models/teachers.dart';

Future<List<Teachers>?> fetchTeachers(String groupId) async {
  try {
    final responce = await http
        .get(Uri.https('api.rozklad.org.ua', 'v2/groups/$groupId/teachers'));
    if (responce.statusCode == 200) {
      final parsed = jsonDecode(responce.body);
      final parsedData = parsed['data'] as List;
      return parsedData
          .map((json) => Teachers.fromJson(json as Map<String, dynamic>))
          .toList();
    }
  } catch (e) {
    rethrow;
  }
}
