import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'base_view_model.dart';

final authViewModel = NotifierProvider(() => AuthViewModel());

class AuthViewModel extends BaseViewModel<AuthState> {
  AuthViewModel() : super(AuthState());

  Future<void> checkAuthentication() async {
    return await runSafely(() async {
      state = state.copyWith(loading: true);
      await Future.delayed(Duration(seconds: 2));
      state = state.copyWith(loading: false);
    });
  }
}

class AuthState {
  final bool loading;

  AuthState({this.loading = false});

  AuthState copyWith({bool? loading}) {
    return AuthState(loading: loading ?? this.loading);
  }
}
