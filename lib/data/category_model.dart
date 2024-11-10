class CategoryModel {
  int? id;
  String name;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<dynamic> translations;

  CategoryModel({
    this.id,
    this.name = 'Category',
    this.createdAt,
    this.updatedAt,
    this.translations = const [],
  });

  // Factory constructor to create an instance from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'] ?? 'Category',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      translations: json['translations'] ?? [],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'translations': translations,
    };
  }
}
