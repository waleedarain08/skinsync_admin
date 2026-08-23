class UpdateAreaRequest {
  final String? name;
  final String? globalSku;
  final String? icon;
  final String? image;

  UpdateAreaRequest({this.name, this.globalSku, this.icon, this.image});

  Map<String, dynamic> toJson() => {
    'name': name,
    'global_sku': globalSku,
    'icon': icon,
    'image': image,
  };
}
