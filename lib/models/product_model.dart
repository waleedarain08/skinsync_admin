import 'package:skinsync_admin/models/responses/base_response_model.dart';

class ProductResponse extends BaseApiResponseModel<ProductModel> {
  const ProductResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      ProductResponse(
        isSuccess: (json['is_success'] as bool?) ?? false,
        message: json['message'] ?? '',
        data: json['data'] == null
            ? null
            : ProductModel.fromJson(json['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
    'is_success': isSuccess,
    'message': message,
    'data': data?.toJson(),
  };
}

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
  final String? usageType;

  // New packaging fields
  final String? packageType;
  final int? unitsPerPackage;

  // Audit and extended fields from Master Checklist
  final String? subcategory;
  final int? boxQuantity;
  final int? itemQuantityPerBox;
  final String? billableUnit;
  final double? billableQuantityPerItem;
  final double? totalBillableQuantity;
  final double? clinicCost;
  final double? retailPricePerUnit;
  final String? supplier;
  final String? lotNumber;
  final DateTime? expirationDate;
  final List<int>? selectedCategoryIds;
  final String? barcode;

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
    this.usageType,
    this.packageType,
    this.unitsPerPackage,
    this.subcategory,
    this.boxQuantity,
    this.itemQuantityPerBox,
    this.billableUnit,
    this.billableQuantityPerItem,
    this.totalBillableQuantity,
    this.clinicCost,
    this.retailPricePerUnit,
    this.supplier,
    this.lotNumber,
    this.expirationDate,
    this.selectedCategoryIds,
    this.barcode,
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
      usageType: json['usage_type'] ?? json['product_purpose'],
      packageType: json['package_type'],
      unitsPerPackage: json['units_per_package'] as int?,
      subcategory: json['subcategory'],
      boxQuantity: json['box_quantity'] as int?,
      itemQuantityPerBox: json['item_quantity_per_box'] as int?,
      billableUnit: json['billable_unit'],
      billableQuantityPerItem: (json['billable_quantity_per_item'] as num?)
          ?.toDouble(),
      totalBillableQuantity: (json['total_billable_quantity'] as num?)
          ?.toDouble(),
      clinicCost: (json['clinic_cost'] as num?)?.toDouble(),
      retailPricePerUnit: (json['retail_price_per_unit'] as num?)?.toDouble(),
      supplier: json['supplier'],
      lotNumber: json['lot_number'],
      expirationDate: json['expiration_date'] != null
          ? DateTime.parse(json['expiration_date'])
          : null,
      selectedCategoryIds: json['selected_category_ids'] != null
          ? List<int>.from(json['selected_category_ids'])
          : null,
      //  barcode: json['barcode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'image': image,
      'name': name,
      'description': description,
      // 'unit': unit,
      // 'sku': sku,
      'category': category,
      // 'quantity': quantity,
      'status': status,
      'brand': brand,
      // 'manufacturer': manufacturer,
      'global_sku': globalSku,
      // 'product_purpose': productPurpose,
      'unit_type': unitType,
      'enforce_lot_tracking': enforceLotTracking,
      'usage_type': usageType ?? productPurpose,
      'package_type': packageType,
      // 'units_per_package': unitsPerPackage,
      // 'subcategory': subcategory,
      'box_quantity': boxQuantity,
      'item_quantity_per_box': itemQuantityPerBox,
      'billable_unit': billableUnit,
      'billable_quantity_per_item': billableQuantityPerItem,
      'total_billable_quantity': totalBillableQuantity,
      'clinic_cost': clinicCost,
      'retail_price_per_unit': retailPricePerUnit,
      'supplier': supplier,
      'lot_number': lotNumber,
      'expiration_date': expirationDate?.toIso8601String(),
      'selected_category_ids': selectedCategoryIds,
      'barcode': barcode,
    };
  }
}
