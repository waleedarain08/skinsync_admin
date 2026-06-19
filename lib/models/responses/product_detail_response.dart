import 'base_response_model.dart';

class ProductDetailResponse extends BaseApiResponseModel<ProductDetailModel> {
  const ProductDetailResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory ProductDetailResponse.fromJson(Map<String, dynamic> json) {
    final bool success = (json['is_success'] as bool?)  ?? false;
    return ProductDetailResponse(
      isSuccess: success,
      message: json['message'] ?? '',
      data: json['data'] == null
          ? null
          : ProductDetailModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }


}

class ProductDetailModel {
  final int? id;
  final String image;
  final String name;
  final String? brand;
  final String? globalSku;
  final String? barcode;
  final String? usageType;
  final String? category;
  final List<int>? selectedCategoryIds;
  final String? status;
  final String description;
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
  final DateTime? expirationDate;

  ProductDetailModel({
    this.id,
    required this.image,
    required this.name,
    this.brand,
    this.globalSku,
    this.barcode,
    this.usageType,
    this.category,
    this.selectedCategoryIds,
    this.status,
    required this.description,
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

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      id: json['id'] as int?,
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      brand: json['brand'],
      globalSku: json['global_sku'],
      barcode: json['barcode'],
      usageType: json['usage_type'] ?? json['product_purpose'],
      category: json['category'],
      selectedCategoryIds: json['selected_category_ids'] != null
          ? List<int>.from(json['selected_category_ids'])
          : null,
      status: json['status'],
      description: json['description'] ?? '',
      unitType: json['unit_type'] ?? json['unit'],
      boxQuantity: json['box_quantity'] as int?,
      itemQuantityPerBox: json['item_quantity_per_box'] as int?,
      packageType: json['package_type'],
      billableUnit: json['billable_unit'],
      billableQuantityPerItem: (json['billable_quantity_per_item'] as num?)?.toDouble(),
      totalBillableQuantity: (json['total_billable_quantity'] as num?)?.toDouble(),
      enforceLotTracking: json['enforce_lot_tracking'] as bool?,
      clinicCost: (json['clinic_cost'] as num?)?.toDouble(),
      retailPricePerUnit: (json['retail_price_per_unit'] as num?)?.toDouble(),
      supplier: json['supplier'],
      lotNumber: json['lot_number'],
      expirationDate: json['expiration_date'] != null
          ? DateTime.tryParse(json['expiration_date'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'image': image,
      'name': name,
      'brand': brand,
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
      'expiration_date': expirationDate?.toIso8601String(),
    };
  }
}
