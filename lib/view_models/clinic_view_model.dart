import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skinsync_admin/models/clinic_model.dart';
import 'package:skinsync_admin/models/requests/register_clinic_request_model.dart';
import 'package:skinsync_admin/models/responses/places_response.dart';
import 'package:skinsync_admin/repositories/clinic_repository.dart';
import 'package:skinsync_admin/services/media_service.dart';
import 'package:skinsync_admin/models/responses/clinic_detail_response.dart';
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
    getClinics(page: state.currentPage, limit: state.pageSize);
  }

  Future<bool> getClinics({int? page, int? limit}) async {
    final int targetPage = page ?? state.currentPage;
    final int targetLimit = limit ?? state.pageSize;

    return await runSafely<bool?>(
          showLoading: false,
          onLoadingChange: (loading) {
            state = state.copyWith(loading: loading);
          },
          () async {
            try {
              final clinics = await _clinicRepository.getClinics(
                page: targetPage,
                limit: targetLimit,
              );
              if (clinics.isNotEmpty) {
                state = state.copyWith(
                  clinics: clinics,
                  currentPage: targetPage,
                  pageSize: targetLimit,
                );
                return true;
              }
            } catch (e) {
              // Fail-safe print
            }

            // Fallback to dummy data
            state = state.copyWith(
              clinics: TreatmentData.dummyClinics,
              currentPage: targetPage,
              pageSize: targetLimit,
            );
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

  Future<bool> getInviteClinics({
    int? page,
    int? limit,
    String? search,
    String status = 'onboarding_pending',
  }) async {
    final int targetPage = page ?? state.currentPage;
    final int targetLimit = limit ?? state.pageSize;

    return await runSafely<bool?>(
          showLoading: false,
          onLoadingChange: (loading) {
            state = state.copyWith(loading: loading);
          },
          () async {
            try {
              final invites = await _clinicRepository.getInviteClinics(
                page: targetPage,
                limit: targetLimit,
                search: search,
                status: status,
              );
              if (invites.isNotEmpty) {
                state = state.copyWith(
                  inviteClinics: invites,
                  currentPage: targetPage,
                  pageSize: targetLimit,
                );
                return true;
              }
            } catch (e) {
              // Fail-safe print
            }

            // Fallback to dummy data mapped to ClinicModel
            final fallback = TreatmentData.dummyInviteClinicsDetails
                .map((detail) => ClinicModel(
                      id: detail.id,
                      name: detail.name,
                      email: detail.email,
                      phone: detail.phone,
                      address: detail.address,
                      logo: detail.logo,
                      status: detail.status,
                      createdAt: detail.createdAt,
                      updatedAt: detail.updatedAt,
                    ))
                .toList();
            state = state.copyWith(
              inviteClinics: fallback,
              currentPage: targetPage,
              pageSize: targetLimit,
            );
            return true;
          },
        ) ??
        false;
  }

  void selectInviteClinic(ClinicModel clinic) {
    state = state.copyWith(selectedInviteClinicId: clinic.id);
  }

  void selectClinic(ClinicModel clinic) {
    state = state.copyWith(selectedClinicId: clinic.id);
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
              selectedClinicId: updatedClinic.id,
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
  final List<ClinicModel>? inviteClinics;
  final int? selectedInviteClinicId;
  final int? selectedClinicId;
  final List<Place> searchedPlaces;
  final String? clinicImage;
  final String? bannerImage;
  final int pageSize;

  ClinicDetailResponse? get selectedClinic {
    if (selectedClinicId == null) return null;
    return TreatmentData.dummyClinicsDetails.firstWhereOrNull((c) => c.id == selectedClinicId);
  }

  ClinicDetailResponse? get selectedInviteClinic {
    if (selectedInviteClinicId == null) return null;
    return TreatmentData.dummyInviteClinicsDetails.firstWhereOrNull((c) => c.id == selectedInviteClinicId);
  }

  ClinicState({
    super.loading,
    super.currentPage = 1,
    super.totalPages = 1,
    this.clinics = const [],
    this.inviteClinics = const [],
    this.selectedInviteClinicId,
    this.selectedClinicId,
    this.searchedPlaces = const [],
    this.bannerImage,
    this.clinicImage,
    this.pageSize = 10,
  });

  ClinicState copyWith({
    bool? loading,
    List<ClinicModel>? clinics,
    List<ClinicModel>? inviteClinics,
    int? selectedInviteClinicId,
    int? selectedClinicId,
    List<Place>? searchedPlaces,
    String? bannerImage,
    String? clinicImage,
    int? currentPage,
    int? pageSize,
    int? totalPages,
  }) {
    return ClinicState(
      loading: loading ?? this.loading,
      clinics: clinics ?? this.clinics,
      inviteClinics: inviteClinics ?? this.inviteClinics,
      selectedInviteClinicId: selectedInviteClinicId ?? this.selectedInviteClinicId,
      selectedClinicId: selectedClinicId ?? this.selectedClinicId,
      searchedPlaces: searchedPlaces ?? this.searchedPlaces,
      bannerImage: bannerImage ?? this.bannerImage,
      clinicImage: clinicImage ?? this.clinicImage,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}
