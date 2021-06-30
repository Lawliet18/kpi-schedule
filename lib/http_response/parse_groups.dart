import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../Models/groups.dart';

Future<List<Groups>> fetchGroups() async {
  final list = <Groups>[];
  try {
    final responseForMeta = await getGroupsMeta();
    if (responseForMeta.statusCode == 200) {
      final length = jsonDecode(responseForMeta.body)['meta']['total_count'];
      final parsedToInt = int.tryParse(length) ?? 2400;
      for (var i = 0; i <= parsedToInt; i += 100) {
        final parameters = {'filter': '{limit:100,offset:$i}'};
        final url =
            'https://api.rozklad.org.ua/v2/groups/?filter={%27limit%27:100,%27offset%27:$i}';
        final response = await getGroups(parameters, url);
        list.addAll(groupFromJson(jsonDecode(response)['data'] ?? []));
      }
    }
  } on http.ClientException catch (_) {
    rethrow;
  }
  return list;
}

Future<http.Response> getGroupsMeta() =>
    http.get(Uri.https('api.rozklad.org.ua', 'v2/groups'));

Future<String> getGroups(Map<String, dynamic> parameters, String url) =>
    apiRequest(url, parameters);

Iterable<Groups> groupFromJson(List parsedData) =>
    parsedData.map((json) => Groups.fromJson(json));

Future<String> apiRequest(String url, Map jsonMap) async {
  final httpClient = HttpClient();
  final request = await httpClient.postUrl(Uri.parse(url));
  request.headers.set('content-type', 'application/json');
  request.add(utf8.encode(json.encode(jsonMap)));
  final response = await request.close();
  if (response.statusCode == 200) {
    final reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    return reply;
  }
  return '';
}
