class CreateAreaRequest {
  final int? parentId;
  final String? name;
  final String? globalSku;
  final String? icon;
  final String? image;

  CreateAreaRequest({
    this.parentId,
    this.name,
    this.globalSku,
    this.icon,
    this.image,
  });

  Map<String, dynamic> toJson() => {
    'parent_id': parentId,
    'name': name,
    'global_sku': globalSku,
    'icon': icon,
    'image': image,
  };
}
