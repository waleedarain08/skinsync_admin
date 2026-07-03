import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/responses/category_detail_response.dart';
import 'package:skinsync_admin/screens/create_session_screen.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_outlined_button.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';

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
          'Define the total number of clinical sessions and enter specific configuration for each session.',
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
        Text('Sessions Configuration & List', style: context.fonts.black16w600),
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
              final sessionEntry = state.sessions.length > index ? state.sessions[index] : null;
              final bool isDetailed = sessionEntry?.isDetailedEntered ?? false;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: context.appEdgeInsets(all: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: context.appBorderRadius(all: 12),
                  border: Border.all(
                    color: isDetailed ? CustomColors.green : CustomColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: context.w(32),
                      height: context.w(32),
                      decoration: BoxDecoration(
                        color: isDetailed ? CustomColors.green : CustomColors.purple,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: context.fonts.white10w700,
                        ),
                      ),
                    ),
                    context.horizontalSpace(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Session ${index + 1}',
                                style: context.fonts.black14w700,
                              ),
                              context.horizontalSpace(8),
                              if (isDetailed) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: CustomColors.green.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.check, color: CustomColors.green, size: 10),
                                      SizedBox(width: 4),
                                      Text(
                                        'Details Entered',
                                        style: TextStyle(
                                          color: CustomColors.green,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ] else ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: CustomColors.red.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Pending Detail',
                                    style: TextStyle(
                                      color: CustomColors.red,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          if (isDetailed) ...[
                            context.verticalSpace(4),
                            Text(
                              'Session scheduling, pricing & materials configured.',
                              style: context.fonts.grey12w400,
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (isDetailed)
                      CustomOutlinedButton(
                        width: context.w(150),
                        onTap: () {
                          viewModel.setActiveSessionIndex(index);
                          viewModel.setSessionStep(3);
                          context.push(CreateSessionScreen.routeName);
                        },
                        label: 'Edit Detail',
                      )
                    else
                      CustomPrimaryButton(
                        width: context.w(150),
                        onTap: () {
                          viewModel.setActiveSessionIndex(index);
                          viewModel.setSessionStep(3);
                          context.push(CreateSessionScreen.routeName);
                        },
                        label: 'Enter Detail',
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