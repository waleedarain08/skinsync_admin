class PatientSubscriptionPlanModel {
  final int? id;
  final String? name;
  final double? basePrice;
  final int simulationCount;
  final bool unlimitedSimulations;
  final int postsViewCount;
  final bool unlimitedPostsView;
  final List<AssignedPatient>? assignedPatients;
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
      unlimitedSimulations:
          (json['unlimited_simulations'] as bool?) ??
          (json['unlimited_simulation'] as bool?) ??
          false,
      postsViewCount: json['posts_view_count'] as int? ?? 0,
      unlimitedPostsView: json['unlimited_posts_view'] as bool? ?? false,
      isActive: (json['is_active'] as bool?) ?? true,
      isDefault: (json['is_default'] as bool?) ?? false,
      assignedPatients: json['assigned_patients'] != null
          ? List<AssignedPatient>.from(
              (json['assigned_patients'] as List).map(
                (json) =>
                    AssignedPatient.fromJson(json as Map<String, dynamic>),
              ),
            )
          : null,
      // assignedPatients: json['assigned_patients'] != null
      //     ? List<String>.from(json['assigned_patients'] as Iterable)
      //     : null,
    );
  }
}

class AssignedPatient {
  final int? id;
  final int? planId;
  final int? patientId;

  const AssignedPatient({this.id, this.planId, this.patientId});

  factory AssignedPatient.fromJson(Map<String, dynamic> json) {
    return AssignedPatient(
      id: json['id'],
      planId: json['plan_id'],
      patientId: json['patient_id'],
    );
  }
}
