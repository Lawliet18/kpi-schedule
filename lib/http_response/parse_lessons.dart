import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:schedule_kpi/Models/lessons.dart';

Future<List<Lessons>?> fetchLessons(String text) async {
  final List<Lessons> list = [];
  try {
    final response =
        await http.get('https://api.rozklad.org.ua/v2/groups/$text/lessons');
    if (response.statusCode == 200) {
      final String data = response.body;
      final parsed = jsonDecode(data);
      list.addAll(parsed['data']
          .map<Lessons>((Map<String, dynamic> json) => Lessons.fromJson(json))
          .toList() as Iterable<Lessons>);
      return list;
    }
  } catch (e) {
    rethrow;
  }
}
