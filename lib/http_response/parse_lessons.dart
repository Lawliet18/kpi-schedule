import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/lessons.dart';

Future<List<Lessons>> fetchLessons(String text) async {
  try {
    final response = await http
        .get(Uri.https('api.rozklad.org.ua', 'v2/groups/$text/lessons'));
    if (response.statusCode == 200) {
      final data = response.body;
      final parsed = jsonDecode(data);
      final parsedData = parsed['data'];
      return parsedData.map<Lessons>((json) => Lessons.fromJson(json)).toList();
    }
  } on http.ClientException catch (_) {
    rethrow;
  }
  return [];
}
