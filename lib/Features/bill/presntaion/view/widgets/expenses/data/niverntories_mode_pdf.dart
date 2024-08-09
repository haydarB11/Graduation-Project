class InventoryData {
  final int id;
  final double totalPrice;
  final int totalAmount;
  final String date;
  final SellPoint sellPoint;
  final List<InventoryCategory> inventoryCategory;

  InventoryData({
    required this.id,
    required this.totalPrice,
    required this.totalAmount,
    required this.date,
    required this.sellPoint,
    required this.inventoryCategory,
  });

  factory InventoryData.fromJson(Map<String, dynamic> json) {
    return InventoryData(
      id: json['id'],
      totalPrice: json['total_price'].toDouble(),
      totalAmount: json['total_amount'],
      date: json['date'],
      sellPoint: SellPoint.fromJson(json['sell_point']),
      inventoryCategory: (json['inventory_category'] as List)
          .map((category) => InventoryCategory.fromJson(category))
          .toList(),
    );
  }
}

class SellPoint {
  final int id;
  final String name;
  final Driver driver;
  final Promoter promoter;

  SellPoint({
    required this.id,
    required this.name,
    required this.driver,
    required this.promoter,
  });

  factory SellPoint.fromJson(Map<String, dynamic> json) {
    return SellPoint(
      id: json['id'],
      name: json['name'],
      driver: Driver.fromJson(json['driver']),
      promoter: Promoter.fromJson(json['promoter']),
    );
  }
}

class Driver {
  final int id;
  final String nameAr;
  final String nameEn;
  final String phone;

  Driver({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.phone,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
      phone: json['phone'],
    );
  }
}

class Promoter {
  final int id;
  final String nameAr;
  final String nameEn;
  final String phone;

  Promoter({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.phone,
  });

  factory Promoter.fromJson(Map<String, dynamic> json) {
    return Promoter(
      id: json['id'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
      phone: json['phone'],
    );
  }
}

class InventoryCategory {
  final int id;
  final int amount;
  final Category category;

  InventoryCategory({
    required this.id,
    required this.amount,
    required this.category,
  });

  factory InventoryCategory.fromJson(Map<String, dynamic> json) {
    return InventoryCategory(
      id: json['id'],
      amount: json['amount'],
      category: Category.fromJson(json['category']),
    );
  }
}

class Category {
  final int id;
  final String nameAr;
  final String nameEn;
  final double price;

  Category({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.price,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
      price: json['price'].toDouble(),
    );
  }
}
