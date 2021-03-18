import 'dart:convert';

import 'package:http/http.dart' as http;
import '../Models/teachers.dart';

Future<List<Teachers>> fetchTeachers(String groupId) async {
  try {
    final responce = await http
        .get(Uri.https('api.rozklad.org.ua', 'v2/groups/$groupId/teachers'));
    if (responce.statusCode == 200) {
      final parsed = jsonDecode(responce.body);
      final parsedData = parsed['data'];
      print(parsedData);
      return parsedData
          .map<Teachers>((json) => Teachers.fromJson(json))
          .toList();
    }
  } on Exception catch (_) {
    rethrow;
  }
  return [];
}
