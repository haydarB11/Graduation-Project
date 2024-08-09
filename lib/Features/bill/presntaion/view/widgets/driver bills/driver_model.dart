class Driver {
  final int id;
  final String nameAr;
  final String nameEn;

  final String password;
  final String phone;
  final List<SellPoint> sellPoints;

  Driver({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.password,
    required this.phone,
    required this.sellPoints,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'] ?? 0, // Provide default value (0 in this case)
      nameAr: json['name_ar'] ??
          '', // Provide default value (empty string in this case)
      nameEn: json['name_en'] ??
          '', // Provide default value (empty string in this case)

      password: json['password'] ??
          '', // Provide default value (empty string in this case)
      phone: json['phone'] ??
          '', // Provide default value (empty string in this case)
      sellPoints: (json['sell_points'] as List<dynamic>?)
              ?.map((sellPointJson) => SellPoint.fromJson(sellPointJson))
              .toList() ??
          [],
    );
  }
}

class SellPoint {
  final int id;
  final String name;
  final Promoter? promoter;
  final School? school;
  final List<Bill> bills;

  SellPoint({
    required this.id,
    required this.name,
    this.promoter,
    this.school,
    required this.bills,
  });

  factory SellPoint.fromJson(Map<String, dynamic> json) {
    return SellPoint(
      id: json['id'] ?? 0, // Provide default value (0 in this case)
      name: json['name'] ??
          '', // Provide default value (empty string in this case)
      promoter:
          json['promoter'] != null ? Promoter.fromJson(json['promoter']) : null,
      school: json['school'] != null ? School.fromJson(json['school']) : null,
      bills: (json['bills'] as List<dynamic>?)
              ?.map((billJson) => Bill.fromJson(billJson))
              .toList() ??
          [],
    );
  }
}

class Promoter {
  final String nameAr;
  final String nameEn;

  final String phone;

  Promoter({
    required this.nameAr,
    required this.nameEn,
    required this.phone,
  });

  factory Promoter.fromJson(Map<String, dynamic> json) {
    return Promoter(
      nameAr: json['name_ar'] ??
          '', // Provide default value (empty string in this case)
      nameEn: json['name_en'] ??
          '', // Provide default value (empty string in this case)

      phone: json['phone'] ??
          '', // Provide default value (empty string in this case)
    );
  }
}

class School {
  final int id;
  final String nameAr;
  final String nameEn;
  final String region;
  final String type;

  School({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.region,
    required this.type,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'],
      nameAr: json['name_ar'] ??
          '', // Provide default value (empty string in this case)
      nameEn: json['name_en'] ??
          '', // Provide default value (empty string in this case)
      region: json['region'] ??
          '', // Provide default value (empty string in this case)
      type: json['type'] ??
          'school', // Provide default value (empty string in this case)
    );
  }
}

class Bill {
  final int id;
  final List<BillCategory> billCategories;
  final num total;
  final int totalQuantity;
  final String date;

  Bill({
    required this.id,
    required this.billCategories,
    required this.total,
    required this.totalQuantity,
    required this.date,
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'],
      billCategories: (json['bill_categories'] as List)
          .map((categoryJson) => BillCategory.fromJson(categoryJson))
          .toList(),
      total: json['total'] ?? 0, // Provide a default value (0 in this case)
      totalQuantity: json['total_quantity'] ??
          0, // Provide a default value (0 in this case),
      date: json['date'] ?? "",
    );
  }
}

class BillCategory {
  final int id;
  final int amount;
  final num totalPrice;
  final Category category; // Reference to the Category class

  BillCategory({
    required this.id,
    required this.amount,
    required this.totalPrice,
    required this.category,
  });

  factory BillCategory.fromJson(Map<String, dynamic> json) {
    return BillCategory(
      id: json['id'],
      amount: json['amount'] ?? 0, // Provide a default value (0 in this case)
      totalPrice: json['total_price'] ?? 0, // Provide a default value (0 in this case)
      category: Category.fromJson(json['category'] ?? {}),
    );
  }
}

class Category {
  final int id;
  final String nameAr;
  final String nameEn;
  final num price;

  Category({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.price,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'] ?? '',
      price: json['price'] ?? 0, // Provide a default value (0 in this case)
    );
  }
}
