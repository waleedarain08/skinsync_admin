class CreateProductRequest {
  final String? image;
  final String? name;
  final String? brand;
  final String? manufacturer;
  final String? globalSku;
  final String? barcode;
  final String? usageType;
  final String? category;
  final List<int>? selectedCategoryIds;
  final String? status;
  final String? description;
  final String? unitType;
  final int? boxQuantity;
  final int? itemQuantityPerBox;
  final String? packageType;
  final String? billableUnit;
  final double? billableQuantityPerItem;
  final double? totalBillableQuantity;
  final bool? enforceLotTracking;
  final double? clinicCost;
  final double? retailPricePerUnit;
  final String? supplier;
  final String? lotNumber;
  final String? expirationDate;

  CreateProductRequest({
    this.image,
    this.name,
    this.brand,
    this.manufacturer,
    this.globalSku,
    this.barcode,
    this.usageType,
    this.category,
    this.selectedCategoryIds,
    this.status,
    this.description,
    this.unitType,
    this.boxQuantity,
    this.itemQuantityPerBox,
    this.packageType,
    this.billableUnit,
    this.billableQuantityPerItem,
    this.totalBillableQuantity,
    this.enforceLotTracking,
    this.clinicCost,
    this.retailPricePerUnit,
    this.supplier,
    this.lotNumber,
    this.expirationDate,
  });

  factory CreateProductRequest.fromJson(Map<String, dynamic> json) {
    return CreateProductRequest(
      image: json['image'] as String?,
      name: json['name'] as String?,
      brand: json['brand'] as String?,
      manufacturer: json['manufacturer'] as String?,
      globalSku: json['global_sku'] as String?,
      barcode: json['barcode'] as String?,
      usageType: json['usage_type'] as String?,
      category: json['category'] as String?,
      selectedCategoryIds: (json['selected_category_ids'] as List?)?.map((e) => e as int).toList(),
      status: json['status'] as String?,
      description: json['description'] as String?,
      unitType: json['unit_type'] as String?,
      boxQuantity: json['box_quantity'] as int?,
      itemQuantityPerBox: json['item_quantity_per_box'] as int?,
      packageType: json['package_type'] as String?,
      billableUnit: json['billable_unit'] as String?,
      billableQuantityPerItem: (json['billable_quantity_per_item'] as num?)?.toDouble(),
      totalBillableQuantity: (json['total_billable_quantity'] as num?)?.toDouble(),
      enforceLotTracking: json['enforce_lot_tracking'] as bool?,
      clinicCost: (json['clinic_cost'] as num?)?.toDouble(),
      retailPricePerUnit: (json['retail_price_per_unit'] as num?)?.toDouble(),
      supplier: json['supplier'] as String?,
      lotNumber: json['lot_number'] as String?,
      expirationDate: json['expiration_date'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'name': name,
      'brand': brand,
      'manufacturer': manufacturer,
      'global_sku': globalSku,
      'barcode': barcode,
      'usage_type': usageType,
      'category': category,
      'selected_category_ids': selectedCategoryIds,
      'status': status,
      'description': description,
      'unit_type': unitType,
      'box_quantity': boxQuantity,
      'item_quantity_per_box': itemQuantityPerBox,
      'package_type': packageType,
      'billable_unit': billableUnit,
      'billable_quantity_per_item': billableQuantityPerItem,
      'total_billable_quantity': totalBillableQuantity,
      'enforce_lot_tracking': enforceLotTracking,
      'clinic_cost': clinicCost,
      'retail_price_per_unit': retailPricePerUnit,
      'supplier': supplier,
      'lot_number': lotNumber,
      'expiration_date': expirationDate,
    };
  }

  CreateProductRequest copyWith({
    String? image,
    String? name,
    String? brand,
    String? manufacturer,
    String? globalSku,
    String? barcode,
    String? usageType,
    String? category,
    List<int>? selectedCategoryIds,
    String? status,
    String? description,
    String? unitType,
    int? boxQuantity,
    int? itemQuantityPerBox,
    String? packageType,
    String? billableUnit,
    double? billableQuantityPerItem,
    double? totalBillableQuantity,
    bool? enforceLotTracking,
    double? clinicCost,
    double? retailPricePerUnit,
    String? supplier,
    String? lotNumber,
    String? expirationDate,
  }) {
    return CreateProductRequest(
      image: image ?? this.image,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      manufacturer: manufacturer ?? this.manufacturer,
      globalSku: globalSku ?? this.globalSku,
      barcode: barcode ?? this.barcode,
      usageType: usageType ?? this.usageType,
      category: category ?? this.category,
      selectedCategoryIds: selectedCategoryIds ?? this.selectedCategoryIds,
      status: status ?? this.status,
      description: description ?? this.description,
      unitType: unitType ?? this.unitType,
      boxQuantity: boxQuantity ?? this.boxQuantity,
      itemQuantityPerBox: itemQuantityPerBox ?? this.itemQuantityPerBox,
      packageType: packageType ?? this.packageType,
      billableUnit: billableUnit ?? this.billableUnit,
      billableQuantityPerItem: billableQuantityPerItem ?? this.billableQuantityPerItem,
      totalBillableQuantity: totalBillableQuantity ?? this.totalBillableQuantity,
      enforceLotTracking: enforceLotTracking ?? this.enforceLotTracking,
      clinicCost: clinicCost ?? this.clinicCost,
      retailPricePerUnit: retailPricePerUnit ?? this.retailPricePerUnit,
      supplier: supplier ?? this.supplier,
      lotNumber: lotNumber ?? this.lotNumber,
      expirationDate: expirationDate ?? this.expirationDate,
    );
  }
}