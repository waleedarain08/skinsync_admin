import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/screens/create_session_screen.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/session_view_model.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_outlined_button.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';

class SessionsStep extends ConsumerStatefulWidget {
  const SessionsStep({super.key});

  @override
  ConsumerState<SessionsStep> createState() => _SessionsStepState();
}

class _SessionsStepState extends ConsumerState<SessionsStep> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final state = ref.read(treatmentViewModelProvider);
      final treatmentId = state.selectedTreatment?.id;
      final areaId = state.selectedTreatmentAreaIds.isNotEmpty
          ? state.selectedTreatmentAreaIds.last
          : null;

      if (treatmentId != null && areaId != null) {
        await ref
            .read(sessionViewModelProvider.notifier)
            .fetchSessions(treatmentId: treatmentId, areaId: areaId);
      }
    });
  }

  Widget _sectionTitle(BuildContext context, String title, {double? fontSize}) {
    return Text(
      title,
      style: context.fonts.black18w600.copyWith(
        fontSize: fontSize != null ? context.sp(fontSize) : null,
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

  void _showAddSessionDialog(
    BuildContext context,
    SessionViewModel sessionViewModel,
    TreatmentState state,
  ) {
    final titleController = TextEditingController();
    final numberController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: context.appBorderRadius(all: 16),
          ),
          title: Text('Add Clinical Session', style: context.fonts.black16w600),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BuildTextField(
                label: 'Session Title',
                controller: titleController,
                hintText: 'e.g. Initial Botox Session',
              ),
              context.verticalSpace(16),
              BuildTextField(
                label: 'Session Number / Order',
                controller: numberController,
                hintText: 'e.g. 1',
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            SizedBox(
              width: context.w(120),
              child: CustomPrimaryButton(
                onTap: () async {
                  final title = titleController.text.trim();
                  final numVal =
                      int.tryParse(numberController.text.trim()) ?? 1;

                  final resolvedTitle = title.isEmpty
                      ? 'Session $numVal'
                      : title;
                  final treatmentId = state.selectedTreatment?.id;
                  if (treatmentId == null) {
                    await EasyLoading.showError(
                      'Invalid treatment template. Please select one in Step 1.',
                    );
                    return;
                  }

                  if (state.selectedTreatmentAreaIds.isEmpty) {
                    await EasyLoading.showError(
                      'No body area selected. Please select one in Step 2.',
                    );
                    return;
                  }

                  final areaId = state.selectedTreatmentAreaIds.last;

                  final success = await sessionViewModel.createSession(
                    treatmentId: treatmentId,
                    areaId: areaId,
                    title: resolvedTitle,
                    sessionNumber: numVal,
                  );

                  if (success == true) {
                    await EasyLoading.showSuccess(
                      'Session created successfully!',
                    );
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                },
                label: 'Add',
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(treatmentViewModelProvider);
    final sessionState = ref.watch(sessionViewModelProvider);
    final sessionViewModel = ref.read(sessionViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle(context, 'Sessions Configuration'),
                context.verticalSpace(4),
                Text(
                  'Add and configure individual clinical sessions for this treatment template.',
                  style: context.fonts.grey14w400,
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () =>
                  _showAddSessionDialog(context, sessionViewModel, state),
              icon: const Icon(Icons.add, color: Colors.white, size: 18),
              label: Text('Add Session', style: context.fonts.white14w600),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.purple,
                padding: context.appEdgeInsets(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: context.appBorderRadius(all: 8),
                ),
              ),
            ),
          ],
        ),
        context.verticalSpace(32),

        if (sessionState.sessions.isEmpty) ...[
          Container(
            width: double.infinity,
            padding: context.appEdgeInsets(all: 32),
            decoration: BoxDecoration(
              color: CustomColors.whiteGrey,
              borderRadius: context.appBorderRadius(all: 12),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.layers_clear_outlined,
                  color: CustomColors.grey,
                  size: 40,
                ),
                context.verticalSpace(12),
                Text(
                  'No sessions configured for this treatment yet.',
                  style: context.fonts.black14w600,
                ),
                Text(
                  'Click "Add Session" to add a new clinical session card.',
                  style: context.fonts.grey12w400,
                ),
              ],
            ),
          ),
        ] else ...[
          Container(
            width: double.infinity,
            padding: context.appEdgeInsets(all: 20),
            decoration: BoxDecoration(
              color: CustomColors.whiteGrey,
              borderRadius: context.appBorderRadius(all: 12),
              border: Border.all(color: CustomColors.border),
            ),
            child: Column(
              children: List.generate(sessionState.sessions.length, (index) {
                final sessionEntry = sessionState.sessions[index];
                final bool isDetailed = sessionEntry.isDetailedEntered;
                final sessionTitle =
                    sessionEntry.title ??
                    'Session ${sessionEntry.sessionNumber}';

                if (!isDetailed) {
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
                              '${sessionEntry.sessionNumber}',
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
                                    sessionTitle,
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
                                          (sessionEntry.status.toLowerCase() ==
                                                      'completed'
                                                  ? CustomColors.green
                                                  : CustomColors.red)
                                              .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      sessionEntry.status,
                                      style: TextStyle(
                                        color:
                                            sessionEntry.status.toLowerCase() ==
                                                'completed'
                                            ? CustomColors.green
                                            : CustomColors.red,
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
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomPrimaryButton(
                              width: context.w(130),
                              onTap: () {
                                log('SessionID ${sessionEntry.sessionId}');
                                sessionViewModel.setSessionId(
                                  sessionEntry.sessionId,
                                );
                                sessionViewModel.setActiveSessionIndex(index);
                                sessionViewModel.setSessionStep(1);
                                context.push(CreateSessionScreen.routeName);
                              },
                              label: 'Enter Detail',
                            ),
                            context.horizontalSpace(12),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: CustomColors.red,
                              ),
                              onPressed: () =>
                                  sessionViewModel.removeCustomSession(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: context.appBorderRadius(all: 12),
                    border: Border.all(color: CustomColors.green, width: 1.5),
                  ),
                  child: Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(dividerColor: Colors.transparent),
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
                            '${sessionEntry.sessionNumber}',
                            style: context.fonts.white10w700,
                          ),
                        ),
                      ),
                      title: Row(
                        children: [
                          Text(sessionTitle, style: context.fonts.black14w700),
                          context.horizontalSpace(8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  (sessionEntry.status.toLowerCase() == 'draft'
                                          ? CustomColors.red
                                          : CustomColors.green)
                                      .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  sessionEntry.status.toLowerCase() == 'draft'
                                      ? Icons.close
                                      : Icons.check,
                                  color:
                                      sessionEntry.status.toLowerCase() ==
                                          'draft'
                                      ? CustomColors.red
                                      : CustomColors.green,
                                  size: 10,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  sessionEntry.status,
                                  style: TextStyle(
                                    color:
                                        sessionEntry.status.toLowerCase() ==
                                            'draft'
                                        ? CustomColors.red
                                        : CustomColors.green,
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
                            width: context.w(100),
                            height: context.h(32),
                            onTap: () {
                              sessionViewModel.setActiveSessionIndex(index);
                              sessionViewModel.setSessionStep(1);
                              context.push(CreateSessionScreen.routeName);
                            },
                            label: 'Edit Detail',
                          ),
                          context.horizontalSpace(12),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: CustomColors.red,
                            ),
                            onPressed: () =>
                                sessionViewModel.removeCustomSession(index),
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
                          sessionEntry.durationSnapshot,
                          Icons.schedule,
                        ),
                        _buildDetailRow(
                          context,
                          'Base Price',
                          sessionEntry.priceSnapshot,
                          Icons.payments_outlined,
                        ),

                        if (sessionEntry.productUsageSnapshot.isNotEmpty) ...[
                          _buildDetailRowHeader(
                            context,
                            'Materials / Products Used',
                            Icons.inventory_2_outlined,
                          ),
                          ...sessionEntry.productUsageSnapshot.map((p) {
                            final minVal = p.minQuantityController.text;
                            final maxVal = p.maxQuantityController.text;
                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 28,
                                bottom: 4,
                              ),
                              child: Text(
                                '• ${p.productName} (Min: $minVal | Max: $maxVal ${p.unit})',
                                style: context.fonts.grey12w400,
                              ),
                            );
                          }),
                        ],

                        if (sessionEntry.followUps.isNotEmpty) ...[
                          _buildDetailRowHeader(
                            context,
                            'Follow-Up Procedures',
                            Icons.replay_outlined,
                          ),
                          ...sessionEntry.followUps.asMap().entries.map((
                            entry,
                          ) {
                            final idx = entry.key;
                            final fu = entry.value;
                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 28,
                                bottom: 4,
                              ),
                              child: Text(
                                '• Follow-Up ${idx + 1}: ${fu.type.toUpperCase()} - interval of ${fu.intervalValueController.text} ${fu.intervalUnit} (for ${fu.durationValueController.text} ${fu.durationUnit})',
                                style: context.fonts.grey12w400,
                              ),
                            );
                          }),
                        ],

                        if (sessionEntry
                            .preInstructionsSnapshot
                            .isNotEmpty) ...[
                          context.verticalSpace(8),
                          _buildDetailRow(
                            context,
                            'Pre-Care Instructions',
                            sessionEntry.preInstructionsSnapshot,
                            Icons.login_rounded,
                          ),
                        ],

                        if (sessionEntry
                            .postInstructionsSnapshot
                            .isNotEmpty) ...[
                          context.verticalSpace(8),
                          _buildDetailRow(
                            context,
                            'Post-Care Instructions',
                            sessionEntry.postInstructionsSnapshot,
                            Icons.logout_rounded,
                          ),
                        ],

                        if (sessionEntry
                            .preNotificationsSnapshot
                            .isNotEmpty) ...[
                          _buildDetailRowHeader(
                            context,
                            'Pre-Notifications',
                            Icons.notifications_active_outlined,
                          ),
                          ...sessionEntry.preNotificationsSnapshot.map((n) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 28,
                                bottom: 4,
                              ),
                              child: Text(
                                '• $n',
                                style: context.fonts.grey12w400,
                              ),
                            );
                          }),
                        ],

                        if (sessionEntry
                            .postNotificationsSnapshot
                            .isNotEmpty) ...[
                          _buildDetailRowHeader(
                            context,
                            'Post-Notifications',
                            Icons.notifications_active_outlined,
                          ),
                          ...sessionEntry.postNotificationsSnapshot.map((n) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 28,
                                bottom: 4,
                              ),
                              child: Text(
                                '• $n',
                                style: context.fonts.grey12w400,
                              ),
                            );
                          }),
                        ],

                        context.verticalSpace(8),
                        _buildDetailRow(
                          context,
                          'Downtime Restriction Level',
                          sessionEntry.downtimeSnapshot.toUpperCase(),
                          Icons.hourglass_bottom_rounded,
                        ),

                        if (sessionEntry.rolesSnapshot.isNotEmpty) ...[
                          context.verticalSpace(8),
                          _buildDetailRow(
                            context,
                            'Allowed Roles',
                            sessionEntry.rolesSnapshot.join(', '),
                            Icons.badge_outlined,
                          ),
                        ],

                        context.verticalSpace(8),
                        _buildDetailRow(
                          context,
                          'Procedural Consent Form',
                          sessionEntry.consentSnapshot,
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
      ],
    );
  }
}
