class CreateFormRequest {
  final String title;
  final String url;
  final String type; // 'consent' or 'compliance'
  final String globalSku;

  CreateFormRequest({
    required this.title,
    required this.url,
    required this.type,
    required this.globalSku,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'url': url,
      'type': type,
      'global_sku': globalSku,
    };
  }
}
