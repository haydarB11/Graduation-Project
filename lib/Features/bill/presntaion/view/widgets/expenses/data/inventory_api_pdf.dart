import 'dart:convert';

import '../../../../../../../constants.dart';
import 'niverntories_mode_pdf.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class InventoryApi {
  static Future<List<InventoryData>> fetchInventoryData(
      DateTime startDate, DateTime endDate) async {
    final url = Uri.parse('$baseUrl/inventory/all');
    var formattedFDate = DateFormat('yyyy-MM-dd', 'en').format(startDate);
    var formattedSDate = DateFormat('yyyy-MM-dd', 'en').format(endDate);
    final requestBody = {'start': formattedFDate, 'end': formattedSDate};
    print(jsonEncode(requestBody));
    final response = await http.post(
      url,
      body: jsonEncode(requestBody),
      headers: {'Content-Type': 'application/json'},
    );
    print(jsonEncode(requestBody));
    print(response.statusCode);
    print(response.reasonPhrase);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final data = jsonResponse['data'] as List<dynamic>;

      return data.map((json) => InventoryData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load inventory data');
    }
  }
}
