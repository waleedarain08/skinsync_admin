import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/clinic_model.dart';
import 'package:skinsync_admin/models/requests/register_clinic_request_model.dart';
import 'package:skinsync_admin/repositories/clinic_repository.dart';
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
  }

  Future<bool> getClinics() async {
    return await runSafely<bool?>(
          showLoading: false,
          onLoadingChange: (loading) {
            state = state.copyWith(loading: loading);
          },
          () async {
            final clinics = await _clinicRepository.getClinics();
            state = state.copyWith(clinics: clinics);
            return true;
          },
        ) ??
        false;
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
  List<ClinicModel>? clinics = [];
  ClinicState({super.loading, this.clinics = const []});

  ClinicState copyWith({bool? loading, List<ClinicModel>? clinics}) {
    return ClinicState(
      loading: loading ?? this.loading,
      clinics: clinics ?? this.clinics,
    );
  }
}
