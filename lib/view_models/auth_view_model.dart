import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/requests/login_request_model.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../services/locator.dart';
import '../services/storage_service.dart';
import 'base_state_model.dart';
import 'base_view_model.dart';

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  () => AuthViewModel._(),
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
          state = state.copyWith(user: response.user);

          return true;
        }) ??
        false;
  }
}

class AuthState extends BaseStateModel {
  final bool isAuthenticated;
  final UserModel? user;
  final String? error;

  AuthState({
    super.loading = false,
    this.isAuthenticated = false,
    this.error,
    this.user,
  });

  AuthState copyWith({
    bool? loading,
    bool? isAuthenticated,
    String? error,
    UserModel? user,
  }) {
    return AuthState(
      loading: loading ?? this.loading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      error: error,
    );
  }
}
