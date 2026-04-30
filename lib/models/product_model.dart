class ProductModel {
  final int? id;
  final String image;
  final String name;
  final String description;
  final String unit;

  ProductModel({
    required this.id,
    required this.image,
    required this.name,
    required this.description,
    required this.unit,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      image: json['image'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      unit: json['unit'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'image': image,
      'name': name,
      'description': description,
      'unit': unit,
    };
  }
}
