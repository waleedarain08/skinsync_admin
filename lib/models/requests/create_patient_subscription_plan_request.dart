import '../subscription_duration_option.dart';

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
  final List<int>? benefitIds;

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
    this.benefitIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'simulation_count': simulationCount,
      'unlimited_simulation': unlimitedSimulations,
      'posts_view_count': postsViewCount,
      'unlimited_posts_view': unlimitedPostsView,
      'is_active': isActive,
      'is_default': isDefault,
      'is_lifetime': isLifetime,
      'base_price': basePrice, // Now allowing null/actual value as per CURL
      'assigned_patients': assignedPatients,
      'duration_options': durationOptions?.map((e) => {
        'duration_id': e.duration?.id,
        'price': e.basePrice,
      }).toList(),
      'benefit_ids': benefitIds,
    };
  }
}
