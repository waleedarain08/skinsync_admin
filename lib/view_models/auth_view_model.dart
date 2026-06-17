import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/requests/auth_req_models.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../services/locator.dart';
import '../services/storage_service.dart';
import 'base_state_model.dart';
import 'base_view_model.dart';

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  AuthViewModel._,
);

class AuthViewModel extends BaseViewModel<AuthState> {
  AuthViewModel._() : super(AuthState());

  final AuthRepository _authRepository = locator<AuthRepository>();
  final SecureStorageService _storageServices = SecureStorageService();

  Future<void> initialize() async {
    final token = _storageServices.token;
    if (token != null && token.isNotEmpty) {
      state = state.copyWith(isAuthenticated: true);
    }
  }

  Future<bool> login({required LoginRequestModel loginReq}) async {
    return await runSafely<bool?>(showLoading: true, () async {
          final response = await _authRepository.login(req: loginReq);
          state = state.copyWith(user: response.data!.user);
          return true;
        }) ??
        false;
  }

  Future<bool> forgotPassword({required String email}) async {
    return await runSafely<bool?>(showLoading: true, () async {
          await _authRepository.forgotPassword(email: email);

          return true;
        }) ??
        false;
  }

  Future<bool> resendOtp({required String email}) async {
    return await runSafely<bool?>(showLoading: true, () async {
          final response = await _authRepository.reSendOtp(email: email);
          EasyLoading.showSuccess(response.message);
          return true;
        }) ??
        false;
  }

  Future<bool> verifyOtp({required String email, required String otp}) async {
    return await runSafely<bool?>(showLoading: true, () async {
          await _authRepository.verifyOtp(
            email: email,
            otp: otp,
          );
          EasyLoading.showSuccess('OTP Verified successfully');
          return true;
        }) ??
        false;
  }

  Future<bool> resetPassword({required ResetPasswordReqModel req}) async {
    return await runSafely<bool?>(showLoading: true, () async {
          final response = await _authRepository.resetPassword(req: req);
          EasyLoading.showSuccess(response.message);
          return true;
        }) ??
        false;
  }

  void setCountry(CountryCode country) {
    state = state.copyWith(country: country);
  }
}

class AuthState extends BaseStateModel {
  final bool isAuthenticated;
  final UserModel? user;
  final String? error;
  final CountryCode? country;

  AuthState({
    super.loading = false,
    this.isAuthenticated = false,
    this.error,
    this.user,
    this.country,
  });

  AuthState copyWith({
    bool? loading,
    bool? isAuthenticated,
    String? error,
    UserModel? user,
    CountryCode? country,
  }) {
    return AuthState(
      loading: loading ?? this.loading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      error: error,
      country: country ?? this.country,
    );
  }
}
