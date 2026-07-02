import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';

class LogicStep extends ConsumerWidget {
  const LogicStep({super.key});

  Widget _sectionTitle(BuildContext context, String title, {double? fontSize}) {
    return Text(
      title,
      style: context.fonts.black18w600.copyWith(
        fontSize: fontSize != null ? context.sp(fontSize) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(treatmentViewModelProvider);
    final viewModel = ref.read(treatmentViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Onboarding Behavior'),
        context.verticalSpace(24),
        Row(
          children: [
            SizedBox(
              width: context.w(24),
              height: context.w(24),
              child: Checkbox(
                value: state.enableByDefault,
                onChanged: (val) => viewModel.toggleEnableByDefault(val),
                shape: RoundedRectangleBorder(
                  borderRadius: context.appBorderRadius(all: 4),
                ),
              ),
            ),
            context.horizontalSpace(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enable by Default for New Clinics',
                    style: context.fonts.black16w400,
                  ),
                  Text(
                    'Newly onboarded clinics will have this treatment assigned automatically.',
                    style: context.fonts.grey12w400,
                  ),
                ],
              ),
            ),
          ],
        ),
        context.verticalSpace(40),
        const Divider(),
        context.verticalSpace(32),
        _sectionTitle(context, 'AI Simulator Compatibility'),
        context.verticalSpace(16),
        Row(
          children: [
            SizedBox(
              width: context.w(24),
              height: context.w(24),
              child: Checkbox(
                value: state.useInAiSimulator,
                onChanged: (val) => viewModel.toggleAiSimulator(val),
                shape: RoundedRectangleBorder(
                  borderRadius: context.appBorderRadius(all: 4),
                ),
              ),
            ),
            context.horizontalSpace(12),
            Text('Use in AI Simulator', style: context.fonts.black16w400),
          ],
        ),
      ],
    );
  }
}