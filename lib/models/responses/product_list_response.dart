import '../product_model.dart';
import 'base_response_model.dart';

class ProductListResponse extends BaseApiResponseModel<List<ProductModel>> {

  const ProductListResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    final bool success = (json['is_success'] as bool?) ?? (json['status'] as bool?) ?? false;
    return ProductListResponse(
      isSuccess: success,
      message: json['message'] ?? '',
      data: json['data'] == null
          ? null
          : (json['data'] as List)
              .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': isSuccess,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}
