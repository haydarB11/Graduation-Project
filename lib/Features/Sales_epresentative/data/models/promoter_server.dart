// Import your model
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shamseenfactory/Features/Sales_epresentative/data/models/promoter.dart';
import 'package:shamseenfactory/constants.dart';

class PromoterService {
  Future<List<Promoter>> fetchPromoters() async {
    final response = await http.get(Uri.parse('$baseUrl/promoters/'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<Promoter> promoters = (jsonData['data'] as List)
          .map((promotersdata) => Promoter.fromJson(promotersdata))
          .toList();
      return promoters; // Return the list of promoters here
    } else {
      throw Exception('Failed to load promoters');
    }
  }

  static Future<List<SellPoint>> fetchAllSellPointsPromoter(int pId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/sell-points/get-all-for-promoter/$pId'));
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

  static Future<List<SellPoint>> fetchAllSellPoints() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/managers/sell-points/get-all'));
      print("all ${response.statusCode}");
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

  static Future<void> sendUpdateRequest(
      {required int promoterId, required sellpointId}) async {
    try {
      final Map<String, dynamic> requestData = {
        "sell_point_id": sellpointId,
        "promoter_id": promoterId
      };
      final url = Uri.parse("$baseUrl/managers/sell-points/update");
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
    } catch (e) {
      print("erro from addsellpoint to P $e");
    }
  }

  // Implement addPromoter and deletePromoter methods here
}
