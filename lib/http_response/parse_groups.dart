import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:schedule_kpi/Models/groups.dart';

Future<List<Groups>> fetchGroups() async {
  final list = <Groups>[];
  try {
    for (var i = 100; i <= 2400; i += 100) {
      final parameters = {"filter": "{limit:100,offset:$i}"};
      final response = await http
          .get(Uri.https('api.rozklad.org.ua', 'v2/groups', parameters));
      if (response.statusCode == 200) {
        final data = response.body;
        final parsed = jsonDecode(data);
        final parsedData = parsed['data'] as List;
        list.addAll(parsedData
            .map((json) => Groups.fromJson(json as Map<String, dynamic>))
            .toList());
      }
    }
  } catch (e) {
    rethrow;
  }
  return list;
}
