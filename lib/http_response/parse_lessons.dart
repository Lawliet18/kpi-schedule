import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:schedule_kpi/Models/lessons.dart';

Future<List<Lessons>?> fetchLessons(String text) async {
  try {
    final response = await http
        .get(Uri.https('api.rozklad.org.ua', 'v2/groups/$text/lessons'));
    if (response.statusCode == 200) {
      final String data = response.body;
      final parsed = jsonDecode(data);
      final parsedData = parsed['data'] as List;
      return parsedData
          .map((json) => Lessons.fromJson(json as Map<String, dynamic>))
          .toList();
    }
  } catch (e) {
    print(e);
    rethrow;
  }
}
