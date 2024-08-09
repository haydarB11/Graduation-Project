class School {
  final int id;
  final String nameAr;
  final String nameEn;
  final String region;
  final String type;
  final double spExpenses;
  final int totals;
  final double totalPrice;
  final num cash;
  final List<SellPoint> sellPoints;

  School(
      {required this.id,
      required this.nameAr,
      required this.nameEn,
      required this.region,
      required this.type,
      required this.spExpenses,
      required this.totals,
      required this.totalPrice, //مرتجاعات
      required this.sellPoints,
      required this.cash});

  factory School.fromJson(Map<String, dynamic> json) {
    final List<dynamic> sellPointsJson = json['sell_points'] ?? [];
    final sellPointsList =
        sellPointsJson.map((point) => SellPoint.fromJson(point)).toList();

    return School(
      id: json['id'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
      region: json['region'],
      type: json['type'],
      spExpenses: (json['sp_expenses'] ?? 0.0)
          .toDouble(), // Handle null and double values
      totals: (json['totals'] ?? 0).toInt(), // Handle null and double values
      cash: (json['cash'] ?? 0),
      totalPrice:
          (json['returns'] ?? 0.0).toDouble(), // Handle null and double values
      sellPoints: sellPointsList,
    );
  }
}

class SellPoint {
  final int id;
  final String name;
  final Driver driver;
  final Promoter promoter;
  final List<Envelope> envelopes;
  final List<Inventory> inventories;
  final List<Bill> bills;

  SellPoint({
    required this.id,
    required this.name,
    required this.driver,
    required this.promoter,
    required this.envelopes,
    required this.inventories,
    required this.bills,
  });

  factory SellPoint.fromJson(Map<String, dynamic> json) {
    final List<dynamic> envelopesJson = json['envelops'] ?? [];
    final List<dynamic> inventoriesJson = json['inventories'] ?? [];
    final List<dynamic> billsJson = json['bills'] ?? [];

    final envelopesList =
        envelopesJson.map((envelope) => Envelope.fromJson(envelope)).toList();
    final inventoriesList = inventoriesJson
        .map((inventory) => Inventory.fromJson(inventory))
        .toList();
    final billsList = billsJson.map((bill) => Bill.fromJson(bill)).toList();

    return SellPoint(
      id: json['id'],
      name: json['name'],
      driver: Driver.fromJson(json['driver']),
      promoter: Promoter.fromJson(json['promoter']),
      envelopes: envelopesList,
      inventories: inventoriesList,
      bills: billsList,
    );
  }
}

class Driver {
  final int id;
  final String nameAr;
  final String nameEn;

  Driver({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
    );
  }
}

class Promoter {
  final int id;
  final String nameAr;
  final String nameEn;

  Promoter({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  factory Promoter.fromJson(Map<String, dynamic> json) {
    return Promoter(
      id: json['id'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
    );
  }
}

class Envelope {
  final int id;
  final String number;
  final double cash;

  Envelope({
    required this.id,
    required this.number,
    required this.cash,
  });

  factory Envelope.fromJson(Map<String, dynamic> json) {
    return Envelope(
      id: json['id'],
      number: json['number'],
      cash: json['cash'].toDouble(),
    );
  }
}

class Inventory {
  final int id;
  final double totalPrice;
  final int totalAmount;

  Inventory({
    required this.id,
    required this.totalPrice,
    required this.totalAmount,
  });

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      id: json['id'],
      totalPrice: json['total_price'].toDouble(),
      totalAmount: json['total_amount'],
    );
  }
}

class Bill {
  final int id;
  final int total;
  final int totalQuantity;

  Bill({
    required this.id,
    required this.total,
    required this.totalQuantity,
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'] as int,
      total: (json['total'] as num).toInt(), // Ensure it's cast to an int
      totalQuantity:
          (json['total_quantity'] as num).toInt(), // Ensure it's cast to an int
    );
  }
}

//Exception has occurred.
// _TypeError (type 'double' is not a subtype of type 'int')