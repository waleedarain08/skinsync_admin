import 'base_response_model.dart';

class UnitTypesListResponse extends BaseApiResponseModel<List<UnitTypeModel>> {
  const UnitTypesListResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory UnitTypesListResponse.fromJson(Map<String, dynamic> json) {
    return UnitTypesListResponse(
      isSuccess: json['status'] as bool? ?? false,
      message: json['message'] ?? '',
      data: json['data'] == null
          ? null
          : (json['data'] as List)
          .map((e) => UnitTypeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class UnitTypeModel {
  final int id;
  final String name;

  const UnitTypeModel({
    required this.id,
    required this.name,
  });

  factory UnitTypeModel.fromJson(Map<String, dynamic> json) {
    return UnitTypeModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] ?? '',
    );
  }

}