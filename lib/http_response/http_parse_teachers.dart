import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:schedule_kpi/Models/teachers.dart';

Future<List> fetchTeachers(String groupId) async {
  List<Teachers> list = [];
  try {
    print(groupId);
    final responce =
        await http.get('http://api.rozklad.org.ua/v2/groups/$groupId/teachers');
    if (responce.statusCode == 200) {
      final parsed = jsonDecode(responce.body);
      print(parsed['data'][0]);
      list.addAll(parsed['data']
          .map<Teachers>((json) => Teachers.fromJson(json))
          .toList());
      return list;
    }
    return [];
  } catch (e) {
    print(e);
    print('fetch teacher error');
    return [];
  }
}
