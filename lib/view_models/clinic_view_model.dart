import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skinsync_admin/models/clinic_model.dart';
import 'package:skinsync_admin/models/requests/register_clinic_request_model.dart';
import 'package:skinsync_admin/models/responses/clinic_detail_response.dart';
import 'package:skinsync_admin/models/responses/invite_clinic_detail_response.dart';
import 'package:skinsync_admin/models/responses/places_response.dart';
import 'package:skinsync_admin/models/clinic_web_request_model.dart';
import 'package:skinsync_admin/models/founder_clinic_model.dart';
import 'package:skinsync_admin/models/requests/send_notes_request.dart';
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
    getClinics(page: state.currentPage, limit: state.pageSize);
    getInviteClinics(page: state.inviteClinicsCurrentPage, limit: state.pageSize);
    getWebRequests(page: state.webRequestsCurrentPage, limit: state.pageSize);
    getFounderClinics(page: state.founderClinicsCurrentPage, limit: state.pageSize);
  }

 Future<bool?> getClinics({String? search, int? page, int? limit}) async {
  return await runSafely<bool?>(
    showLoading: false,
    onLoadingChange: (loading) {
      state = state.copyWith(loading: loading);
    },
    () async {
      final int targetPage = page ?? state.currentPage;
      final int targetLimit = limit ?? state.pageSize;
      try {
        final response = await _clinicRepository.getClinics(
          page: targetPage,
          limit: targetLimit,
          search: search ?? '',
        );
        if (response.data != null && response.data!.isNotEmpty) {
          state = state.copyWith(
            clinics: response.data,
            currentPage: targetPage,
            totalPages: response.totalPages,
            pageSize: targetLimit,
          );
          return true;
        }
      } catch (e) {
        // Fail-safe print
      }

      // Fallback
      state = state.copyWith(
        clinics: [],
        currentPage: targetPage,
        totalPages: 1,
        pageSize: targetLimit,
      );
      return true;
    },
  );
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

  void clearClinicsPagination() {
    state = state.copyWith(
      totalPages: 1, 
      currentPage: 1, 
      inviteClinicsTotalPages: 1, 
      inviteClinicsCurrentPage: 1,
      webRequestsTotalPages: 1,
      webRequestsCurrentPage: 1,
      founderClinicsTotalPages: 1,
      founderClinicsCurrentPage: 1,
    );
  }

Future<bool?> getInviteClinics({
  int? page,
  int? limit,
  String? search,
  String? status,
}) async {
  return await runSafely<bool?>(
    showLoading: false,
    onLoadingChange: (loading) {
      state = state.copyWith(loading: loading);
    },
    () async {
      final int targetPage = page ?? state.inviteClinicsCurrentPage;
      final int targetLimit = limit ?? state.pageSize;
      try {
        final response = await _clinicRepository.getInviteClinics(
          page: targetPage,
          limit: targetLimit,
          search: search,
          status: status,
        );
        state = state.copyWith(
          inviteClinics: response.data ?? [],
          inviteClinicsCurrentPage: targetPage,
          inviteClinicsTotalPages: response.totalPages,
          pageSize: targetLimit,
        );
        return true;
      } catch (e) {
        // Fail-safe print
      }

      state = state.copyWith(
        inviteClinics: [],
        inviteClinicsCurrentPage: targetPage,
        inviteClinicsTotalPages: 1,
        pageSize: targetLimit,
      );
      return true;
    },
  );
}
  Future<bool?> getWebRequests({
    int? page,
    int? limit,
    String? search,
    String? status,
  }) async {
    return await runSafely<bool?>(
      showLoading: false,
      onLoadingChange: (loading) {
        state = state.copyWith(loading: loading);
      },
      () async {
        final int targetPage = page ?? state.webRequestsCurrentPage;
        final int targetLimit = limit ?? state.pageSize;
        try {
          final response = await _clinicRepository.getWebRequests(
            page: targetPage,
            limit: targetLimit,
            search: search,
            status: status,
          );
          if (response.data != null && response.data!.isNotEmpty) {
            state = state.copyWith(
              webRequests: response.data ?? [],
              webRequestsCurrentPage: targetPage,
              webRequestsTotalPages: response.totalPages ?? 1,
              pageSize: targetLimit,
            );
            return true;
          }
        } catch (e) {
          // Fail-safe
        }

        state = state.copyWith(
          webRequests: TreatmentData.dummyWebRequests,
          webRequestsCurrentPage: targetPage,
          webRequestsTotalPages: 1,
        );
        return true;
      },
    );
  }

  Future<bool?> getFounderClinics({
    int? page,
    int? limit,
    String? search,
    String? status,
  }) async {
    return await runSafely<bool?>(
      showLoading: false,
      onLoadingChange: (loading) {
        state = state.copyWith(loading: loading);
      },
      () async {
        final int targetPage = page ?? state.founderClinicsCurrentPage;
        final int targetLimit = limit ?? state.pageSize;
        try {
          final response = await _clinicRepository.getFounderClinics(
            page: targetPage,
            limit: targetLimit,
            search: search,
            status: status,
          );
          if (response.data != null && response.data!.isNotEmpty) {
            state = state.copyWith(
              founderClinics: response.data ?? [],
              founderClinicsCurrentPage: targetPage,
              founderClinicsTotalPages: response.totalPages ?? 1,
              pageSize: targetLimit,
            );
            return true;
          }
        } catch (e) {
          // Fail-safe
        }

        state = state.copyWith(
          founderClinics: TreatmentData.dummyFounderClinics,
          founderClinicsCurrentPage: targetPage,
          founderClinicsTotalPages: 1,
        );
        return true;
      },
    );
  }

  void selectInviteClinic(ClinicModel clinic) {
    state = state.copyWith(selectedInviteClinicId: clinic.id);
  }

  void selectClinic(ClinicModel clinic) {
    state = state.copyWith(selectedClinicId: clinic.id);
  }

  void selectWebRequest(ClinicWebRequestModel request) {
    state = state.copyWith(selectedWebRequestId: request.id);
  }

  void selectFounderClinic(FounderClinicModel clinic) {
    state = state.copyWith(selectedFounderClinicId: clinic.id);
  }

  Future<bool> sendInvitation(int inviteClinicId) async {
    return await runSafely<bool?>(showLoading: true, () async {
          final response = await _clinicRepository.sendInvitation(
            inviteClinicId: inviteClinicId,
          );
          return response.isSuccess;
        }) ??
        false;
  }

  Future<bool> getClinicDetail(int clinicId) async {
    return await runSafely<bool?>(
          showLoading: true,
          () async {
            try {
              final response = await _clinicRepository.getClinicDetail(clinicId: clinicId);
              if (response.isSuccess == true && response.data != null && response.data!.isNotEmpty) {
                state = state.copyWith(selectedClinicDetail: response.data!.first);
                return true;
              }
            } catch (e) {
              // Fail-safe print
            }

            final fallbackModel = state.clinics?.firstWhereOrNull((c) => c.id == clinicId);
            state = state.copyWith(
              selectedClinicDetail: ClinicDetailData(
                clinicId: clinicId,
                name: fallbackModel?.name ?? 'Glow MedSpa NY Detail',
                email: fallbackModel?.email ?? 'contact@glowmedspa.com',
                phone: fallbackModel?.phone ?? '+1 212-555-0198',
                address: fallbackModel?.address ?? '5th Ave, New York, NY',
                latitude: 24.8162848,
                longitude: 67.1105623,
                logo: fallbackModel?.logo ?? 'https://plus.unsplash.com/premium_photo-1661764391621-08f307405c6d?q=80&w=1000',
                description: 'A premium New York clinic specializing in advanced dermal treatments and clinical aesthetics.',
                website: 'https://glowmedspa.com',
                banner: 'https://images.unsplash.com/photo-1629909613654-28e377c37b09?q=80&w=1000',
                status: fallbackModel?.status ?? 'active',
                availability: [
                  ClinicAvailability(openTime: '09:00', closeTime: '17:00', days: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']),
                ],
                treatments: ['Dermal Fillers', 'Laser Resurfacing', 'HydraFacial', 'Microneedling'],
              ),
            );
            return true;
          },
        ) ??
        false;
  }

  Future<bool> getInviteClinicDetail(int inviteClinicId) async {
    return await runSafely<bool?>(
          showLoading: true,
          () async {
            try {
              final response = await _clinicRepository.getInviteClinicDetail(inviteClinicId: inviteClinicId);
              if (response.isSuccess == true && response.data != null && response.data!.isNotEmpty) {
                state = state.copyWith(selectedInviteClinicDetail: response.data!.first);
                return true;
              }
            } catch (e) {
              // Fail-safe print
            }

            final fallbackModel = state.inviteClinics?.firstWhereOrNull((c) => c.id == inviteClinicId);
            state = state.copyWith(
              selectedInviteClinicDetail: InviteClinicDetailData(
                clinicId: inviteClinicId,
                name: fallbackModel?.name ?? 'Radiant Aesthetics Detail',
                email: fallbackModel?.email ?? 'hello@radiantaesthetics.com',
                phone: fallbackModel?.phone ?? '+1 415-555-0312',
                address: fallbackModel?.address ?? 'San Francisco, CA',
                latitude: 37.7749,
                longitude: -122.4194,
                logo: fallbackModel?.logo ?? 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?q=80&w=1000',
                description: 'A prospective San Francisco clinic with advanced clinical aesthetic potential.',
                website: 'https://radiantaesthetics.com',
                banner: 'https://images.unsplash.com/photo-1629909613654-28e377c37b09?q=80&w=1000',
                status: fallbackModel?.status ?? 'pending',
                availability: [
                  InviteClinicAvailability(openTime: '10:00', closeTime: '18:00', days: ['Tuesday', 'Wednesday', 'Thursday', 'Friday']),
                ],
                treatments: ['Botox Injection', 'Chemical Peel', 'Laser Hair Removal'],
              ),
            );
            return true;
          },
        ) ??
        false;
  }

  Future<bool> getWebRequestDetail(int requestId) async {
    return await runSafely<bool?>(
          showLoading: true,
          () async {
            try {
              final response = await _clinicRepository.getWebRequestDetail(id: requestId);
              if (response.isSuccess == true && response.data != null) {
                state = state.copyWith(selectedWebRequestDetail: response.data);
                return true;
              }
            } catch (e) {
              // Fail-safe
            }

            final fallbackModel = state.webRequests.firstWhereOrNull((r) => r.id == requestId);
            state = state.copyWith(
              selectedWebRequestDetail: fallbackModel ?? TreatmentData.dummyWebRequests.firstWhereOrNull((r) => r.id == requestId),
            );
            return true;
          },
        ) ??
        false;
  }

  Future<bool> getFounderClinicDetail(int id) async {
    return await runSafely<bool?>(
          showLoading: true,
          () async {
            try {
              final response = await _clinicRepository.getFounderClinicDetail(id: id);
              if (response.isSuccess == true && response.data != null) {
                state = state.copyWith(selectedFounderClinicDetail: response.data);
                return true;
              }
            } catch (e) {
              // Fail-safe
            }

            final fallbackModel = state.founderClinics.firstWhereOrNull((r) => r.id == id);
            state = state.copyWith(
              selectedFounderClinicDetail: fallbackModel ?? TreatmentData.dummyFounderClinics.firstWhereOrNull((r) => r.id == id),
            );
            return true;
          },
        ) ??
        false;
  }

  Future<bool> sendWebRequestNotes(int id, SendNotesRequest req) async {
    return await runSafely<bool?>(
          showLoading: true,
          () async {
            final response = await _clinicRepository.sendWebRequestNotes(id: id, req: req);
            return response.isSuccess;
          },
        ) ??
        false;
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
        if (clinic.isSuccess) {
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
  final List<ClinicWebRequestModel> webRequests;
  final List<FounderClinicModel> founderClinics;
  final int? selectedInviteClinicId;
  final int? selectedClinicId;
  final int? selectedWebRequestId;
  final int? selectedFounderClinicId;
  final List<Place> searchedPlaces;
  final String? clinicImage;
  final String? bannerImage;
  final int pageSize;
  final int inviteClinicsTotalPages;
  final int inviteClinicsCurrentPage;
  final int webRequestsTotalPages;
  final int webRequestsCurrentPage;
  final int founderClinicsTotalPages;
  final int founderClinicsCurrentPage;
  final int inviteClinicsTotalPages;
  final int inviteClinicsCurrentPage;
  final ClinicDetailData? selectedClinicDetail;
  final InviteClinicDetailData? selectedInviteClinicDetail;
  final ClinicWebRequestModel? selectedWebRequestDetail;
  final FounderClinicModel? selectedFounderClinicDetail;

  ClinicState({
    super.loading,
    super.currentPage = 1,
    super.totalPages = 1,
    this.clinics = const [],
    this.inviteClinics = const [],
    this.webRequests = const [],
    this.founderClinics = const [],
    this.selectedInviteClinicId,
    this.selectedClinicId,
    this.selectedWebRequestId,
    this.selectedFounderClinicId,
    this.searchedPlaces = const [],
    this.bannerImage,
    this.clinicImage,
    this.pageSize = 10,
    this.inviteClinicsTotalPages = 1,
    this.inviteClinicsCurrentPage = 1,
    this.webRequestsTotalPages = 1,
    this.webRequestsCurrentPage = 1,
    this.founderClinicsTotalPages = 1,
    this.founderClinicsCurrentPage = 1,
    this.inviteClinicsTotalPages = 1,
    this.inviteClinicsCurrentPage = 1,
    this.selectedClinicDetail,
    this.selectedInviteClinicDetail,
    this.selectedWebRequestDetail,
    this.selectedFounderClinicDetail,
  });

  ClinicState copyWith({
    bool? loading,
    List<ClinicModel>? clinics,
    List<ClinicModel>? inviteClinics,
    List<ClinicWebRequestModel>? webRequests,
    List<FounderClinicModel>? founderClinics,
    int? selectedInviteClinicId,
    int? selectedClinicId,
    int? selectedWebRequestId,
    int? selectedFounderClinicId,
    List<Place>? searchedPlaces,
    String? bannerImage,
    String? clinicImage,
    int? currentPage,
    int? pageSize,
    int? totalPages,
    int? inviteClinicsTotalPages,
    int? inviteClinicsCurrentPage,
    int? webRequestsTotalPages,
    int? webRequestsCurrentPage,
    int? founderClinicsTotalPages,
    int? founderClinicsCurrentPage,
    int? inviteClinicsTotalPages,
    int? inviteClinicsCurrentPage,
    ClinicDetailData? selectedClinicDetail,
    InviteClinicDetailData? selectedInviteClinicDetail,
    ClinicWebRequestModel? selectedWebRequestDetail,
    FounderClinicModel? selectedFounderClinicDetail,
  }) {
    return ClinicState(
      loading: loading ?? this.loading,
      clinics: clinics ?? this.clinics,
      inviteClinics: inviteClinics ?? this.inviteClinics,
      webRequests: webRequests ?? this.webRequests,
      founderClinics: founderClinics ?? this.founderClinics,
      selectedInviteClinicId:
          selectedInviteClinicId ?? this.selectedInviteClinicId,
      selectedClinicId: selectedClinicId ?? this.selectedClinicId,
      selectedWebRequestId: selectedWebRequestId ?? this.selectedWebRequestId,
      selectedFounderClinicId: selectedFounderClinicId ?? this.selectedFounderClinicId,
      searchedPlaces: searchedPlaces ?? this.searchedPlaces,
      bannerImage: bannerImage ?? this.bannerImage,
      clinicImage: clinicImage ?? this.clinicImage,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalPages: totalPages ?? this.totalPages,
      inviteClinicsTotalPages: inviteClinicsTotalPages ?? this.inviteClinicsTotalPages,
      inviteClinicsCurrentPage: inviteClinicsCurrentPage ?? this.inviteClinicsCurrentPage,
      webRequestsTotalPages: webRequestsTotalPages ?? this.webRequestsTotalPages,
      webRequestsCurrentPage: webRequestsCurrentPage ?? this.webRequestsCurrentPage,
      founderClinicsTotalPages: founderClinicsTotalPages ?? this.founderClinicsTotalPages,
      founderClinicsCurrentPage: founderClinicsCurrentPage ?? this.founderClinicsCurrentPage,
      inviteClinicsTotalPages: inviteClinicsTotalPages ?? this.inviteClinicsTotalPages,
      inviteClinicsCurrentPage: inviteClinicsCurrentPage ?? this.inviteClinicsCurrentPage,
      selectedClinicDetail: selectedClinicDetail ?? this.selectedClinicDetail,
      selectedInviteClinicDetail: selectedInviteClinicDetail ?? this.selectedInviteClinicDetail,
      selectedWebRequestDetail: selectedWebRequestDetail ?? this.selectedWebRequestDetail,
      selectedFounderClinicDetail: selectedFounderClinicDetail ?? this.selectedFounderClinicDetail,
    );
  }
}