import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:schedule_kpi/Models/groups.dart';

Future<List<Groups>> fetchGroups() async {
  List<Groups> list = [];
  for (var i = 100; i <= 2400; i += 100) {
    final response = await http.get(
        'https://api.rozklad.org.ua/v2/groups/?filter={%27limit%27:100,%27offset%27:$i}');
    if (response.statusCode == 200) {
      String data = response.body;
      final parsed = jsonDecode(data);
      list.addAll(
          parsed['data'].map<Groups>((json) => Groups.fromJson(json)).toList());
    } else {
      print('something wrong');
      print(response.statusCode);
    }
  }
  return list;
}
