import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shamseenfactory/constants.dart';

import 'school_bills_model.dart';

class ApiService {
  Future<List<School>> fetchBillsByDateAndSchool(
      DateTime selectedDate, String isR) async {
    try {
      final DateFormat formatter = DateFormat('yyyy-MM-dd', 'en');
      final String formattedDate = formatter.format(selectedDate);

      final response = await http.post(
        Uri.parse('$baseUrl/bill/schools/get-all'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'date': formattedDate, 'type': isR}),
      );

      print(jsonEncode({'date': formattedDate, 'type': isR}));

      print(response.statusCode);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<School> fetchedSchools = [];
        if (jsonData['data'] != null) {
          for (var schoolData in jsonData['data']) {
            fetchedSchools.add(School.fromJson(schoolData));
          }
        }

        return fetchedSchools;
      } else {
        print('API Error: ${response.reasonPhrase}');
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      print('API Error: $error');
      throw Exception('Failed to fetch data');
    }
  }
}
