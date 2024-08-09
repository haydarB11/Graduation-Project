import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shamseenfactory/Features/driver/data/models/driver_model.dart';

import '../../../constants.dart';

class DriversApi {
  static Future<List<Driver>> fetchAllDrivers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/drivers/'));
      print("from get driver ${response.statusCode}");
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<Driver> drivers = (jsonData['data'] as List)
            .map((driverData) => Driver.fromJson(driverData))
            .toList();
        return drivers;
      } else {
        throw Exception('Failed to fetch drivers');
      }
    } catch (error) {
      throw Exception('An error occurred: $error');
    }
  }

  static Future<void> addDriver({
    required String nameAr,
    required String nameEn,
    required String user,
    required String password,
    required String phone,
  }) async {
    try {
      final Map<String, dynamic> requestData = {
        "name_ar": nameAr,
        "name_en": nameEn,
        "user": user,
        "password": password,
        "phone": phone,
      };

      final response = await http.post(Uri.parse('$baseUrl/drivers/register'),
          body: jsonEncode(requestData),
          headers: {'Content-Type': 'application/json'});
      print("this from add drive ${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        print("this add driver ${response.body}");
        // You can handle the new driver data here if needed
      } else {
        throw Exception('Failed to add driver');
      }
    } catch (error) {
      throw Exception('An error occurred: $error');
    }
  }

  static Future<void> deleteDriver(int driverId) async {
    try {
      final response =
          await http.delete(Uri.parse('$baseUrl/drivers/$driverId'));
      print(driverId);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['data'] == 'deleted') {
          // Do nothing here since we're not using a Cubit to manage state directly
        } else {
          throw Exception('Failed to delete driver');
        }
      } else {
        throw Exception('Failed to delete driver');
      }
    } catch (error) {
      throw Exception('An error occurred: $error');
    }
  }

  // static Future<List<SellPoint>> fetchAllSellPoints() async {
  //   try {
  //     final response =
  //         await http.get(Uri.parse('$baseUrl/managers/sell-points/get-all'));

  //     if (response.statusCode == 200) {
  //       final jsonData = json.decode(response.body);
  //       final List<SellPoint> sellPoints = (jsonData['data'] as List)
  //           .map((sellPointData) => SellPoint.fromJson(sellPointData))
  //           .toList();
  //       return sellPoints;
  //     } else {
  //       throw Exception('Failed to fetch sell points');
  //     }
  //   } catch (error) {
  //     throw Exception('An error occurred: $error');
  //   }
  // }
  static Future<List<SellPoint>> fetchAllSellPoints() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/managers/sell-points/get-all'),
          
          );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<SellPoint> sellPoints = (jsonData['data'] as List)
            .map((sellPointData) => SellPoint.fromJson(sellPointData))
            .toList();
        return sellPoints;
      } else {
        throw Exception('Failed to fetch sell points');
      }
    } on HandshakeException {
      throw Exception(
          'Failed to establish a secure connection. Please check your internet connection.');
    } catch (error) {
      print("error form fetch $error");
      throw Exception('An error occurred: $error');
    }
  }

  static Future<List<SellPoint>> fetchAllSellPointsDriver(int dId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/sell-points/get-all-for-driver/$dId'));
      print(response.statusCode);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<SellPoint> sellPoints = (jsonData['data'] as List)
            .map((sellPointData) => SellPoint.fromJson(sellPointData))
            .toList();
        return sellPoints;
      } else {
        throw Exception('Failed to fetch sell points');
      }
    } on HandshakeException {
      throw Exception(
          'Failed to establish a secure connection. Please check your internet connection.');
    } catch (error) {
      print("error form fetch $error");
      throw Exception('An error occurred: $error');
    }
  }

  static Future<void> addSellPointToDriver(
      {required int driverId, required List<int> ids}) async {
    try {
      final Map<String, dynamic> requestData = {
        "driver_id": driverId,
        "ids": ids
      };
      final url = Uri.parse('$baseUrl/managers/drivers/add-sell-points');

      print("this form addd${requestData}");
      final http.Response response = await http.put(url,
          body: jsonEncode(requestData),
          headers: {'Content-Type': 'application/json'});
      print("bode afte encode${response.body}\n");
      print("after encdoe $requestData");
      print("this form addd${response.statusCode}");
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['data'] == 'updated') {
          print("this addedd only");
          // Successfully added sell points, emit a state or perform any necessary actions
        } else {
          throw Exception('Failed to update data');
        }
      } else {
        throw HttpException(
            'HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (error) {
      throw error;
    }
  }
}
