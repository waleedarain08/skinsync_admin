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

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: CustomColors.purple),
          context.horizontalSpace(12),
          Text('$label: ', style: context.fonts.black12w600),
          Expanded(
            child: Text(
              value,
              style: context.fonts.grey12w400,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRowHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0, top: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: CustomColors.purple),
          context.horizontalSpace(12),
          Text(title, style: context.fonts.black12w600),
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
              final sessionEntry =
                  state.sessions.length > index ? state.sessions[index] : null;
              final bool isDetailed = sessionEntry?.isDetailedEntered ?? false;

              if (!isDetailed) {
                // Return simple card for pending session
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: context.appEdgeInsets(all: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: context.appBorderRadius(all: 12),
                    border: Border.all(color: CustomColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: context.w(32),
                        height: context.w(32),
                        decoration: const BoxDecoration(
                          color: CustomColors.purple,
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
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        CustomColors.red.withValues(alpha: 0.1),
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
                            ),
                          ],
                        ),
                      ),
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
              }

              // Return beautiful expandable card for completed session
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: context.appBorderRadius(all: 12),
                  border: Border.all(color: CustomColors.green, width: 1.5),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    tilePadding: context.appEdgeInsets(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    childrenPadding: context.appEdgeInsets(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    leading: Container(
                      width: context.w(32),
                      height: context.w(32),
                      decoration: const BoxDecoration(
                        color: CustomColors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: context.fonts.white10w700,
                        ),
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(
                          'Session ${index + 1}',
                          style: context.fonts.black14w700,
                        ),
                        context.horizontalSpace(8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: CustomColors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check,
                                color: CustomColors.green,
                                size: 10,
                              ),
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
                      ],
                    ),
                    subtitle: Text(
                      'Tap to expand blueprint summary details.',
                      style: context.fonts.grey11w400,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomOutlinedButton(
                          width: context.w(120),
                          height: context.h(32),
                          onTap: () {
                            viewModel.setActiveSessionIndex(index);
                            viewModel.setSessionStep(3);
                            context.push(CreateSessionScreen.routeName);
                          },
                          label: 'Edit Detail',
                        ),
                        context.horizontalSpace(12),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: CustomColors.grey,
                        ),
                      ],
                    ),
                    children: [
                      const Divider(height: 1, color: CustomColors.border),
                      context.verticalSpace(16),
                      _buildDetailRow(
                        context,
                        'Scheduling Duration',
                        sessionEntry?.durationSnapshot ?? 'Not set',
                        Icons.schedule,
                      ),
                      _buildDetailRow(
                        context,
                        'Base Price',
                        sessionEntry?.priceSnapshot ?? 'Not set',
                        Icons.payments_outlined,
                      ),

                      if (sessionEntry?.productUsageSnapshot.isNotEmpty ??
                          false) ...[
                        _buildDetailRowHeader(
                          context,
                          'Materials / Products Used',
                          Icons.inventory_2_outlined,
                        ),
                        ...sessionEntry!.productUsageSnapshot.map((p) {
                          // Try getting min and max overrides
                          final minVal = p.minQuantityController.text;
                          final maxVal = p.maxQuantityController.text;
                          return Padding(
                            padding: const EdgeInsets.only(left: 28, bottom: 4),
                            child: Text(
                              '• ${p.productName} (Min: $minVal | Max: $maxVal ${p.unit})',
                              style: context.fonts.grey12w400,
                            ),
                          );
                        }),
                      ],

                      if (sessionEntry?.followUps.isNotEmpty ?? false) ...[
                        _buildDetailRowHeader(
                          context,
                          'Follow-Up Procedures',
                          Icons.replay_outlined,
                        ),
                        ...sessionEntry!.followUps.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final fu = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(left: 28, bottom: 4),
                            child: Text(
                              '• Follow-Up ${idx + 1}: ${fu.type.toUpperCase()} - interval of ${fu.intervalValueController.text} ${fu.intervalUnit} (for ${fu.durationValueController.text} ${fu.durationUnit})',
                              style: context.fonts.grey12w400,
                            ),
                          );
                        }),
                      ],

                      if (sessionEntry?.preInstructionsSnapshot.isNotEmpty ??
                          false) ...[
                        context.verticalSpace(8),
                        _buildDetailRow(
                          context,
                          'Pre-Care Instructions',
                          sessionEntry?.preInstructionsSnapshot ?? '',
                          Icons.login_rounded,
                        ),
                      ],

                      if (sessionEntry?.postInstructionsSnapshot.isNotEmpty ??
                          false) ...[
                        context.verticalSpace(8),
                        _buildDetailRow(
                          context,
                          'Post-Care Instructions',
                          sessionEntry?.postInstructionsSnapshot ?? '',
                          Icons.logout_rounded,
                        ),
                      ],

                      if (sessionEntry?.preNotificationsSnapshot.isNotEmpty ??
                          false) ...[
                        _buildDetailRowHeader(
                          context,
                          'Pre-Notifications',
                          Icons.notifications_active_outlined,
                        ),
                        ...sessionEntry!.preNotificationsSnapshot.map((n) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 28, bottom: 4),
                            child:
                                Text('• $n', style: context.fonts.grey12w400),
                          );
                        }),
                      ],

                      if (sessionEntry?.postNotificationsSnapshot.isNotEmpty ??
                          false) ...[
                        _buildDetailRowHeader(
                          context,
                          'Post-Notifications',
                          Icons.notifications_active_outlined,
                        ),
                        ...sessionEntry!.postNotificationsSnapshot.map((n) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 28, bottom: 4),
                            child:
                                Text('• $n', style: context.fonts.grey12w400),
                          );
                        }),
                      ],

                      context.verticalSpace(8),
                      _buildDetailRow(
                        context,
                        'Downtime Restriction Level',
                        (sessionEntry?.downtimeSnapshot ?? 'None')
                            .toUpperCase(),
                        Icons.hourglass_bottom_rounded,
                      ),

                      if (sessionEntry?.rolesSnapshot.isNotEmpty ?? false) ...[
                        context.verticalSpace(8),
                        _buildDetailRow(
                          context,
                          'Allowed Roles',
                          sessionEntry!.rolesSnapshot.join(', '),
                          Icons.badge_outlined,
                        ),
                      ],

                      context.verticalSpace(8),
                      _buildDetailRow(
                        context,
                        'Procedural Consent Form',
                        sessionEntry?.consentSnapshot ??
                            'Category Consent Form',
                        Icons.fact_check_outlined,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
