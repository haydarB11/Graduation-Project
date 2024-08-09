import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shamseenfactory/constants.dart';

class School {
  final int id;
  final String? nameAr;

  School({required this.id, required this.nameAr});
  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'] ?? 0,
      nameAr: json['name'],
    );
  }
}

class SchoolsApi {
  static Future<List<School>> getAllSchools() async {
    try {
      var url = Uri.parse('$baseUrl/sell-points/all');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body)['data'];
        final List<School> schools =
            jsonData.map((item) => School.fromJson(item)).toList();
        return schools;
      } else {
        throw Exception(
            'Request failed with status: ${response.statusCode}, Reason: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
