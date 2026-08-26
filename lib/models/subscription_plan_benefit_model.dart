class PlanBenefit {
  String? title;
  String? description;
  bool enabled;

  PlanBenefit({this.title, this.description, this.enabled = true});

  factory PlanBenefit.fromJson(Map<String, dynamic> json) {
    return PlanBenefit(
      title: json['title'],
      description: json['description'],
      enabled: json['enabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'enabled': enabled,
    };
  }
}
