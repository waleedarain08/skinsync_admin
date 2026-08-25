import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/clinic_subscription_plan_model.dart';
import '../models/patient_subscription_plan_model.dart';
import '../models/requests/create_clinic_subscription_plan_request.dart';
import '../models/requests/create_patient_subscription_plan_request.dart';
import '../repositories/subscription_repository.dart';
import '../services/locator.dart';
import 'base_state_model.dart';
import 'base_view_model.dart';

final subscriptionViewModelProvider =
    NotifierProvider<SubscriptionViewModel, SubscriptionState>(
      SubscriptionViewModel._,
    );

class SubscriptionViewModel extends BaseViewModel<SubscriptionState> {
  SubscriptionViewModel._() : super(SubscriptionState());

  final SubscriptionRepository _subscriptionRepository =
      locator<SubscriptionRepository>();

  Future<void> initialize() async {
    await Future.wait([getSubscriptionPlans(), getPatientSubscriptionPlans()]);
  }

  // ---------------- CLINICS ----------------

  Future<void> getSubscriptionPlans() async {
    return await runSafely(
      showLoading: false,
      onLoadingChange: (loading) {
        state = state.copyWith(loading: loading);
      },
      () async {
        final plans = await _subscriptionRepository.getSubscriptionPlans();
        state = state.copyWith(plans: plans);
      },
    );
  }

  Future<bool> createClinicSubscriptionPlan(
    CreateClinicSubscriptionPlanRequest request,
  ) async {
    final success =
        await runSafely<bool?>(showLoading: true, () async {
          final ClinicSubscriptionPlanModel newPlan;
          if (request.id != null) {
            newPlan = await _subscriptionRepository.updateSubscriptionPlan(
              request.id!,
              request,
            );
          } else {
            newPlan = await _subscriptionRepository
                .createClinicSubscriptionPlan(request);
          }

          final currentList = state.plans ?? [];

          if (request.id != null) {
            state = state.copyWith(
              plans: currentList
                  .map((p) => p.id == request.id ? newPlan : p)
                  .toList(),
            );
          } else {
            state = state.copyWith(plans: [...currentList, newPlan]);
          }
          return true;
        }) ??
        false;

    return success;
  }

  Future<bool> deleteSubscriptionPlan(int id) async {
    final success =
        await runSafely<bool?>(showLoading: true, () async {
          await _subscriptionRepository.deleteSubscriptionPlan(id);
          final currentList = state.plans ?? [];
          state = state.copyWith(
            plans: currentList.where((p) => p.id != id).toList(),
          );
          return true;
        }) ??
        false;

    return success;
  }

  // ---------------- PATIENTS ----------------

  Future<void> getPatientSubscriptionPlans() async {
    return await runSafely(
      showLoading: false,
      onLoadingChange: (loading) {
        state = state.copyWith(loading: loading);
      },
      () async {
        final plans = await _subscriptionRepository
            .getPatientSubscriptionPlans();
        state = state.copyWith(patientPlans: plans);
      },
    );
  }

  Future<bool?> createPatientSubscriptionPlan(
    CreatePatientSubscriptionPlanRequest request,
  ) async {
    return await runSafely<bool?>(showLoading: true, () async {
      if (request.id != null) {
        await _subscriptionRepository.updatePatientSubscriptionPlan(
          request.id!,
          request,
        );
      } else {
        await _subscriptionRepository.createPatientSubscriptionPlan(request);
      }
      await getPatientSubscriptionPlans();
      return true;
    });
  }

  Future<bool> deletePatientSubscriptionPlan(int id) async {
    final success =
        await runSafely<bool?>(showLoading: true, () async {
          await _subscriptionRepository.deletePatientSubscriptionPlan(id);
          final currentList = state.patientPlans ?? [];
          state = state.copyWith(
            patientPlans: currentList.where((p) => p.id != id).toList(),
          );
          return true;
        }) ??
        false;

    return success;
  }
}

class SubscriptionState extends BaseStateModel {
  final List<ClinicSubscriptionPlanModel>? plans;
  final List<PatientSubscriptionPlanModel>? patientPlans;

  SubscriptionState({
    super.loading,
    this.plans = const [],
    this.patientPlans = const [],
  });

  SubscriptionState copyWith({
    bool? loading,
    List<ClinicSubscriptionPlanModel>? plans,
    List<PatientSubscriptionPlanModel>? patientPlans,
  }) {
    return SubscriptionState(
      loading: loading ?? this.loading,
      plans: plans ?? this.plans,
      patientPlans: patientPlans ?? this.patientPlans,
    );
  }
}
