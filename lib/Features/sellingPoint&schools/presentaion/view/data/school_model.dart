class School {
  final int id;
  final String nameArabic;
  final String nameEnglish;
  final String region;
  final String type;
  final List<SellPoint> sellPoints; // List of associated sell points

  School({
    required this.id,
    required this.nameArabic,
    required this.nameEnglish,
    required this.region,
    required this.type,
    required this.sellPoints,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    final List<dynamic> sellPointsJson = json['sell_points'] ?? [];

    return School(
      id: json['id'],
      nameArabic: json['name_ar'],
      nameEnglish: json['name_en'],
      region: json['region'],
      type: json['type'],
      sellPoints: sellPointsJson.map((sp) => SellPoint.fromJson(sp)).toList(),
    );
  }
}

class SellPoint {
  final int id;
  final String name;
  final String user;
  final String password;
  final bool updated;
  final int driverid;
  final int promoterid;
  final School? school;
  final Driver? driver; // Add a property for the associated Driver
  final Promoter? promoter;
  final List<Bill> bills;

  // Add promoter property

  SellPoint(
      {required this.id,
      required this.promoter,
      required this.driver,
      required this.name,
      required this.user,
      required this.password,
      required this.updated,
      required this.driverid,
      required this.promoterid,
      required this.bills,
      required this.school});

  factory SellPoint.fromJson(Map<String, dynamic> json) {
    final List<dynamic> billsjson = json['bills'] ?? [];
    return SellPoint(
        id: json['id'],
        name: json['name'],
        user: json['user'],
        password: json['password'],
        updated: json['updated'],
        driverid: json['driver_id'],
        promoterid: json['promoter_id'],
        school: json['school'] != null ? School.fromJson(json['school']) : null,
        driver: json['driver'] != null
            ? Driver.fromJson(json['driver'])
            : null, // Initialize the driver property
        promoter: json['promoter'] != null
            ? Promoter.fromJson(json['promoter'])
            : null,
        bills: billsjson.map((e) => Bill.fromjson(e)).toList());
  }
}

class Bill {
  final int id;

  Bill({required this.id});
  factory Bill.fromjson(Map<String, dynamic> json) {
    return Bill(id: json['id']);
  }
}

class Promoter {
  final int id;
  final String nameArabic;
  final String nameEnglish;
  final String user;
  final String password;
  final String phone;

  Promoter({
    required this.id,
    required this.nameArabic,
    required this.nameEnglish,
    required this.user,
    required this.password,
    required this.phone,
  });

  factory Promoter.fromJson(Map<String, dynamic> json) {
    return Promoter(
      id: json['id'],
      nameArabic: json['name_ar'],
      nameEnglish: json['name_en'],
      user: json['user'],
      password: json['password'],
      phone: json['phone'],
    );
  }
}

class Driver {
  final int id;
  final String nameArabic;
  final String nameEnglish;
  final String user;
  final String password;
  final String phone;

  Driver({
    required this.id,
    required this.nameArabic,
    required this.nameEnglish,
    required this.user,
    required this.password,
    required this.phone,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      nameArabic: json['name_ar'],
      nameEnglish: json['name_en'],
      user: json['user'],
      password: json['password'],
      phone: json['phone'],
    );
  }
}

class Manager {
  final int id;
  final String nameArabic;
  final String nameEnglish;
  final String user;
  final String password;
  final String phone;

  Manager({
    required this.id,
    required this.nameArabic,
    required this.nameEnglish,
    required this.user,
    required this.password,
    required this.phone,
  });

  factory Manager.fromJson(Map<String, dynamic> json) {
    return Manager(
      id: json['id'],
      nameArabic: json['name_ar'],
      nameEnglish: json['name_en'],
      user: json['user'],
      password: json['password'],
      phone: json['phone'],
    );
  }
}
