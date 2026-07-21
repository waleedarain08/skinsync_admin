import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/session_view_model.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';

class DowntimeStep extends ConsumerStatefulWidget {
  const DowntimeStep({super.key});

  @override
  ConsumerState<DowntimeStep> createState() => _DowntimeStepState();
}

class _DowntimeStepState extends ConsumerState<DowntimeStep> {
  Widget _sectionTitle(BuildContext context, String title, {double? fontSize}) {
    return Text(
      title,
      style: context.fonts.black18w600.copyWith(
        fontSize: fontSize != null ? context.sp(fontSize) : null,
      ),
    );
  }

  String _descriptionForLevel(String? level) {
    switch (level?.toLowerCase()) {
      case 'none':
        return 'No booking restrictions.';
      case 'low':
        return 'Short recovery window.';
      case 'moderate':
        return 'Standard clinical recovery.';
      case 'high':
        return 'Extended recovery required.';
      default:
        return 'Recovery window for this level.';
    }
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
  void initState() {
    final treatmentId =
        ref.read(treatmentViewModelProvider).selectedTreatmentId;
    if (treatmentId != null) {
      ref
          .read(sessionViewModelProvider.notifier)
          .fetchDownTimeLevelByTreatment(id: treatmentId);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionViewModelProvider);
    final viewModel = ref.read(sessionViewModelProvider.notifier);
    final levels = state.downTimeLevelList;

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

        if (state.loading)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: CircularProgressIndicator(color: CustomColors.purple),
            ),
          )
        else if (levels.isEmpty)
          Text(
            'No downtime levels configured for this treatment.',
            style: context.fonts.grey13w500,
          )
        else
          for (int i = 0; i < levels.length; i++) ...[
            _downtimeOption(
              context,
              levels[i].level ?? 'Level ${i + 1}',
              '${levels[i].days ?? 0} Days',
              _descriptionForLevel(levels[i].level),
              state.downtimeLevel == levels[i].level,
              () => viewModel.setDowntimeLevel(levels[i].level ?? ''),
            ),
            if (i != levels.length - 1) context.verticalSpace(16),
          ],
      ],
    );
  }
}