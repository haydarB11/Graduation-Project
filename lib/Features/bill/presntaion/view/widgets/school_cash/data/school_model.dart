class School {
  final int id;
  final String nameAr;
  final String nameEn;

  School({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String,
      nameEn: json['name_en'] as String,
    );
  }
}
