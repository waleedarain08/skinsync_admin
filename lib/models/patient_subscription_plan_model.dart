class PatientSubscriptionPlanModel {
  final int? id;
  final String? name;
  final double? basePrice;
  final int simulationCount;
  final bool unlimitedSimulations;
  final int postsViewCount;
  final bool unlimitedPostsView;
  final List<String>? assignedPatients;
  final bool isActive;
  final bool isDefault;

  PatientSubscriptionPlanModel({
    this.id,
    this.name,
    this.basePrice,
    this.simulationCount = 0,
    this.unlimitedSimulations = false,
    this.postsViewCount = 0,
    this.unlimitedPostsView = false,
    this.assignedPatients,
    this.isActive = true,
    this.isDefault = false,
  });

  factory PatientSubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return PatientSubscriptionPlanModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      basePrice: (json['base_price'] as num?)?.toDouble(),
      simulationCount: json['simulation_count'] as int? ?? 0,
      // backend sometimes uses 'unlimited_simulation' (singular) or 'unlimited_simulations' (plural)
      unlimitedSimulations: (json['unlimited_simulations'] as bool?) ?? (json['unlimited_simulation'] as bool?) ?? false,
      postsViewCount: json['posts_view_count'] as int? ?? 0,
      unlimitedPostsView: json['unlimited_posts_view'] as bool? ?? false,
      isActive: (json['is_active'] as bool?) ?? true,
      isDefault: (json['is_default'] as bool?) ?? false,
      assignedPatients: json['assigned_patients'] != null
          ? List<String>.from(json['assigned_patients'] as Iterable)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'base_price': basePrice,
      'simulation_count': simulationCount,
      // use singular key to match backend expectation
      'unlimited_simulation': unlimitedSimulations,
      'posts_view_count': postsViewCount,
      'unlimited_posts_view': unlimitedPostsView,
      'is_active': isActive,
      'is_default': isDefault,
      'assigned_patients': assignedPatients,
    };
  }
}
