class CreateSubAreaRequest {

  final int parentId;
  final String name;
  final String globalSku;
  final String icon;

  const CreateSubAreaRequest({
    required this.parentId,
    required this.name,
    required this.globalSku,
    required this.icon,
  });

  Map<String, dynamic> toJson() {
    return {
      'area_id': parentId,
      'name': name,
      'global_sku': globalSku,
      'icon': icon
    };
  }
}
