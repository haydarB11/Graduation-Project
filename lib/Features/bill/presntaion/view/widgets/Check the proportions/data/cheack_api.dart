import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../../../../../constants.dart';
import '../../Check the proportions/data/cheack_model.dart';

class Api {
  // final String baseUrl = 'https://timeengcom.com/shamseen/bill/balance/check';

  static Future<List<SchoolData>> fetchData(
    DateTime startDate,
    DateTime startDateE,
  ) async {
    var formattedSDate = DateFormat('yyyy-MM-dd', 'en').format(startDate);
    var formattedEDate = DateFormat('yyyy-MM-dd', 'en').format(startDateE);
    final requestBody = {'start': formattedSDate, 'end': formattedEDate};
    final requestBodyDate = {
      'date': formattedSDate,
    };
    final fRequestBody =
        formattedSDate == formattedEDate ? requestBodyDate : requestBody;

    print(fRequestBody);
    final url = Uri.parse("$baseUrl/bill/balance/check");
    final header = {'Content-Type': 'application/json'};
    final response =
        await http.post(url, body: jsonEncode(fRequestBody), headers: header);
    if (kDebugMode) {
      print(jsonEncode(fRequestBody));
      print(response.statusCode);
      // print(jsonEncode(requestBody));
    }
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final data = jsonResponse['data'] as List<dynamic>;
      return data.map((e) => SchoolData.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch data: ${response.reasonPhrase}');
    }
  }
}
