import 'base_response_model.dart';

class ProductDeductionTimingListResponse extends BaseApiResponseModel<List<DeductionTimingModel>> {
  const ProductDeductionTimingListResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory ProductDeductionTimingListResponse.fromJson(Map<String, dynamic> json) {
    return ProductDeductionTimingListResponse(
      isSuccess: json['is_success'] as bool? ?? false,
      message: json['message'] ?? '',
      data: json['data'] == null
          ? null
          : (json['data'] as List)
          .map((e) => DeductionTimingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class DeductionTimingModel {
  final int id;
  final String name;

  const DeductionTimingModel({
    required this.id,
    required this.name,
  });

  factory DeductionTimingModel.fromJson(Map<String, dynamic> json) {
    return DeductionTimingModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };

  DeductionTimingModel copyWith({
    int? id,
    String? name,
  }) {
    return DeductionTimingModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
