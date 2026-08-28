class PlanBenefit {
  int? id;
  String? sku;
  String? title;
  String? description;
  bool enabled;

  PlanBenefit({
    this.id,
    this.sku,
    this.title,
    this.description,
    this.enabled = true,
  });

  factory PlanBenefit.fromJson(Map<String, dynamic> json) {
    return PlanBenefit(
      id: json['id'] as int?,
      sku: json['sku'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      enabled: json['enabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (sku != null) 'sku': sku,
      'title': title,
      'description': description,
      'enabled': enabled,
    };
  }
}
