import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/requests/app_version_request_model.dart';
import 'package:skinsync_admin/repositories/setting_repository.dart';
import 'package:skinsync_admin/services/locator.dart';
import 'package:skinsync_admin/view_models/base_state_model.dart';
import 'package:skinsync_admin/view_models/base_view_model.dart';

final settingViewModelProvider =
    NotifierProvider<SettingViewModel, SettingState>(
      SettingViewModel._,
    );

class SettingViewModel extends BaseViewModel<SettingState> {
  SettingViewModel._() : super(SettingState());

  final SettingRepository _settingRepository = locator<SettingRepository>();

  Future<bool> updateCustomerAppVersion(AppVersionRequestModel req) async {
    final success =
        await runSafely<bool?>(
          showLoading: true,
          onLoadingChange: (loading) {
            state = state.copyWith(loading: loading);
          },
          () async {
            final response = await _settingRepository.updateCustomerAppVersion(
              req: req,
            );
            if (response.isSuccess) {
              EasyLoading.showSuccess(
                response.message.isNotEmpty ? response.message : 'Success',
              );
              debugPrint(response.message.toString());
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
        ) ??
        false;

    return success;
  }

  Future<bool> updateClinicAppVersion(AppVersionRequestModel req) async {
    final success =
        await runSafely<bool?>(
          showLoading: true,
          onLoadingChange: (loading) {
            state = state.copyWith(loading: loading);
          },
          () async {
            final response = await _settingRepository.updateClinicAppVersion(
              req: req,
            );
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
        ) ??
        false;

    return success;
  }
}

class SettingState extends BaseStateModel {
  SettingState({super.loading});

  SettingState copyWith({bool? loading}) {
    return SettingState(loading: loading ?? this.loading);
  }
}
