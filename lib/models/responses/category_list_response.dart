import 'base_response_model.dart';

class CategoryListResponse extends BaseApiResponseModel<List<CategoryModel>> {
  const CategoryListResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory CategoryListResponse.fromJson(Map<String, dynamic> json) =>
      CategoryListResponse(
        isSuccess: (json['is_success'] as bool?) ?? false,
        message: json['message'] ?? '',
        data: json['data'] == null
            ? null
            : (json['data'] as List)
                .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
                .toList(),
      );

 
}

class CategoryModel {
  final int id;
  final String name;
  final String icon;
  final String image;
  final int? parentId;
  final List<CategoryModel> subCategories;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.image,
    this.parentId,
    this.subCategories = const [],
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      image: json['image'] ?? '',
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
      'image': image,
      'parent_id': parentId,
      'sub_categories': subCategories.map((e) => e.toJson()).toList(),
    };
  }

  CategoryModel copyWith({
    int? id,
    String? name,
    String? icon,
    String? image,
    int? parentId,
    List<CategoryModel>? subCategories,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      image: image ?? this.image,
      parentId: parentId ?? this.parentId,
      subCategories: subCategories ?? this.subCategories,
    );
  }
}
