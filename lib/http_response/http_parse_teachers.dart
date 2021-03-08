import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:schedule_kpi/Models/teachers.dart';

Future<List<Teachers>?> fetchTeachers(String groupId) async {
  final List<Teachers> list = [];
  try {
    final responce = await http
        .get('https://api.rozklad.org.ua/v2/groups/$groupId/teachers');
    if (responce.statusCode == 200) {
      final parsed = jsonDecode(responce.body);
      list.addAll(parsed['data']
          .map((Map<String, dynamic> json) => Teachers.fromJson(json))
          .toList() as Iterable<Teachers>);
      return list;
    }
  } catch (e) {
    throw e.toString();
  }
}
