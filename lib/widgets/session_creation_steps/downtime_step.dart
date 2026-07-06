import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/responses/category_detail_response.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/session_view_model.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';

class DowntimeStep extends ConsumerWidget {
  const DowntimeStep({super.key});

  Widget _sectionTitle(BuildContext context, String title, {double? fontSize}) {
    return Text(
      title,
      style: context.fonts.black18w600.copyWith(
        fontSize: fontSize != null ? context.sp(fontSize) : null,
      ),
    );
  }

  Widget _downtimeOption(
    BuildContext context,
    String title,
    String duration,
    String desc,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: context.appBorderRadius(all: 12),
      child: Container(
        padding: context.appEdgeInsets(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? CustomColors.purple.withValues(alpha: 0.05)
              : Colors.white,
          borderRadius: context.appBorderRadius(all: 12),
          border: Border.all(
            color: isSelected ? CustomColors.purple : CustomColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: context.w(48),
              height: context.w(48),
              decoration: BoxDecoration(
                color: isSelected
                    ? CustomColors.purple
                    : CustomColors.whiteGrey,
                borderRadius: context.appBorderRadius(all: 10),
              ),
              child: Icon(
                Icons.timer_outlined,
                color: isSelected ? Colors.white : CustomColors.grey,
                size: 24,
              ),
            ),
            context.horizontalSpace(20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.fonts.black16w600),
                  Text(desc, style: context.fonts.grey12w400),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(duration, style: context.fonts.purple14w700),
                if (isSelected) context.verticalSpace(4),
                if (isSelected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: CustomColors.purple,
                    size: 20,
                  ),
              ],
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
    final presets = selectedCategory?.downtimePresets;
    final lowDays = presets?.low ?? 2;
    final moderateDays = presets?.moderate ?? 5;
    final highDays = presets?.high ?? 10;
    final noneDays = presets?.none ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Downtime Level Configuration'),
        context.verticalSpace(8),
        Text(
          'Define how long a patient cannot book other services in the treatment area after this procedure.',
          style: context.fonts.grey14w400,
        ),
        context.verticalSpace(32),

        _downtimeOption(
          context,
          'None',
          '$noneDays Days',
          'No booking restrictions.',
          state.downtimeLevel == 'None',
          () => viewModel.setDowntimeLevel('None'),
        ),
        context.verticalSpace(16),
        _downtimeOption(
          context,
          'Low',
          '$lowDays Days',
          'Short recovery window.',
          state.downtimeLevel == 'Low',
          () => viewModel.setDowntimeLevel('Low'),
        ),
        context.verticalSpace(16),
        _downtimeOption(
          context,
          'Moderate',
          '$moderateDays Days',
          'Standard clinical recovery.',
          state.downtimeLevel == 'Moderate',
          () => viewModel.setDowntimeLevel('Moderate'),
        ),
        context.verticalSpace(16),
        _downtimeOption(
          context,
          'High',
          '$highDays Days',
          'Extended recovery required.',
          state.downtimeLevel == 'High',
          () => viewModel.setDowntimeLevel('High'),
        ),
      ],
    );
  }
}