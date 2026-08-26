class PlanBenefit {
  String? title;
  String? description;
  int? freeMonths; // Kept for model flexibility but will be hidden from normal plan UI
  bool enabled;

  PlanBenefit({this.title, this.description, this.freeMonths, this.enabled = true});

  factory PlanBenefit.fromJson(Map<String, dynamic> json) {
    return PlanBenefit(
      title: json['title'],
      description: json['description'],
      freeMonths: json['free_months'],
      enabled: json['enabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'free_months': freeMonths,
      'enabled': enabled,
    };
  }
}
