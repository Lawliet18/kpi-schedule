import 'dart:convert';

import 'package:http/http.dart' as http;

Future<int> fetchCurrentWeek() async {
  try {
    final responce =
        await http.get(Uri.https('api.rozklad.org.ua', 'v2/weeks'));
    final parsed = jsonDecode(responce.body);
    final parsedData = parsed['data'];
    return parsedData;
  } on http.ClientException catch (_) {
    rethrow;
  }
}
