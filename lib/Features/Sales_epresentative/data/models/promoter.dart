class Promoter {
  int id;
  final String nameAr;
  final String nameEn;
  final String user;
  final String password;
  final String phone;
  final List<SellPoint>? sellPoints;

  Promoter({
    this.id = 0,
    required this.nameAr,
    required this.nameEn,
    required this.user,
    required this.password,
    required this.phone,
    this.sellPoints,
  });
  Map<String, dynamic> toJson() {
    return {
      'name_ar': nameAr,
      'name_en': nameEn,
      'user': user,
      'password': password,
      'phone': phone,
      // Add other fields if needed
    };
  }

  factory Promoter.fromJson(Map<String, dynamic> json) {
    return Promoter(
      id: json['id'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
      user: json['user'],
      password: json['password'],
      phone: json['phone'],
      sellPoints: (json['sell_points'] as List)
          .map((e) => SellPoint.fromJson(e))
          .toList(),
    );
  }
}

class SellPoint {
  final int id;
  final String name;
  final String? user;
  final String? password;

  final int ?driverId;
  final int ?managerId;
  final int ?promoterId;
  

  SellPoint({
    required this.id,
    required this.name,
    required this.user,
    required this.password,
 
    required this.driverId,
    required this.managerId,
    required this.promoterId,
   
  });

  factory SellPoint.fromJson(Map<String, dynamic> json) {
    return SellPoint(
      id: json['id'],
      name: json['name'],
      user: json['user'],
      password: json['password'],
   
      driverId: json['driver_id'],
      managerId: json['Manager_id'],
      promoterId: json['promoter_id'],
    
    );
  }
}
