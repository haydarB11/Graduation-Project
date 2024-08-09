class Category {
  final int id;
  final String nameAr;
  final String nameEn;

  Category({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String,
      nameEn: json['name_en'] as String,
      
    );
  }
}
