// class ApiResponse {
//   final List<BillData> data;

//   ApiResponse({required this.data});

//   factory ApiResponse.fromJson(Map<String, dynamic> json) {
//     final List<dynamic> dataList = json['data'];
//     final List<BillData> data =
//         dataList.map((item) => BillData.fromJson(item)).toList();
//     return ApiResponse(data: data);
//   }
// }

// class BillData {
//   final int id;
//   final num total;
//   final num totalQuantity;
//   final DateTime date;
//   final List<BillCategory> billCategories;
//   final SellPoint sellPoint;

//   BillData({
//     required this.id,
//     required this.total,
//     required this.totalQuantity,
//     required this.date,
//     required this.billCategories,
//     required this.sellPoint,
//   });

//   factory BillData.fromJson(Map<String, dynamic> json) {
//     final List<dynamic> billCategoriesList = json['bill_categories'];
//     final List<BillCategory> billCategories =
//         billCategoriesList.map((item) => BillCategory.fromJson(item)).toList();

//     return BillData(
//       id: json['id'],
//       total: json['total'],
//       totalQuantity: json['total_quantity'],
//       date: DateTime.parse(json['date']),
//       billCategories: billCategories,
//       sellPoint: SellPoint.fromJson(json['sell_point']),
//     );
//   }
// }

// class BillCategory {
//   final int id;
//   final int amount;
//   final num totalPrice;
//   final Category category;

//   BillCategory({
//     required this.id,
//     required this.amount,
//     required this.totalPrice,
//     required this.category,
//   });

//   factory BillCategory.fromJson(Map<String, dynamic> json) {
//     return BillCategory(
//       id: json['id'],
//       amount: json['amount'],
//       totalPrice: json['total_price'],
//       category: Category.fromJson(json['category']),
//     );
//   }
// }

// class Category {
//   final int id;
//   final String nameAr;
//   final String nameEn;
//   final num price;

//   Category({
//     required this.id,
//     required this.nameAr,
//     required this.nameEn,
//     required this.price,
//   });

//   factory Category.fromJson(Map<String, dynamic> json) {
//     return Category(
//       id: json['id'],
//       nameAr: json['name_ar'],
//       nameEn: json['name_en'],
//       price: json['price'].toDouble(),
//     );
//   }
// }

// class SellPoint {
//   final int id;
//   final String name;
//   final School school;
//   final Driver driver;
//   final Promoter promoter;

//   SellPoint({
//     required this.id,
//     required this.name,
//     required this.school,
//     required this.driver,
//     required this.promoter,
//   });

//   factory SellPoint.fromJson(Map<String, dynamic> json) {
//     return SellPoint(
//       id: json['id'],
//       name: json['name'],
//       school: School.fromJson(json['school']),
//       driver: Driver.fromJson(json['driver']),
//       promoter: Promoter.fromJson(json['promoter']),
//     );
//   }
// }

// class School {
//   final int id;
//   final String nameAr;
//   final String nameEn;
//   final String type;

//   School({
//     required this.id,
//     required this.nameAr,
//     required this.nameEn,
//     required this.type,
//   });

//   factory School.fromJson(Map<String, dynamic> json) {
//     return School(
//       id: json['id'],
//       nameAr: json['name_ar'],
//       nameEn: json['name_en'],
//       type: json['type'],
//     );
//   }
// }

// class Driver {
//   final int id;
//   final String nameAr;
//   final String nameEn;
//   final String phone;

//   Driver({
//     required this.id,
//     required this.nameAr,
//     required this.nameEn,
//     required this.phone,
//   });

//   factory Driver.fromJson(Map<String, dynamic> json) {
//     return Driver(
//       id: json['id'],
//       nameAr: json['name_ar'],
//       nameEn: json['name_en'],
//       phone: json['phone'],
//     );
//   }
// }

// class Promoter {
//   final int id;
//   final String nameAr;
//   final String nameEn;
//   final String phone;

//   Promoter({
//     required this.id,
//     required this.nameAr,
//     required this.nameEn,
//     required this.phone,
//   });

//   factory Promoter.fromJson(Map<String, dynamic> json) {
//     return Promoter(
//       id: json['id'],
//       nameAr: json['name_ar'],
//       nameEn: json['name_en'],
//       phone: json['phone'],
//     );
//   }
// }
