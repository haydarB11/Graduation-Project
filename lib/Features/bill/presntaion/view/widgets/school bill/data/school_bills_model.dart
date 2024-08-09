class School {
  final int id;
  final String nameAr;
  final String nameEn;
  final String region;
  final String type;

  final List<SellPoint> sellPoints;

  School({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.region,
    required this.type,
    required this.sellPoints,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    List<SellPoint> sellPoints = [];
    if (json['sell_points'] != null) {
      for (var sellPointData in json['sell_points']) {
        sellPoints.add(SellPoint.fromJson(sellPointData));
      }
    }

    return School(
      id: json['id'] ?? 0,
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'] ?? '',
      region: json['region'] ?? '',
      type: json['type'] ?? '',
      sellPoints: sellPoints,
    );
  }
}

class SellPoint {
  final int id;
  final String name;
  final List<Bill> bills;
  final int total;
  final int total_quantity;
  final String driverName;
  final String promoterName;

  SellPoint({
    required this.total,
    required this.total_quantity,
    required this.id,
    required this.name,
    required this.bills,
    required this.driverName,
    required this.promoterName,
  });

  factory SellPoint.fromJson(Map<String, dynamic> json) {
    List<Bill> bills = [];
    if (json['bills'] != null) {
      for (var billData in json['bills']) {
        bills.add(Bill.fromJson(billData));
      }
    }
    final driverName = json['driver']?['name_ar'] ?? 'Unknown Driver';
    final promoterName = json['promoter']?['name_ar'] ?? 'Unknown Promoter';

    return SellPoint(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      total: json['total'] ?? 0,
      total_quantity: json['total_quantity'] ?? 0,
      bills: bills,
      driverName: driverName,
      promoterName: promoterName,
    );
  }
}

class Bill {
  final int id;
  final num total;
  final int totalquantity;
  final date;
  final List<BillCategory> billCategories;

  Bill(
      {required this.date,
      required this.id,
      required this.billCategories,
      required this.total,
      required this.totalquantity});

  factory Bill.fromJson(Map<String, dynamic> json) {
    List<BillCategory> billCategories = [];
    if (json['bill_categories'] != null) {
      for (var categoryData in json['bill_categories']) {
        billCategories.add(BillCategory.fromJson(categoryData));
      }
    }

    return Bill(
      id: json['id'] ?? 0,
      total: json['total'] != null ? num.parse(json['total'].toString()) : 0,
      totalquantity: json['total_quantity'] ?? 0,
      date: json['date'] ?? "",
      billCategories: billCategories,
    );
  }
}

class BillCategory {
  final int id;
  final int amount;
  final num totalPrice;
  final Category category;

  BillCategory({
    required this.id,
    required this.amount,
    required this.totalPrice,
    required this.category,
  });

  factory BillCategory.fromJson(Map<String, dynamic> json) {
    return BillCategory(
      id: json['id'] ?? 0,
      amount: json['amount'] ?? 0,
      totalPrice: json['total_price'] != null
          ? num.parse(json['total_price'].toString())
          : 0,
      category: Category.fromJson(json['category'] ?? {}),
    );
  }
}

class Category {
  final int id;
  final String nameAr;
  final String nameEn;
  final double price;
  final String photo;
  final String source;
  final String type;
  final String schoolType;
  final bool visibility;

  Category({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.price,
    required this.photo,
    required this.source,
    required this.type,
    required this.schoolType,
    required this.visibility,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    final priceValue = json['price'];
    double parsedPrice = priceValue is num ? priceValue.toDouble() : 0.0;

    return Category(
      id: json['id'] ?? 0,
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'] ?? '',
      price: parsedPrice,
      photo: json['photo'] ?? '',
      source: json['source'] ?? '',
      type: json['type'] ?? '',
      schoolType: json['school_type'] ?? '',
      visibility: json['visibility'] ?? false,
    );
  }
}
