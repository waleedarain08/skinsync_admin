import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/responses/category_detail_response.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/session_view_model.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';

class RolesStep extends ConsumerWidget {
  const RolesStep({super.key});

  Widget _sectionTitle(BuildContext context, String title, {double? fontSize}) {
    return Text(
      title,
      style: context.fonts.black18w600.copyWith(
        fontSize: fontSize != null ? context.sp(fontSize) : null,
      ),
    );
  }

  Widget _radioOption(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: context.appBorderRadius(all: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<bool>(
            value: true,
            groupValue: isSelected,
            onChanged: (_) => onTap(),
            activeColor: CustomColors.purple,
          ),
          Text(label, style: context.fonts.black14w600),
        ],
      ),
    );
  }

  Widget _roleChip(
    BuildContext context,
    String role,
    bool isSelected,
    VoidCallback? onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: context.appBorderRadius(all: 30),
      child: Container(
        padding: context.appEdgeInsets(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? CustomColors.purple : Colors.white,
          borderRadius: context.appBorderRadius(all: 30),
          border: Border.all(
            color: isSelected ? CustomColors.purple : CustomColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.add_circle_outline_rounded,
              color: isSelected ? Colors.white : CustomColors.grey,
              size: 18,
            ),
            context.horizontalSpace(8),
            Text(
              role,
              style: isSelected
                  ? context.fonts.white14w600
                  : context.fonts.black14w400,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionViewModelProvider);
    final viewModel = ref.read(sessionViewModelProvider.notifier);
    final CategoryDetailDto? selectedCategory = ref.watch(treatmentViewModelProvider).selectedCategoryDetail;

    final List<String> availableRoles = [
      'Injector',
      'Aesthetician',
      'MD',
      'Nurse',
      'Specialist',
    ];
    final List<String> categoryRoles =
        selectedCategory?.defaultRoles
            ?.map((r) => defaultRoleValues.reverse[r] ?? '')
            .toList() ??
        [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Allowed Provider Roles'),
        context.verticalSpace(8),
        Text(
          'Define which provider roles are authorized to perform this treatment.',
          style: context.fonts.grey14w400,
        ),
        context.verticalSpace(32),

        Row(
          children: [
            _radioOption(
              context,
              'Use Category Defaults',
              state.providerRolesSource == 'category',
              () {
                viewModel.setProviderRolesSource('category');
                viewModel.setRoles(categoryRoles);
              },
            ),
            context.horizontalSpace(32),
            _radioOption(
              context,
              'Define Custom Roles',
              state.providerRolesSource == 'custom',
              () => viewModel.setProviderRolesSource('custom'),
            ),
          ],
        ),

        context.verticalSpace(40),

        if (state.providerRolesSource == 'category') ...[
          Text(
            'Category Roles (Read-only)',
            style: context.fonts.grey10w700ls1,
          ),
          context.verticalSpace(16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: categoryRoles.isEmpty
                ? [
                    Text(
                      'No roles defined in category.',
                      style: context.fonts.grey14w400,
                    ),
                  ]
                : categoryRoles
                      .map((role) => _roleChip(context, role, true, null))
                      .toList(),
          ),
        ] else ...[
          Text('Select Authorized Roles', style: context.fonts.black16w600),
          context.verticalSpace(16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: availableRoles.map((role) {
              final isSelected = state.selectedRoles.contains(role);
              return _roleChip(
                context,
                role,
                isSelected,
                () => viewModel.toggleRole(role),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}