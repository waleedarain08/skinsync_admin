import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/clinic_model.dart';
import 'package:skinsync_admin/models/invite_clinic_model.dart';
import 'package:skinsync_admin/models/requests/register_clinic_request_model.dart';
import 'package:skinsync_admin/repositories/clinic_repository.dart';
import 'package:skinsync_admin/utils/dummy_data.dart';
import '../services/locator.dart';
import 'base_state_model.dart';
import 'base_view_model.dart';

final clinicViewModelProvider = NotifierProvider<ClinicViewModel, ClinicState>(
  () => ClinicViewModel._(),
);

class ClinicViewModel extends BaseViewModel<ClinicState> {
  ClinicViewModel._() : super(ClinicState());

  final ClinicRepository _clinicRepository = locator<ClinicRepository>();

  Future<void> initialize() async {
    getClinics();
    getInviteClinics();
  }

  Future<bool> getClinics() async {
    return await runSafely<bool?>(
          showLoading: false,
          onLoadingChange: (loading) {
            state = state.copyWith(loading: loading);
          },
          () async {
            final clinics = await _clinicRepository.getClinics();
            // Original logic for active clinics
            state = state.copyWith(clinics: clinics);
            return true;
          },
        ) ??
        false;
  }

  Future<void> getInviteClinics() async {
    // Pipeline clinics logic using the new InviteClinicModel
    state = state.copyWith(inviteClinics: TreatmentData.dummyInviteClinics);
  }

  void selectInviteClinic(InviteClinicModel clinic) {
    state = state.copyWith(selectedInviteClinic: clinic);
  }

  Future<bool> registerClinic(RegisterClinicReqModel req) async {
    final success =
        await runSafely<bool?>(
          showLoading: false,
          onLoadingChange: (loading) {
            state = state.copyWith(loading: loading);
          },
          () async {
            final clinic = await _clinicRepository.registerClinic(req: req);
            final currentList = state.clinics ?? [];
            state = state.copyWith(clinics: [...currentList, clinic]);
            return true;
          },
        ) ??
        false;

    return success;
  }
}

class ClinicState extends BaseStateModel {
  final List<ClinicModel>? clinics;
  final List<InviteClinicModel>? inviteClinics;
  final InviteClinicModel? selectedInviteClinic;

  ClinicState({
    super.loading,
    this.clinics = const [],
    this.inviteClinics = const [],
    this.selectedInviteClinic,
  });

  ClinicState copyWith({
    bool? loading,
    List<ClinicModel>? clinics,
    List<InviteClinicModel>? inviteClinics,
    InviteClinicModel? selectedInviteClinic,
  }) {
    return ClinicState(
      loading: loading ?? this.loading,
      clinics: clinics ?? this.clinics,
      inviteClinics: inviteClinics ?? this.inviteClinics,
      selectedInviteClinic: selectedInviteClinic ?? this.selectedInviteClinic,
    );
  }
}
