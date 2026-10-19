import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<dynamic>> getUsers() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/users'),
  );

  print(response.statusCode);
  print(response.body);

  if (response.statusCode == 200) {
    final users = jsonDecode(response.body);
    if (users is List<dynamic>) {
      return users;
    }
    throw const FormatException('Expected a list of users');
  }

  throw Exception('API Error');
}
