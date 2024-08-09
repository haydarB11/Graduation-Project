import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import '../../../../../../../constants.dart';

class SchoolBill {
  final int id;
  final num totalPrice; //مبلغ المرتجعات الكلي
  final num totalAmount; // بلاه
  final num totalExpenses; // مبلع العينات الكلي
  final List<InventoryCategory> inventoryCategory;

  SchoolBill({
    required this.id,
    required this.totalPrice,
    required this.totalAmount,
    required this.totalExpenses,
    required this.inventoryCategory,
  });
  factory SchoolBill.fromJson(Map<String, dynamic> json) {
    // Parse inventory_category
    final List<dynamic> categoryList = json['inventory_category'] ?? [];
    final List<InventoryCategory> inventoryCategories = categoryList
        .map((categoryJson) => InventoryCategory.fromJson(categoryJson))
        .toList();

    return SchoolBill(
      id: json['id'] ?? 0,
      totalPrice: (json['total_price'] ?? 0.0).toDouble(),
      totalAmount: (json['total_amount'] ?? 0.0).toDouble(),
      totalExpenses: (json['total_expenses'] ?? 0.0).toDouble(),
      inventoryCategory: inventoryCategories,
    );
  }
}

class InventoryCategory {
  final int id;
  final num amount; //عدد المرتجعات
  final num spExpenses; //عدد العينات
  final Category? category;

  InventoryCategory({
    required this.id,
    required this.amount,
    required this.spExpenses,
    this.category,
  });
  num calculateAmountTotalPrice() {
    // Assuming that 'price' is the price of the category
    return (amount * (category?.price ?? 0.0));
  }

  // Calculate the total price based on spExpenses
  num calculateSpExpensesTotalPrice() {
    // Assuming that 'price' is the price of the category
    return (spExpenses * (category?.price ?? 0.0));
  }

  factory InventoryCategory.fromJson(Map<String, dynamic> json) {
    Category? category;

    if (json['category'] != null) {
      category = Category.fromJson(json['category']);
    }

    return InventoryCategory(
      id: json['id'] ?? 0,
      amount: (json['amount'] ?? 0.0).toDouble(),
      spExpenses: (json['sp_expenses'] ?? 0.0).toDouble(),
      category: category,
    );
  }
}

class Category {
  final int id;
  final String? nameAr;
  final String? nameEn;
  final num price;

  Category({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.price,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      nameAr: json['name_ar'] ?? "",
      nameEn: json['name_en'] ?? "",
      price: (json['price'] ?? 0.0).toDouble(),
    );
  }
}
//74
class ApiManager {

  Future<List<SchoolBill>> fetchSchoolBillData(
      DateTime startDate, DateTime endDate, int id) async {
    
    final Uri uri = Uri.parse('$baseUrl/inventory/by/$id');
    print(uri);
    try {
      final DateFormat formatter = DateFormat('yyyy-MM-dd', 'en');
      final String formattedStartDate = formatter.format(startDate);
      final String formattedEndDate = formatter.format(endDate);
      print(id);
      final response = await http.post(
        Uri.parse('$baseUrl/inventory/by/$id'),
        headers: {'Content-Type': 'application/json'},
        body:
            jsonEncode({'start': formattedStartDate, 'end': formattedEndDate}),
      );
      if (kDebugMode) {
        print(response.statusCode);
        print(response.body);
      }

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<SchoolBill> fetchDate = [];
        if (jsonData['data'] != null) {
          final data = jsonData['data'] as List<dynamic>; // Ensure it's a list
          for (var schoolbill in data) {
            fetchDate.add(SchoolBill.fromJson(schoolbill));
          }
        } else {
          print("jsonData['data'] is null"); // Handle this case accordingly
        }

        return fetchDate;
      } else {
        print('API Error: ${response.reasonPhrase}');
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print('API Error: $e');
      print("I am in catch in Api");
      throw Exception('Failed to fetch data');
    }
  }
}
