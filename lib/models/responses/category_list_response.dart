import 'base_response_model.dart';

class CategoryListResponse extends BaseApiResponseModel<List<CategoryModel>> {
  const CategoryListResponse({
    required super.status,
    required super.message,
    super.data,
  });

  factory CategoryListResponse.fromJson(Map<String, dynamic> json) =>
      CategoryListResponse(
        status: json['status'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] == null
            ? null
            : (json['data'] as List)
                .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
                .toList(),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}

class CategoryModel {
  final int id;
  final String name;
  final String icon;
  final int? parentId;
  final List<CategoryModel> subCategories;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    this.parentId,
    this.subCategories = const [],
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      parentId: json['parent_id'] as int?,
      subCategories: (json['sub_categories'] as List?)
          ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'parent_id': parentId,
      'sub_categories': subCategories.map((e) => e.toJson()).toList(),
    };
  }
}
