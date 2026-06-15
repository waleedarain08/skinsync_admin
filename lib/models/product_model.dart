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
  final String? manufacturer;
  final String? globalSku;
  final String? productPurpose;
  final String? unitType;
  final bool? enforceLotTracking;

  // New packaging fields
  final String? packageType;
  final int? unitsPerPackage;

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
    this.manufacturer,
    this.globalSku,
    this.productPurpose,
    this.unitType,
    this.enforceLotTracking,
    this.packageType,
    this.unitsPerPackage,
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
      manufacturer: json['manufacturer'],
      globalSku: json['global_sku'],
      productPurpose: json['product_purpose'],
      unitType: json['unit_type'],
      enforceLotTracking: json['enforce_lot_tracking'],
      packageType: json['package_type'],
      unitsPerPackage: json['units_per_package'] as int?,
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
      'manufacturer': manufacturer,
      'global_sku': globalSku,
      'product_purpose': productPurpose,
      'unit_type': unitType,
      'enforce_lot_tracking': enforceLotTracking,
      'package_type': packageType,
      'units_per_package': unitsPerPackage,
    };
  }
}
