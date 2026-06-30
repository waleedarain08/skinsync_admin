import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skinsync_admin/models/clinic_model.dart';
import 'package:skinsync_admin/models/invite_clinic_model.dart';
import 'package:skinsync_admin/models/requests/register_clinic_request_model.dart';
import 'package:skinsync_admin/models/responses/places_response.dart';
import 'package:skinsync_admin/repositories/clinic_repository.dart';
import 'package:skinsync_admin/services/media_service.dart';
import 'package:skinsync_admin/utils/dummy_data.dart';
import 'package:skinsync_admin/utils/exception.dart';

import '../services/location_service.dart';
import '../services/locator.dart';
import 'base_state_model.dart';
import 'base_view_model.dart';

final clinicViewModelProvider = NotifierProvider<ClinicViewModel, ClinicState>(
  ClinicViewModel._,
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

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(bool clinicImage) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    await runSafely(() async {
      final path = clinicImage ? 'clinic/bannner/' : 'clinic/image/';
      final String? url = await MediaService().uploadImage(path, image);
      if (url == null) {
        throw const UnknownException('Failed to upload image');
      }
      if (clinicImage) {
        state = state.copyWith(clinicImage: url);
      } else {
        state = state.copyWith(bannerImage: url);
      }
    });
  }

  void removeBanner() {
    state = state.copyWith(bannerImage: '');
  }

  void removeClinicImage() {
    state = state.copyWith(clinicImage: '');
  }

  Future<void> getInviteClinics() async {
    // Pipeline clinics logic using the new InviteClinicModel
    state = state.copyWith(inviteClinics: TreatmentData.dummyInviteClinics);
  }

  void selectInviteClinic(InviteClinicModel clinic) {
    state = state.copyWith(selectedInviteClinic: clinic);
  }

  void selectClinic(ClinicModel clinic) {
    state = state.copyWith(selectedClinic: clinic);
  }

  Future<bool> updateClinic(int id, RegisterClinicReqModel req) async {
    final success =
        await runSafely<bool?>(
          showLoading: false,
          onLoadingChange: (loading) {
            state = state.copyWith(loading: loading);
          },
          () async {
            final updatedClinic = await _clinicRepository.updateClinic(
              id: id,
              req: req,
            );
            final currentList = state.clinics ?? [];
            final newList = currentList
                .map((c) => c.id == id ? updatedClinic : c)
                .toList();
            state = state.copyWith(
              clinics: newList,
              selectedClinic: updatedClinic,
            );
            return true;
          },
        ) ??
        false;

    return success;
  }

  Future<bool?> registerClinic(
    RegisterClinicReqModel req,
    XFile? clinicLogoFile,
  ) async {
    return await runSafely<bool?>(
      showLoading: false,
      onLoadingChange: (loading) {
        state = state.copyWith(loading: loading);
      },
      () async {
        final clinic = await _clinicRepository.registerClinic(
          req: req.copyWithLogo(state.clinicImage, state.bannerImage),
        );
        if(clinic.isSuccess){
          await getClinics();
        }

        // final currentList = state.clinics ?? [];
        // state = state.copyWith(clinics: [...currentList, clinic]);
        return true;
      },
    );
  }

  Future<void> searchPlaces(String? query) async {
    return await runSafely(() async {
      if (query == null || query.isEmpty) {
        clearSearchedPlaces();
        return;
      }
      final places = await LocationService().fetchNearbyClinics(query);
      state = state.copyWith(searchedPlaces: places);
    });
  }

  void clearSearchedPlaces() {
    state = state.copyWith(searchedPlaces: []);
  }
}

class ClinicState extends BaseStateModel {
  final List<ClinicModel>? clinics;
  final List<InviteClinicModel>? inviteClinics;
  final InviteClinicModel? selectedInviteClinic;
  final ClinicModel? selectedClinic;
  final List<Place> searchedPlaces;
  final String? clinicImage;
  final String? bannerImage;

  ClinicState({
    super.loading,
    this.clinics = const [],
    this.inviteClinics = const [],
    this.selectedInviteClinic,
    this.selectedClinic,
    this.searchedPlaces = const [],
    this.bannerImage,
    this.clinicImage,
  });

  ClinicState copyWith({
    bool? loading,
    List<ClinicModel>? clinics,
    List<InviteClinicModel>? inviteClinics,
    InviteClinicModel? selectedInviteClinic,
    ClinicModel? selectedClinic,
    List<Place>? searchedPlaces,
    String? bannerImage,
    String? clinicImage,
  }) {
    return ClinicState(
      loading: loading ?? this.loading,
      clinics: clinics ?? this.clinics,
      inviteClinics: inviteClinics ?? this.inviteClinics,
      selectedInviteClinic: selectedInviteClinic ?? this.selectedInviteClinic,
      selectedClinic: selectedClinic ?? this.selectedClinic,
      searchedPlaces: searchedPlaces ?? this.searchedPlaces,
      bannerImage: bannerImage ?? this.bannerImage,
      clinicImage: clinicImage ?? this.clinicImage,
    );
  }
}
