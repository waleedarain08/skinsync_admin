import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/responses/app_version_response.dart';
import 'package:skinsync_admin/repositories/setting_repository.dart';
import 'package:skinsync_admin/services/locator.dart';
import 'package:skinsync_admin/view_models/base_state_model.dart';
import 'package:skinsync_admin/view_models/base_view_model.dart';

import '../models/requests/app_version_request.dart';

final settingViewModelProvider =
    NotifierProvider<SettingViewModel, SettingState>(SettingViewModel._);

class SettingViewModel extends BaseViewModel<SettingState> {
  SettingViewModel._() : super(SettingState());

  final SettingRepository _settingRepository = locator<SettingRepository>();

  Future<List<VersionData>?> getAppVersion() async {
    return await runSafely(() async {
      final response = await _settingRepository.getAppVersion();
      return response.data;
    });
  }

  Future<bool?> updateAppVersion(AppVersionRequest req) async {
    return await runSafely<bool?>(
      showLoading: true,
      onLoadingChange: (loading) {
        state = state.copyWith(loading: loading);
      },
      () async {
        final response = await _settingRepository.updateAppVersion(req: req);
        if (response.isSuccess) {
          EasyLoading.showSuccess(
            response.message.isNotEmpty ? response.message : 'Success',
          );
          return true;
        } else {
          EasyLoading.showError(
            response.message.isNotEmpty
                ? response.message
                : 'Failed to update version',
          );
          return false;
        }
      },
    );
  }
}

class SettingState extends BaseStateModel {
  SettingState({super.loading});

  SettingState copyWith({bool? loading}) {
    return SettingState(loading: loading ?? this.loading);
  }
}
