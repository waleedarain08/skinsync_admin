import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/form_model.dart';
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
      getForms('consent'),
      getForms('compliance'),
    ]);
  }

  Future<void> getForms(String type) async {
    return await runSafely(
      showLoading: false,
      onLoadingChange: (loading) {
        state = state.copyWith(loading: loading);
      },
      () async {
        final response = await _formRepository.getForms(type);
        if (type == 'consent') {
          state = state.copyWith(consentForms: response.data);
        } else {
          state = state.copyWith(complianceForms: response.data);
        }
      },
    );
  }

  Future<bool> uploadAndCreateForm({
    required String title,
    required String type,
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
      final form = FormModel(
        title: title,
        url: url,
        type: type,
      );
      final response = await _formRepository.createForm(form);

      if (response.isSuccess) {
        await getForms(type);
        return true;
      }
      return false;
    }) ?? false;
  }

  Future<bool> deleteForm(int id, String type) async {
    return await runSafely<bool?>(showLoading: true, () async {
      final response = await _formRepository.deleteForm(id);
      if (response.isSuccess) {
        await getForms(type);
        return true;
      }
      return false;
    }) ?? false;
  }
}

class FormsState extends BaseStateModel {
  final List<FormModel>? consentForms;
  final List<FormModel>? complianceForms;

  FormsState({
    super.loading,
    this.consentForms = const [],
    this.complianceForms = const [],
  });

  FormsState copyWith({
    bool? loading,
    List<FormModel>? consentForms,
    List<FormModel>? complianceForms,
  }) {
    return FormsState(
      loading: loading ?? this.loading,
      consentForms: consentForms ?? this.consentForms,
      complianceForms: complianceForms ?? this.complianceForms,
    );
  }
}
