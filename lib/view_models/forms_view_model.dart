import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/form_model.dart';
import 'package:skinsync_admin/models/requests/create_form_request.dart';
import 'package:skinsync_admin/repositories/form_repository.dart';
import 'package:skinsync_admin/services/locator.dart';
import 'package:skinsync_admin/services/media_service.dart';
import 'package:skinsync_admin/view_models/base_state_model.dart';
import 'package:skinsync_admin/view_models/base_view_model.dart';

final formsViewModelProvider = NotifierProvider<FormsViewModel, FormsState>(
  FormsViewModel._,
);

class FormsViewModel extends BaseViewModel<FormsState> {
  FormsViewModel._() : super(FormsState());

  final FormRepository _formRepository = locator<FormRepository>();
  final MediaService _mediaService = MediaService();

  Future<void> initialize() async {
    await Future.wait([
      getForms('consent', initial: true),
      getForms('compliance', initial: true),
    ]);
  }

  Future<void> getForms(String type, {bool initial = false, int? page}) async {
    final currentPage = page ?? (type == 'consent' ? state.consentPage : state.compliancePage);
    
    if (initial) {
      // Reset state for initial load if needed
    }

    return await runSafely(
      showLoading: initial,
      onLoadingChange: (loading) {
        state = state.copyWith(loading: loading);
      },
      () async {
        final response = await _formRepository.getForms(
          type: type,
          page: currentPage,
        );

        if (type == 'consent') {
          state = state.copyWith(
            consentForms: response.data,
            consentTotalPages: response.totalPages,
            consentPage: currentPage,
          );
        } else {
          state = state.copyWith(
            complianceForms: response.data,
            complianceTotalPages: response.totalPages,
            compliancePage: currentPage,
          );
        }
      },
    );
  }

  Future<bool> uploadAndCreateForm({
    required String title,
    required String type,
    required String sku,
    required PlatformFile file,
  }) async {
    return await runSafely<bool?>(showLoading: true, () async {
      // 1. Upload to Firebase
      final url = await _mediaService.uploadMedia(
        path: 'forms/$type',
        file: file,
      );

      if (url == null) return false;

      // 2. Save to Backend
      final request = CreateFormRequest(
        title: title,
        url: url,
        type: type,
        globalSku: sku,
      );
      final response = await _formRepository.createForm(request);

      if (response.isSuccess) {
        await getForms(type, initial: true, page: 1);
        return true;
      }
      return false;
    }) ?? false;
  }

  Future<bool> deleteForm(int id, String type) async {
    return await runSafely<bool?>(showLoading: true, () async {
      final response = await _formRepository.deleteForm(id);
      if (response.isSuccess) {
        await getForms(type, initial: true, page: 1);
        return true;
      }
      return false;
    }) ?? false;
  }
}

class FormsState extends BaseStateModel {
  final List<FormModel>? consentForms;
  final List<FormModel>? complianceForms;
  final int consentPage;
  final int compliancePage;
  final int consentTotalPages;
  final int complianceTotalPages;

  FormsState({
    super.loading,
    this.consentForms = const [],
    this.complianceForms = const [],
    this.consentPage = 1,
    this.compliancePage = 1,
    this.consentTotalPages = 1,
    this.complianceTotalPages = 1,
  });

  FormsState copyWith({
    bool? loading,
    List<FormModel>? consentForms,
    List<FormModel>? complianceForms,
    int? consentPage,
    int? compliancePage,
    int? consentTotalPages,
    int? complianceTotalPages,
  }) {
    return FormsState(
      loading: loading ?? this.loading,
      consentForms: consentForms ?? this.consentForms,
      complianceForms: complianceForms ?? this.complianceForms,
      consentPage: consentPage ?? this.consentPage,
      compliancePage: compliancePage ?? this.compliancePage,
      consentTotalPages: consentTotalPages ?? this.consentTotalPages,
      complianceTotalPages: complianceTotalPages ?? this.complianceTotalPages,
    );
  }
}
