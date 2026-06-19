import '../product_model.dart';
import 'base_response_model.dart';

class ProductListResponse extends BaseApiResponseModel<List<ProductModel>> {
  final int? page;
  final int? limit;
  final int? totalPages;

  const ProductListResponse({
    required super.isSuccess,
    required super.message,
    super.data,
    this.page,
    this.limit,
    this.totalPages,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    final bool success = (json['is_success'] as bool?) ?? false;
    return ProductListResponse(
      isSuccess: success,
      message: json['message'] ?? '',
      page: json['page'] as int?,
      limit: json['limit'] as int?,
      totalPages: json['total_pages'] as int? ?? json['totalPages'] as int?,
      data: json['data'] == null
          ? null
          : (json['data'] as List)
              .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

 
}
