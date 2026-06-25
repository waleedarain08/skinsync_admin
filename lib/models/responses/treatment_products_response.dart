import 'base_response_model.dart';

class TreatmentProductsResponse extends BaseApiResponseModel<List<TreatmentProductData>> {
  const TreatmentProductsResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory TreatmentProductsResponse.fromJson(Map<String, dynamic> json) {
    final bool success = (json['is_success'] as bool?) ?? (json['is_Success'] as bool?) ?? false;
    return TreatmentProductsResponse(
      isSuccess: success,
      message: json['message'] ?? '',
      data: json['data'] == null
          ? null
          : (json['data'] as List)
              .map((e) => TreatmentProductData.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}

class TreatmentProductData {
  final int id;
  final String name;
  final String? image;
  final String? brand;
  final String? manufacturer;
  final String? globalSku;
  final String? status;
  final String? usageType;

  const TreatmentProductData({
    required this.id,
    required this.name,
    this.image,
    this.brand,
    this.manufacturer,
    this.globalSku,
    this.status,
    this.usageType,
  });

  factory TreatmentProductData.fromJson(Map<String, dynamic> json) {
    return TreatmentProductData(
      id: json['id'] as int? ?? 0,
      name: json['name'] ?? '',
      image: json['image'],
      brand: json['brand'],
      manufacturer: json['manufacturer'],
      globalSku: json['global_sku'] ?? json['globalSku'],
      status: json['status'],
      usageType: json['usage_type'] ?? json['usageType'],
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
}
