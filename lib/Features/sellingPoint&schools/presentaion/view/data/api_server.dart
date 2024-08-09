import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shamseenfactory/Features/sellingPoint&schools/presentaion/view/data/school_model.dart';
import 'package:shamseenfactory/constants.dart';

class ApiService {
  static Future<List<School>> fetchAllSchools() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/schools/'));

      print('API get school Status Code: ${response.statusCode}');
      print(
          'API Response get school : ${response.statusCode}\n${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<School> schools = (jsonData['data'] as List)
            .map((schoolData) => School.fromJson(schoolData))
            .toList();

        return schools;
      } else {
        final errorMessage =
            json.decode(response.body)['message'] ?? 'Failed to load schools';
        print(errorMessage);
        return [];
      }
    } catch (error) {
      print('$error');
      return [];
    }
  }

  static Future<void> deleteSchool(int schoolId) async {
    final url = Uri.parse('$baseUrl/managers/school/delete/$schoolId');

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final response = await http.delete(url, headers: headers);
    print('API delete school Status Code: ${response.statusCode}');

    if (response.statusCode == 200) {
      print('School deleted successfully');
    } else {
      print('Failed to delete school: ${response.reasonPhrase}');
    }
  }

  static Future<void> addSchool({
    required String nameArabic,
    required String nameEnglish,
    required String region,
    required String type,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/schools/'),
        body: jsonEncode({
          'name_ar': nameArabic,
          'name_en': nameEnglish,
          'type': type,
          'region': region,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print("add schoool");
        // School added successfully, no need to return a value here
      } else {
        final errorMessage =
            json.decode(response.body)['message'] ?? 'Failed to add school';
        print(errorMessage);
      }
    } catch (error) {
      print('$error');
    }
  }

  //* sales point Api

  static Future<List<SellPoint>> fetchAllSellPoints() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/managers/sell-points/get-all'));
      print('API fetchAllSellPoints Status Code: ${response.statusCode}');
      print(
          'API Response fetchAllSellPoints: ${response.statusCode}\n${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data']; // Corrected line

        if (data != null) {
          final List<SellPoint> sellPoints = data
              .map((sellPointData) => SellPoint.fromJson(sellPointData))
              .cast<SellPoint>()
              .toList();
          return sellPoints;
        } else {
          print('Response does not contain "data" key or "data" is null.');
        }
      } else {
        final errorMessage = json.decode(response.body)['message'] ??
            'Failed to load sell points';
        print(errorMessage);
      }
      return []; // Return an empty list if something goes wrong
    } catch (error) {
      print('$error');
      return [];
    }
  }

  static Future<void> deleteSellPoint(int sellPointId) async {
    final url = Uri.parse('$baseUrl/managers/sell-points/delete/$sellPointId');

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    final response = await http.delete(url, headers: headers);
    print('API delete school Status Code: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('sell point deleted successfully');
    } else {
      print('Failed to delete sell point: ${response.reasonPhrase}');
    }

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['data'] == 'deleted') {
        print('Sell point $sellPointId deleted successfully.');
      } else {
        print('Unknown response data: $responseData');
      }
    } else {
      print('Error deleting sell point: ${response.reasonPhrase}');
    }
  }

  static Future<List<dynamic>> fetchDrivers() async {
    final response = await http.get(Uri.parse('$baseUrl/drivers/'));
    // lientException (Connection closed before full header was received)

    if (response.statusCode == 200) {
      // final Map<String, dynamic> responseData = json.decode(response.body);
      // final List<Map<String, dynamic>> drivers = responseData['data'];
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> drivers = responseData['data'];
      return drivers;
    } else {
      throw Exception('Failed to fetch drivers');
    }
  }

  static Future<List<dynamic>> fetchPromoters() async {
    final response = await http.get(Uri.parse('$baseUrl/promoters/'));
// Exception has occurred.
// ClientException (Connection closed before full header was received)
    if (response.statusCode == 200) {
      // final Map<String, dynamic> responseData = json.decode(response.body);
      // final List<Map<String, dynamic>> drivers = responseData['data'];
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> drivers = responseData['data'];
      return drivers;
    } else {
      throw Exception('Failed to fetch drivers');
    }
  }

  static Future<void> addSellPoint({
    required String name,
    required String userName,
    required String password,
    required int? schoolId,
    required int? driverId,
    required int managerId,
    required int? promoterId,
  }) async {
    final Map<String, dynamic> sellPointData = {
      'name': name,
      'user': userName,
      'password': password,
      "school_id": schoolId,
      'driver_id': driverId,
      'manager_id': managerId,
      'promoter_id': promoterId,
    };

    final http.Response response = await http.post(
      Uri.parse('$baseUrl/sell-points/'),
      body: json.encode(sellPointData),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('Sell point added successfully');
      print(response.body);
    } else {
      print('Failed to add sell point: ${response.reasonPhrase}');
    }
  }
}
