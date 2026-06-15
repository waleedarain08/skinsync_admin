import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/free_system_plan_model.dart';
import '../models/subscription_plan_model.dart';
import '../repositories/subscription_repository.dart';
import '../services/locator.dart';
import '../utils/dummy_data.dart';
import 'base_state_model.dart';
import 'base_view_model.dart';

final subscriptionViewModelProvider = NotifierProvider<SubscriptionViewModel, SubscriptionState>(
  SubscriptionViewModel._,
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
            // Using dummy data for initial design
            final plans = TreatmentData.dummySubscriptionPlans;
            final freeSystemPlan = TreatmentData.dummyFreeSystemPlan;
            state = state.copyWith(plans: plans, freeSystemPlan: freeSystemPlan);
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
            
            if (plan.id != null) {
               state = state.copyWith(
                 plans: currentList.map((p) => p.id == plan.id ? newPlan : p).toList()
               );
            } else {
              state = state.copyWith(plans: [...currentList, newPlan]);
            }
            return true;
          },
        ) ??
        false;

    return success;
  }

  Future<bool> deleteSubscriptionPlan(int id) async {
    final success = await runSafely<bool?>(
          showLoading: true,
          () async {
            // final success = await _subscriptionRepository.deleteSubscriptionPlan(id);
            final currentList = state.plans ?? [];
            state = state.copyWith(plans: currentList.where((p) => p.id != id).toList());
            return true;
          },
        ) ??
        false;

    return success;
  }
}

class SubscriptionState extends BaseStateModel {
  final List<SubscriptionPlanModel>? plans;
  final FreeSystemPlanModel? freeSystemPlan;

  SubscriptionState({
    super.loading,
    this.plans = const [],
    this.freeSystemPlan,
  });

  SubscriptionState copyWith({
    bool? loading,
    List<SubscriptionPlanModel>? plans,
    FreeSystemPlanModel? freeSystemPlan,
  }) {
    return SubscriptionState(
      loading: loading ?? this.loading,
      plans: plans ?? this.plans,
      freeSystemPlan: freeSystemPlan ?? this.freeSystemPlan,
    );
  }
}
