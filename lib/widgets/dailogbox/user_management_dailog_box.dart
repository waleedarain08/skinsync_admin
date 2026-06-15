import 'package:flutter/material.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'standard_dialog.dart';

class UserManagementDialogBox extends StatelessWidget {
  const UserManagementDialogBox({super.key});

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: 'User Profile Details',
      width: context.w(700),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, 'Personal Information'),
            context.verticalSpace(20),
            Row(
              children: [
                Expanded(child: _infoBlock(context, 'First Name', 'Emma')),
                context.horizontalSpace(24),
                Expanded(child: _infoBlock(context, 'Last Name', 'Johnson')),
              ],
            ),
            context.verticalSpace(16),
            Row(
              children: [
                Expanded(child: _infoBlock(context, 'Email', 'emma.j@example.com')),
                context.horizontalSpace(24),
                Expanded(child: _infoBlock(context, 'Mobile', '+1 (555) 123-4567')),
              ],
            ),
            context.verticalSpace(32),
            _buildSectionTitle(context, 'Skin Analysis & Goals'),
            context.verticalSpace(20),
            _buildTagSection(context, 'Skin Goals', ['Anti-aging', 'Hydration']),
            context.verticalSpace(20),
            _buildTagSection(context, 'Primary Concerns', ['Fine lines', 'Dryness', 'Dark spots']),
            context.verticalSpace(32),
            _buildSectionTitle(context, 'Bio & History'),
            context.verticalSpace(16),
            _infoBlock(context, 'Bio', 'Looking to improve skin texture and reduce signs of aging.'),
            context.verticalSpace(16),
            _infoBlock(context, 'Medical History', 'No known allergies. Previous treatments include chemical peels.'),
          ],
        ),
      ),
      actions: [
        CustomPrimaryButton(
          onTap: () => Navigator.pop(context),
          label: 'Close Profile',
          width: context.w(160),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.fonts.black16w600.copyWith(color: CustomColors.purple)),
        const Divider(),
      ],
    );
  }

  Widget _infoBlock(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.fonts.grey13w500),
        context.verticalSpace(4),
        Text(value, style: context.fonts.black16w600),
      ],
    );
  }

  Widget _buildTagSection(BuildContext context, String label, List<String> tags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.fonts.grey13w500),
        context.verticalSpace(12),
        Wrap(
          spacing: context.w(12),
          runSpacing: context.h(12),
          children: tags.map((tag) => Container(
            padding: context.appEdgeInsets(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: CustomColors.green.withValues(alpha: 0.1),
              borderRadius: context.appBorderRadius(all: 8),
              border: Border.all(color: CustomColors.green.withValues(alpha: 0.2)),
            ),
            child: Text(tag, style: context.fonts.black14w600.copyWith(color: CustomColors.purple, fontSize: context.sp(11))),
          )).toList(),
        ),
      ],
    );
  }
}
