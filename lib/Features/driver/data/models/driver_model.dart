class Driver {
  final int id;
  final String nameAr;
  final String nameEn;
  final String user;
  final String password;
  final String phone;
  final List<SellPoint> ?sellPoints;

  Driver({
    this.id = 0,
    required this.nameAr,
    required this.nameEn,
    required this.user,
    required this.password,
    required this.phone,
     this.sellPoints,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
      user: json['user'],
      password: json['password'],
      phone: json['phone'],
      sellPoints: (json['sell_points'] as List)
          .map((pointData) => SellPoint.fromJson(pointData))
          .toList(),
    );
  }
}

class SellPoint {
  final int id;
  final String name;
  String? user;
  String? password;
  int? schoolId;
  int? driverId;
  int? managerId;

  SellPoint({
    required this.id,
    required this.name,
    this.user,
    this.password,
    this.schoolId,
    this.driverId,
    this.managerId,
  });

  factory SellPoint.fromJson(Map<String, dynamic> json) {
    return SellPoint(
      id: json['id'],
      name: json['name'],
      user: json['user'],
      password: json['password'],
      schoolId: json['school_id'],
      driverId: json['driver_id'],
      managerId: json['Manager_id'],
    );
  }
}
