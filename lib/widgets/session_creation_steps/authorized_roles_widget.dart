import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/responses/category_detail_response.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/provider_view_model.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';

class AuthorizedRolesWidget extends ConsumerStatefulWidget {
  final String title;
  final String description;
  final List<String> selectedRoles;
  final Function(String) onRoleToggled;
  final bool showCategorySwitcher;
  final String? providerRolesSource;
  final Function(String)? onProviderRolesSourceChanged;
  final Function(List<String>)? onSetRoles;

  const AuthorizedRolesWidget({
    super.key,
    required this.title,
    required this.description,
    required this.selectedRoles,
    required this.onRoleToggled,
    this.showCategorySwitcher = false,
    this.providerRolesSource,
    this.onProviderRolesSourceChanged,
    this.onSetRoles,
  });

  @override
  ConsumerState<AuthorizedRolesWidget> createState() =>
      _AuthorizedRolesWidgetState();
}

class _AuthorizedRolesWidgetState extends ConsumerState<AuthorizedRolesWidget> {
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
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(providerRoleViewModelProvider.notifier)
          .fetchProviderRoles();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final CategoryDetailDto? selectedCategory = ref
        .watch(treatmentViewModelProvider)
        .selectedCategoryDetail;

    // final List<String> availableRoles = [
    //   'Injector',
    //   'Aesthetician',
    //   'MD',
    //   'Nurse',
    //   'Specialist',
    // ];
   final categoryRoles = selectedCategory?.defaultRoles ?? <String>[];

    final isCategoryDefault =
        widget.showCategorySwitcher &&
        (widget.providerRolesSource == 'category');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, widget.title),
        context.verticalSpace(8),
        Text(widget.description, style: context.fonts.grey14w400),
        context.verticalSpace(24),

        if (widget.showCategorySwitcher) ...[
          Row(
            children: [
              _radioOption(
                context,
                'Use Category Defaults',
                widget.providerRolesSource == 'category',
                () {
                  if (widget.onProviderRolesSourceChanged != null) {
                    widget.onProviderRolesSourceChanged!('category');
                  }
                  if (widget.onSetRoles != null) {
                    widget.onSetRoles!(categoryRoles);
                  }
                },
              ),
              context.horizontalSpace(32),
              _radioOption(
                context,
                'Define Custom Roles',
                widget.providerRolesSource == 'custom',
                () {
                  if (widget.onProviderRolesSourceChanged != null) {
                    widget.onProviderRolesSourceChanged!('custom');
                  }
                },
              ),
            ],
          ),
          context.verticalSpace(32),
        ],

        if (isCategoryDefault) ...[
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
          if (widget.showCategorySwitcher) ...[
            Text('Select Authorized Roles', style: context.fonts.black16w600),
            context.verticalSpace(16),
          ],
          Consumer(
            builder: (context, ref, _) {
              final roles =
                  ref.watch(providerRoleViewModelProvider).providerRoles ?? [];

              if (roles.isEmpty) {
                return Text(
                  'No provider roles available.',
                  style: context.fonts.grey13w500,
                );
              }
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: roles.map((role) {
                  final isSelected = widget.selectedRoles.contains(role.name);
                  return _roleChip(
                    context,
                    role.name ?? '',
                    isSelected,
                    () => widget.onRoleToggled(role.name ?? ''),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ],
    );
  }
}
