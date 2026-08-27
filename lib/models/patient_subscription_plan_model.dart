import 'subscription_duration_option.dart';
import 'subscription_plan_benefit_model.dart';

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
  final bool isLifetime;
  final List<SubscriptionDurationOption>? durationOptions;
  final List<PlanBenefit>? benefits;

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
    this.isLifetime = false,
    this.durationOptions,
    this.benefits,
  });

  factory PatientSubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return PatientSubscriptionPlanModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      basePrice: (json['base_price'] as num?)?.toDouble(),
      simulationCount: json['simulation_count'] as int? ?? 0,
      unlimitedSimulations:
          (json['unlimited_simulations'] as bool?) ??
          (json['unlimited_simulation'] as bool?) ??
          false,
      postsViewCount: json['posts_view_count'] as int? ?? 0,
      unlimitedPostsView: json['unlimited_posts_view'] as bool? ?? false,
      isActive: (json['is_active'] as bool?) ?? true,
      isDefault: (json['is_default'] as bool?) ?? false,
      isLifetime: (json['is_lifetime'] as bool?) ?? false,
      durationOptions: json['duration_options'] != null
          ? (json['duration_options'] as List)
              .map((e) =>
                  SubscriptionDurationOption.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      benefits: json['benefits'] != null
          ? (json['benefits'] as List)
              .map((e) => PlanBenefit.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      assignedPatients: json['assigned_patients'] != null
          ? List<AssignedPatient>.from(
              (json['assigned_patients'] as List).map(
                (json) =>
                    AssignedPatient.fromJson(json as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'base_price': basePrice,
      'simulation_count': simulationCount,
      'unlimited_simulation': unlimitedSimulations,
      'posts_view_count': postsViewCount,
      'unlimited_posts_view': unlimitedPostsView,
      'is_active': isActive,
      'is_default': isDefault,
      'is_lifetime': isLifetime,
      'duration_options': durationOptions?.map((e) => {
        'duration_id': e.duration?.id,
        'base_price': e.basePrice,
      }).toList(),
      'benefits': benefits?.map((e) => e.toJson()).toList(),
      'assigned_patients': assignedPatients?.map((e) => e.patientId).toList(),
    };
  }
}

class AssignedPatient {
  final int? id;
  final int? planId;
  final int? patientId;
  final String? patientName;

  const AssignedPatient({this.id, this.planId, this.patientId, this.patientName});

  factory AssignedPatient.fromJson(Map<String, dynamic> json) {
    return AssignedPatient(
      id: json['id'],
      planId: json['plan_id'],
      patientId: json['patient_id'],
      patientName: json['patient_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plan_id': planId,
      'patient_id': patientId,
      'patient_name': patientName,
    };
  }
}
