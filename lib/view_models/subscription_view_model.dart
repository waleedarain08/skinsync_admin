import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/subscription_plan_model.dart';
import '../repositories/subscription_repository.dart';
import '../services/locator.dart';
import 'base_state_model.dart';
import 'base_view_model.dart';

final subscriptionViewModelProvider = NotifierProvider<SubscriptionViewModel, SubscriptionState>(
  () => SubscriptionViewModel._(),
);

class SubscriptionViewModel extends BaseViewModel<SubscriptionState> {
  SubscriptionViewModel._() : super(SubscriptionState());

  final SubscriptionRepository _subscriptionRepository = locator<SubscriptionRepository>();

  Future<void> initialize() async {
    getSubscriptionPlans();
  }

  Future<bool> getSubscriptionPlans() async {
    return await runSafely<bool?>(
          showLoading: false,
          onLoadingChange: (loading) {
            state = state.copyWith(loading: loading);
          },
          () async {
            // Using dummy data if API fails or for initial design
            final plans = await _subscriptionRepository.getSubscriptionPlans();
            state = state.copyWith(plans: plans);
            return true;
          },
        ) ??
        false;
  }

  Future<bool> createSubscriptionPlan(SubscriptionPlanModel plan) async {
    final success = await runSafely<bool?>(
          showLoading: true,
          () async {
            final newPlan = await _subscriptionRepository.createSubscriptionPlan(plan);
            final currentList = state.plans ?? [];
            state = state.copyWith(plans: [...currentList, newPlan]);
            return true;
          },
        ) ??
        false;

    return success;
  }
}

class SubscriptionState extends BaseStateModel {
  final List<SubscriptionPlanModel>? plans;

  SubscriptionState({
    super.loading,
    this.plans = const [],
  });

  SubscriptionState copyWith({
    bool? loading,
    List<SubscriptionPlanModel>? plans,
  }) {
    return SubscriptionState(
      loading: loading ?? this.loading,
      plans: plans ?? this.plans,
    );
  }
}
