import 'base_response_model.dart';

class AreaListResponse extends BaseApiResponseModel<List<AreaModel>> {
  const AreaListResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory AreaListResponse.fromJson(Map<String, dynamic> json) =>
      AreaListResponse(
        isSuccess: (json['is_success'] as bool?)  ?? false,
        message: json['message'] ?? '',
        data: json['data'] == null
            ? null
            : (json['data'] as List)
                  .map((e) => AreaModel.fromJson(e as Map<String, dynamic>))
                  .toList(),
      );


}

class AreaModel {
  final int id;
  final String name;
  final String globalSku;
  final String icon;
  final String image;
  final int subAreasCount;
  final List<AreaModel> subAreas;

  AreaModel({
    required this.id,
    required this.name,
    required this.globalSku,
    required this.icon,
    required this.image,
    required this.subAreasCount,
    this.subAreas = const [],
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] ?? '',
      globalSku: json['global_sku'] ?? '',
      icon: json['icon'] ?? '',
      image: json['image'] ?? '',
      subAreasCount: json['sub_areas_count'] as int? ?? 0,
      subAreas:
          (json['sub_areas'] as List?)
              ?.map((e) => AreaModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'global_sku': globalSku,
      'icon': icon,
      'image': image,
      'sub_areas_count': subAreasCount,
      'sub_areas': subAreas.map((e) => e.toJson()).toList(),
    };
  }

  AreaModel copyWith({
    int? id,
    String? name,
    String? globalSku,
    String? icon,
    String? image,
    int? subAreasCount,
    List<AreaModel>? subAreas,
  }) {
    return AreaModel(
      id: id ?? this.id,
      name: name ?? this.name,
      globalSku: globalSku ?? this.globalSku,
      icon: icon ?? this.icon,
      image: image ?? this.image,
      subAreasCount: subAreasCount ?? this.subAreasCount,
      subAreas: subAreas ?? this.subAreas,
    );
  }
}
