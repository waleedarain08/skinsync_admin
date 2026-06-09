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

  // Refined Global Product Catalog fields
  final String? brand;
  final String? global_sku;
  final String? product_purpose;
  final String? unit_type;
  final bool? enforce_lot_tracking;

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
    this.brand,
    this.global_sku,
    this.product_purpose,
    this.unit_type,
    this.enforce_lot_tracking,
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
      brand: json['brand'],
      global_sku: json['global_sku'],
      product_purpose: json['product_purpose'],
      unit_type: json['unit_type'],
      enforce_lot_tracking: json['enforce_lot_tracking'],
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
      'brand': brand,
      'global_sku': global_sku,
      'product_purpose': product_purpose,
      'unit_type': unit_type,
      'enforce_lot_tracking': enforce_lot_tracking,
    };
  }
}
