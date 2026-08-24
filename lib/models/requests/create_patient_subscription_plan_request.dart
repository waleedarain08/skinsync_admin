import '../patient_subscription_plan_model.dart';

class CreatePatientSubscriptionPlanRequest {
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

  CreatePatientSubscriptionPlanRequest({
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

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'base_price': basePrice,
      'simulation_count': simulationCount,
      // backend expects singular key
      'unlimited_simulation': unlimitedSimulations,
      'posts_view_count': postsViewCount,
      'unlimited_posts_view': unlimitedPostsView,
      'is_active': isActive,
      'is_default': isDefault,
      'assigned_patients': assignedPatients,
    };
  }

  factory CreatePatientSubscriptionPlanRequest.fromModel(PatientSubscriptionPlanModel model) {
    return CreatePatientSubscriptionPlanRequest(
      id: model.id,
      name: model.name,
      basePrice: model.basePrice,
      simulationCount: model.simulationCount,
      unlimitedSimulations: model.unlimitedSimulations,
      postsViewCount: model.postsViewCount,
      unlimitedPostsView: model.unlimitedPostsView,
      assignedPatients: model.assignedPatients,
      isActive: model.isActive,
      isDefault: model.isDefault,
    );
  }
}
