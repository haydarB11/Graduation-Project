import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shamseenfactory/constants.dart';

import 'percentage_model.dart';

class ApiService {
 

  Future<List<School>> fetchSchools(DateTime startDate, DateTime endDate, String type) async {
    final url = Uri.parse('$baseUrl/bill/balance/get-all');
    final formattedStartDate = DateFormat('yyyy-MM-dd', 'en').format(startDate);
    final formattedEndDate = DateFormat('yyyy-MM-dd', 'en').format(endDate);
    
    if (endDate.isBefore(startDate)) {
      throw Exception('End date cannot be before start date');
    }

    print('API Request Date: $formattedStartDate - $formattedEndDate');

    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'start': formattedStartDate,
          'end': formattedEndDate,
          'type': type,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      print('API Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body)['data'];
        final schools = jsonData.map((school) => School.fromJson(school)).toList();

        // Debug: Print the school list
        print('School List:');
        for (final school in schools) {
          print('Name: ${school.nameEn}');
          // Print other relevant fields

          if (school.sellPoints != null && school.sellPoints.isNotEmpty) {
            // Access properties of the 'sellPoints' array here
            for (final sellPoint in school.sellPoints) {
              print('Driver: ${sellPoint.driver.nameEn}');
              print('Promoter: ${sellPoint.promoter.nameEn}');
              // Access other properties of 'sellPoint'
            }
          } else {
            // Handle the case where 'sellPoints' is null or empty
            print('No sell points available for this school.');
          }
        }

        return schools;
      } else {
        print('API Error: Failed to fetch schools');
        throw Exception('Failed to fetch schools');
      }
    } catch (e) {
      print('API Error: $e');
      throw Exception('Failed to fetch schools');
    }
  }
}
