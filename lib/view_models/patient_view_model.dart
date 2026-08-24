import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/responses/patient_detail_response.dart';
import '../models/responses/patient_list_response.dart';
import '../models/responses/patient_treatment_request_response.dart';
import '../repositories/patient_repository.dart';
import '../services/locator.dart';
import 'base_state_model.dart';
import 'base_view_model.dart';

final patientProvider =
    NotifierProvider.autoDispose<PatientViewModel, PatientState>(
      PatientViewModel.new,
    );

class PatientViewModel extends BaseViewModel<PatientState> {
  PatientViewModel() : super(PatientState());

  final TextEditingController searchController = TextEditingController();
  final PatientRepository _repository = locator<PatientRepository>();

  void setPageNumber(int page) {
    state = state.copyWith(page: page);
    getPatients(initialCall: false);
  }

  Future<void> getPatients({
    bool initialCall = false,
    bool showEasyLoading = true,
  }) async {
    if (initialCall) {
      state = state.copyWith(page: 1);
    }

    await runSafely(
      showLoading: showEasyLoading,
      onLoadingChange: (loading) {
        if (!showEasyLoading) {
          state = state.copyWith(loading: loading);
        }
      },
      () async {
        final response = await _repository.getPatients(
          page: state.page,
          limit: state.pageSize,
          search: searchController.text,
        );

        state = state.copyWith(
          patients: response.data ?? [],
          totalPage: response.totalPages,
          totalResults: response.totalResults,
          totalPatients: response.totalPatients,
          totalRequest: response.totalRequest,
          page: response.page,
        );
      },
    );
  }

  void searchPatients() {
    getPatients(initialCall: true);
  }

  void clearSearch() {
    searchController.clear();
    getPatients(initialCall: true);
  }

  Future<bool> getPatientDetail({required int patientId}) async {
    final result = await runSafely<bool>(
      showLoading: true,
      onLoadingChange: (loading) =>
          state = state.copyWith(detailLoading: loading),
      () async {
        final response = await _repository.getPatientDetail(
          patientId: patientId,
        );
        state = state.copyWith(patientDetail: response.data);
        return true;
      },
    );
    return result ?? false;
  }

  void clearPatientDetail() {
    state = state.copyWith(clearPatientDetail: true);
  }

  void setTreatmentPageNumber(int page) {
    state = state.copyWith(treatmentPage: page);
    getPatientTreatmentRequests(patientId: state.patientDetail?.id);
  }

  Future<void> getPatientTreatmentRequests({
    bool initialCall = false,
    bool showEasyLoading = true,
    int? patientId,
  }) async {
    if (initialCall) {
      state = state.copyWith(treatmentPage: 1);
    }

    await runSafely(
      showLoading: showEasyLoading,
      onLoadingChange: (loading) =>
          state = state.copyWith(treatmentLoading: loading),
      () async {
        final response = await _repository.getPatientTreatmentRequests(
          page: state.treatmentPage,
          limit: state.treatmentPageSize,
          patientId: patientId,
        );

        state = state.copyWith(
          treatmentRequests: response.data ?? [],
          treatmentTotalPage: response.totalPages,
          treatmentTotalResults: response.total,
          treatmentPage: response.page,
        );
      },
    );
  }

  @override
  @mustCallSuper
  void onError(String message) {
    super.onError(message);
    state = state.copyWith(loading: false);
    EasyLoading.dismiss();
  }
}

class PatientState extends BaseStateModel {
  final int page;
  final int pageSize;
  final int? totalPage;
  final int? totalRequest;
  final int? totalPatients;
  final List<PatientData> patients;
  final bool detailLoading;
  final PatientDetailData? patientDetail;
  final bool treatmentLoading;
  final int treatmentPage;
  final int treatmentPageSize;
  final int? treatmentTotalPage;
  final int? treatmentTotalResults;
  final List<PatientTreatmentRequestData> treatmentRequests;

  PatientState({
    super.loading = false,
    this.page = 1,
    this.pageSize = 10,
    this.totalPage = 1,
    super.totalResults = 0,
    this.totalPatients,
    this.totalRequest,
    this.patients = const [],
    this.detailLoading = false,
    this.patientDetail,
    this.treatmentLoading = false,
    this.treatmentPage = 1,
    this.treatmentPageSize = 10,
    this.treatmentTotalPage = 1,
    this.treatmentTotalResults = 0,
    this.treatmentRequests = const [],
  }) : super(currentPage: page, totalPages: totalPage ?? 1);

  PatientState copyWith({
    bool? loading,
    int? page,
    int? pageSize,
    int? totalPage,
    int? totalResults,
    List<PatientData>? patients,
    bool? detailLoading,
    PatientDetailData? patientDetail,
    bool clearPatientDetail = false,
    bool? treatmentLoading,
    int? treatmentPage,
    int? treatmentPageSize,
    int? treatmentTotalPage,
    int? treatmentTotalResults,
    List<PatientTreatmentRequestData>? treatmentRequests,
    int? totalRequest,
    int? totalPatients,
  }) {
    return PatientState(
      loading: loading ?? this.loading,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      totalPage: totalPage ?? this.totalPage,
      totalResults: totalResults ?? this.totalResults,
      patients: patients ?? this.patients,
      detailLoading: detailLoading ?? this.detailLoading,
      patientDetail: clearPatientDetail
          ? null
          : (patientDetail ?? this.patientDetail),
      treatmentLoading: treatmentLoading ?? this.treatmentLoading,
      treatmentPage: treatmentPage ?? this.treatmentPage,
      treatmentPageSize: treatmentPageSize ?? this.treatmentPageSize,
      treatmentTotalPage: treatmentTotalPage ?? this.treatmentTotalPage,
      treatmentTotalResults:
          treatmentTotalResults ?? this.treatmentTotalResults,
      treatmentRequests: treatmentRequests ?? this.treatmentRequests,
      totalPatients: totalPatients ?? this.totalPatients,
      totalRequest: totalRequest ?? this.totalRequest,
    );
  }
}
