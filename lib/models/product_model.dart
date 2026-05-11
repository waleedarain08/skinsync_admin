class ProductModel {
  final int? id;
  final String image;
  final String name;
  final String description;
  final String unit;
  final String? sku;
  final String? category;
  final int? quantity;
  final String? status; // Active/Inactive

  ProductModel({
    this.id,
    required this.image,
    required this.name,
    required this.description,
    required this.unit,
    this.sku,
    this.category,
    this.quantity,
    this.status,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int?,
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      unit: json['unit'] ?? '',
      sku: json['sku'],
      category: json['category'],
      quantity: json['quantity'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'image': image,
      'name': name,
      'description': description,
      'unit': unit,
      'sku': sku,
      'category': category,
      'quantity': quantity,
      'status': status,
    };
  }
}
