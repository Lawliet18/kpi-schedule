import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:schedule_kpi/Models/lessons.dart';

Future<List> fetchLessons(String text) async {
  List<Lessons> list = [];
  try {
    final response =
        await http.get('https://api.rozklad.org.ua/v2/groups/$text/lessons');
    if (response.statusCode == 200) {
      String data = response.body;
      final parsed = jsonDecode(data);
      list.addAll(parsed['data']
          .map<Lessons>((json) => Lessons.fromJson(json))
          .toList());
      return list;
    }
    return null;
  } catch (e) {
    print(e);
    print('fecth lessons');
    return null;
  }
}
