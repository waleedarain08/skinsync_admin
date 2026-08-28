class UpdateFormRequest {
  final String title;
  final String url;
  final String type; // 'consent' or 'compliance'
  final String globalSku;

  UpdateFormRequest({
    required this.title,
    required this.url,
    required this.type,
    required this.globalSku,
  });

  factory UpdateFormRequest.fromJson(Map<String, dynamic> json) {
    return UpdateFormRequest(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      type: json['type'] ?? '',
      globalSku: json['global_sku'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'url': url,
      'type': type,
      'global_sku': globalSku,
    };
  }

  UpdateFormRequest copyWith({
    String? title,
    String? url,
    String? type,
    String? globalSku,
  }) {
    return UpdateFormRequest(
      title: title ?? this.title,
      url: url ?? this.url,
      type: type ?? this.type,
      globalSku: globalSku ?? this.globalSku,
    );
  }
}