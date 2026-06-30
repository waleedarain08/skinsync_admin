import 'base_response_model.dart';

class SupplierListResponse extends BaseApiResponseModel<List<SupplierModel>> {
  const SupplierListResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory SupplierListResponse.fromJson(Map<String, dynamic> json) {
    return SupplierListResponse(
      isSuccess: json['is_success'] as bool? ?? false,
      message: json['message'] ?? '',
      data: json['data'] == null
          ? null
          : (json['data'] as List)
          .map((e) => SupplierModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SupplierModel {
  final int id;
  final String name;

  const SupplierModel({
    required this.id,
    required this.name,
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] ?? '',
    );
  }
}