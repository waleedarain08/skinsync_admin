import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/view_models/session_view_model.dart';
import 'package:skinsync_admin/widgets/session_creation_steps/authorized_roles_widget.dart';

class RolesStep extends ConsumerWidget {
  const RolesStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionViewModelProvider);
    final viewModel = ref.read(sessionViewModelProvider.notifier);

    return AuthorizedRolesWidget(
      title: 'Allowed Provider Roles',
      description: 'Define which provider roles are authorized to perform this treatment.',
      selectedRoles: state.selectedRoles,
      onRoleToggled: viewModel.toggleRole,
      showCategorySwitcher: true,
      providerRolesSource: state.providerRolesSource,
      onProviderRolesSourceChanged: viewModel.setProviderRolesSource,
      onSetRoles: viewModel.setRoles,
    );
  }
}
