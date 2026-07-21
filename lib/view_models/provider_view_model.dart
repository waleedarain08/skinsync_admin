import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/responses/provider_roles_response.dart';
import 'package:skinsync_admin/repositories/provider_role_repository.dart';
import 'package:skinsync_admin/services/locator.dart';
import 'package:skinsync_admin/view_models/base_view_model.dart';

final providerRoleViewModelProvider =
    NotifierProvider<ProviderRoleViewModel, ProviderRoleState>(
      ProviderRoleViewModel.new,
    );

class ProviderRoleState {
  final List<ProviderRoles>? providerRoles;
  final List<String>? selectedProviderRoles;
  ProviderRoleState({this.providerRoles, this.selectedProviderRoles});

  ProviderRoleState copyWith({
    List<ProviderRoles>? providerRoles,
    List<String>? selectedProviderRoles,
  }) {
    return ProviderRoleState(
      providerRoles: providerRoles ?? this.providerRoles,
      selectedProviderRoles:
          selectedProviderRoles ?? this.selectedProviderRoles,
    );
  }
}

class ProviderRoleViewModel extends BaseViewModel<ProviderRoleState> {
  ProviderRoleViewModel() : super(ProviderRoleState());

  final ProviderRoleRepository _providerRolesRepository =
      locator<ProviderRoleRepository>();

  void toggleSelectedProvider({required String role}) {
    final selected = List<String>.from(state.selectedProviderRoles ?? []);

    if (selected.contains(role)) {
      selected.remove(role);
    } else {
      selected.add(role);
    }

    state = state.copyWith(selectedProviderRoles: selected);
  }

  Future<void> fetchProviderRoles() async {
    await runSafely(() async {
      final response = await _providerRolesRepository.providerRoles();
      state = state.copyWith(providerRoles: response.data);
    });
  }
}
