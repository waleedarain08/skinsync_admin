class SubscriptionPlanModel {
  int? id;
  String? name;
  double? basePrice;
  List<PlanBenefit>? benefits;
  bool isActive;

  SubscriptionPlanModel({
    this.id,
    this.name,
    this.basePrice,
    this.benefits,
    this.isActive = true,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      id: json['id'],
      name: json['name'],
      basePrice: json['base_price']?.toDouble(),
      isActive: json['is_active'] ?? true,
      benefits: json['benefits'] != null
          ? (json['benefits'] as List).map((e) => PlanBenefit.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'base_price': basePrice,
      'is_active': isActive,
      'benefits': benefits?.map((e) => e.toJson()).toList(),
    };
  }
}

class PlanBenefit {
  String? title;
  String? description;
  int? freeMonths; // For the specific requirement "First time if a clinic joins, $0 charges will apply"

  PlanBenefit({this.title, this.description, this.freeMonths});

  factory PlanBenefit.fromJson(Map<String, dynamic> json) {
    return PlanBenefit(
      title: json['title'],
      description: json['description'],
      freeMonths: json['free_months'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'free_months': freeMonths,
    };
  }
}
