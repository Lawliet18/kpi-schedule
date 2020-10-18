import 'dart:convert';

import 'package:http/http.dart' as http;

Future<int> fetchCurrentWeek() async {
  try {
    final responce = await http.get('https://api.rozklad.org.ua/v2/weeks');
    final parsed = jsonDecode(responce.body);
    return parsed['data'];
  } catch (e) {
    print(e);
    print('something wrong in weeks');
    return null;
  }
}
