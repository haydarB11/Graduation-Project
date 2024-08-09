import 'package:shamseenfactory/constants.dart';

import 'school_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class SchoolApi {
  static Future<List<School>> fetchSchools() async {
  final response = await http.get(Uri.parse('$baseUrl/schools/get-all'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['data'];
    final List<School> schools = data.map((item) => School.fromJson(item)).toList();
    return schools;
  } else {
    throw Exception('Failed to load schools');
  }
}

}