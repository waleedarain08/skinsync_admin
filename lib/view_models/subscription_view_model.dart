import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/clinic_subscription_plan_model.dart';
import '../models/patient_subscription_plan_model.dart';
import '../models/requests/create_benefit_request.dart';
import '../models/requests/create_clinic_subscription_plan_request.dart';
import '../models/requests/create_patient_subscription_plan_request.dart';
import '../models/requests/create_subscription_duration_request.dart';
import '../models/responses/base_response_model.dart';
import '../models/subscription_duration_model.dart';
import '../models/subscription_plan_benefit_model.dart';
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
    await Future.wait([
      getSubscriptionPlans(),
      getPatientSubscriptionPlans(),
      getBenefits(),
      //getSubscriptionDurations(),
    ]);
  }

  // ---------------- CLINICS ----------------

  Future<void> getSubscriptionPlans() async {
    return await runSafely(
      showLoading: false,
      onLoadingChange: (loading) {
        state = state.copyWith(loading: loading);
      },
      () async {
        final response = await _subscriptionRepository.getSubscriptionPlans();
        state = state.copyWith(plans: response.data);
      },
    );
  }

  Future<bool> createClinicSubscriptionPlan(
    CreateClinicSubscriptionPlanRequest request,
  ) async {
    final success =
        await runSafely<bool?>(showLoading: true, () async {
          if (request.id != null) {
            await _subscriptionRepository.updateSubscriptionPlan(
              request.id!,
              request,
            );
          } else {
            await _subscriptionRepository
                .createClinicSubscriptionPlan(request);
          }

          await getSubscriptionPlans();
          return true;
        }) ??
        false;

    return success;
  }

  Future<bool> deleteSubscriptionPlan(int id) async {
    final success =
        await runSafely<bool?>(showLoading: true, () async {
          final response = await _subscriptionRepository.deleteSubscriptionPlan(id);
          if (response.isSuccess) {
            final currentList = state.plans ?? [];
            state = state.copyWith(
              plans: currentList.where((p) => p.id != id).toList(),
            );
            return true;
          }
          return false;
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
        final response = await _subscriptionRepository
            .getPatientSubscriptionPlans();
        state = state.copyWith(patientPlans: response.data);
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
          final response = await _subscriptionRepository.deletePatientSubscriptionPlan(id);
          if (response.isSuccess) {
            final currentList = state.patientPlans ?? [];
            state = state.copyWith(
              patientPlans: currentList.where((p) => p.id != id).toList(),
            );
            return true;
          }
          return false;
        }) ??
        false;

    return success;
  }

  // ---------------- BENEFITS ----------------

  Future<void> getBenefits() async {
    return await runSafely(
      showLoading: false,
      onLoadingChange: (loading) {
        state = state.copyWith(loading: loading);
      },
      () async {
        final response =
            await _subscriptionRepository.getBenefits();
        state = state.copyWith(patientBenefits: response.data);
      },
    );
  }

  Future<BaseApiResponseModel<dynamic>?> createBenefit(
    CreateBenefitRequest request,
  ) async {
    final response = await runSafely<BaseApiResponseModel<dynamic>>(
      showLoading: true,
      () async {
        final res = await _subscriptionRepository.createBenefit(request);
        if (res.isSuccess) {
          await getBenefits();
        }
        return res;
      },
    );
    return response;
  }

  // ---------------- DURATIONS ----------------

  Future<void> getSubscriptionDurations({bool showLoading = false}) async {
    return await runSafely(
      showLoading: showLoading,
      onLoadingChange: (loading) {
        state = state.copyWith(loading: loading);
      },
      () async {
        final response = await _subscriptionRepository.getSubscriptionDurations();
        state = state.copyWith(durations: response.data);
      },
    );
  }

  Future<BaseApiResponseModel<dynamic>?> createSubscriptionDuration(CreateSubscriptionDurationRequest request) async {
    final response =
        await runSafely<BaseApiResponseModel<dynamic>>(showLoading: true, () async {
          final res = await _subscriptionRepository.createSubscriptionDuration(request);
          if (res.isSuccess) {
            await getSubscriptionDurations();
          }
          return res;
        });
    return response;
  }
}

class SubscriptionState extends BaseStateModel {
  final List<ClinicSubscriptionPlanModel>? plans;
  final List<PatientSubscriptionPlanModel>? patientPlans;
  final List<SubscriptionDuration>? durations;
  final List<PlanBenefit>? patientBenefits;

  SubscriptionState({
    super.loading,
    this.plans = const [],
    this.patientPlans = const [],
    this.durations = const [],
    this.patientBenefits = const [],
  });

  SubscriptionState copyWith({
    bool? loading,
    List<ClinicSubscriptionPlanModel>? plans,
    List<PatientSubscriptionPlanModel>? patientPlans,
    List<SubscriptionDuration>? durations,
    List<PlanBenefit>? patientBenefits,
  }) {
    return SubscriptionState(
      loading: loading ?? this.loading,
      plans: plans ?? this.plans,
      patientPlans: patientPlans ?? this.patientPlans,
      durations: durations ?? this.durations,
      patientBenefits: patientBenefits ?? this.patientBenefits,
    );
  }
}
