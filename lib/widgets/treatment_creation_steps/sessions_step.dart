import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/responses/category_detail_response.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';

class SessionsStep extends ConsumerWidget {
  const SessionsStep({super.key});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(treatmentViewModelProvider);
    final viewModel = ref.read(treatmentViewModelProvider.notifier);
    final CategoryDetailDto? selectedCategory = state.selectedCategoryDetail;
    final int categorySessions = selectedCategory?.totalSessions ?? 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Sessions Configuration'),
        context.verticalSpace(8),
        Text(
          'Define the total number of clinical sessions for this treatment journey.',
          style: context.fonts.grey14w400,
        ),
        context.verticalSpace(32),

        Row(
          children: [
            _radioOption(
              context,
              'Use Category Sessions ($categorySessions)',
              state.sessionSource == 'category',
              () {
                viewModel.setSessionSource(
                  'category',
                  category: selectedCategory,
                );
              },
            ),
            context.horizontalSpace(32),
            _radioOption(
              context,
              'Custom Session Count',
              state.sessionSource == 'custom',
              () => viewModel.setSessionSource('custom'),
            ),
          ],
        ),

        if (state.sessionSource == 'custom') ...[
          context.verticalSpace(32),
          BuildTextField(
            label: 'Total Sessions',
            controller: TextEditingController(
              text: state.totalSessions.toString(),
            ),
            hintText: 'e.g. 3',
            keyboardType: TextInputType.number,
            onChanged: (val) => viewModel.setTotalSessions(val ?? '1'),
          ),
        ],

        context.verticalSpace(40),
        Text('Journey Preview', style: context.fonts.black16w600),
        context.verticalSpace(16),
        Container(
          width: double.infinity,
          padding: context.appEdgeInsets(all: 20),
          decoration: BoxDecoration(
            color: CustomColors.whiteGrey,
            borderRadius: context.appBorderRadius(all: 12),
            border: Border.all(color: CustomColors.border),
          ),
          child: Column(
            children: List.generate(state.totalSessions, (index) {
              return Padding(
                padding: context.appEdgeInsets(
                  bottom: index == state.totalSessions - 1 ? 0 : 12,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: context.appEdgeInsets(all: 8),
                      decoration: const BoxDecoration(
                        color: CustomColors.purple,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${index + 1}',
                        style: context.fonts.white10w700,
                      ),
                    ),
                    context.horizontalSpace(16),
                    Text(
                      'Session ${index + 1}',
                      style: context.fonts.black14w600,
                    ),
                    const Spacer(),
                    Text(
                      'Follow-ups required',
                      style: context.fonts.grey12w400,
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}