class FormModel {
  final int? id;
  final String? title;
  final String? url;
  final String? type; // 'consent' or 'compliance'
  final String? globalSku;
  final String? status;

  FormModel({
    this.id,
    this.title,
    this.url,
    this.type,
    this.globalSku,
    this.status
  });

  factory FormModel.fromJson(Map<String, dynamic> json) {
    return FormModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      url: json['url'] as String?,
      type: json['type'] as String?,
      globalSku: json['global_sku'] as String?,
      status: json['status']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'url': url,
      'type': type,
      'global_sku': globalSku,
      'status':status
    };
  }
}
