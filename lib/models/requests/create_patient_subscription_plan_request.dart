import '../subscription_duration_option.dart';
import '../subscription_plan_benefit_model.dart';

class CreatePatientSubscriptionPlanRequest {
  final int? id;
  final String? name;
  final double? basePrice;
  final int simulationCount;
  final bool unlimitedSimulations;
  final int postsViewCount;
  final bool unlimitedPostsView;
  final List<int>? assignedPatients;
  final bool isActive;
  final bool isDefault;
  final bool isLifetime;
  final List<SubscriptionDurationOption>? durationOptions;
  final List<PlanBenefit>? benefits;

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
    this.isLifetime = false,
    this.durationOptions,
    this.benefits,
  });

  Map<String, dynamic> toJson() {
    return {
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
        'price': e.basePrice,
      }).toList(),
      'benefits': benefits?.map((e) => e.toJson()).toList(),
      'assigned_patients': assignedPatients,
    };
  }
}
