class CreateAreaRequest {
  final int? parentId;
  final String? name;
  final String? globalSku;
  final String? icon;
  final String? image;
  final String? infoImage;
  final String? description;

  CreateAreaRequest({
    this.parentId,
    this.name,
    this.globalSku,
    this.icon,
    this.image,
    this.infoImage,
    this.description,
  });

  Map<String, dynamic> toJson() => {
    'parent_id': parentId,
    'name': name,
    'global_sku': globalSku,
    'icon': icon,
    'image': image,
    'info_image_url': infoImage,
    'description': description,
  };
}
