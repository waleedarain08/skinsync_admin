class AreaRequest {
  final String name;
  final String globalSku;
  final String icon;

  const AreaRequest({
    required this.name,
    required this.globalSku,
    required this.icon,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'global_sku': globalSku, 'icon': icon};
  }
}
