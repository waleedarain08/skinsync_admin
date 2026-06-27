import '../product_model.dart';
import 'base_response_model.dart';

class ProductListResponse extends BaseApiResponseModel<List<ProductListItemModel>> {
  final int page;
  final int limit;
  final int totalPages;

  const ProductListResponse({
    required super.isSuccess,
    required super.message,
    required this.page,
    required this.limit,
    required this.totalPages,
    super.data,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    return ProductListResponse(
      isSuccess: (json['is_success'] as bool?) ?? false,
      message: json['message'] ?? '',
      page: json['page'] as int? ?? 0,
      limit: json['limit'] as int? ?? 0,
      totalPages: json['total_pages'] as int? ?? json['totalPages'] as int? ?? 1,
      data: json['data'] == null
          ? null
          : (json['data'] as List)
              .map((e) => ProductListItemModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}

class ProductListItemModel {
  final int id;
  final String name;
  final String image;
  final String? brand;
  final String? manufacturer;
  final String? globalSku;
  final String? status;
  final String? usageType;

  const ProductListItemModel({
    required this.id,
    required this.name,
    required this.image,
    this.brand,
    this.manufacturer,
    this.globalSku,
    this.status,
    this.usageType,
  });

  factory ProductListItemModel.fromJson(Map<String, dynamic> json) {
    return ProductListItemModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      brand: json['brand'],
      manufacturer: json['manufacturer'],
      globalSku: json['global_sku'],
      status: json['status'],
      usageType: json['usage_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'brand': brand,
      'manufacturer': manufacturer,
      'global_sku': globalSku,
      'status': status,
      'usage_type': usageType,
    };
  }

  ProductModel toProductModel() {
    return ProductModel(
      id: id,
      image: image,
      name: name,
      brand: brand,
      manufacturer: manufacturer,
      globalSku: globalSku,
      productPurpose: usageType,
      status: status,
      description: '',
      unit: '',
    );
  }
}