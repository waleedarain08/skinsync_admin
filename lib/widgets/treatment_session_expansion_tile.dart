import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/session_model.dart';
import 'package:skinsync_admin/screens/create_session_screen.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/session_view_model.dart';
import 'package:skinsync_admin/widgets/custom_outlined_button.dart';
import 'package:skinsync_admin/widgets/status_toggle_switch.dart';

class TreatmentSessionExpansionTile extends ConsumerWidget {
  final SessionModel? session;
  final SessionViewModelEntry? sessionEntry;
  final int? index;
  final VoidCallback? onEditDetail;
  final VoidCallback? onDelete;
  final ValueChanged<bool>? onExpansionChanged;
  final ValueChanged<String>? onStatusChanged;

  const TreatmentSessionExpansionTile({
    super.key,
    this.session,
    this.sessionEntry,
    this.index,
    this.onEditDetail,
    this.onDelete,
    this.onExpansionChanged,
    this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (sessionEntry != null) {
      return _buildTileWithEntry(context, ref, sessionEntry!, index ?? 0);
    } else if (session != null) {
      final sessionState = ref.watch(sessionViewModelProvider);
      SessionViewModelEntry? matchedEntry;
      for (final s in sessionState.sessions) {
        if (s.sessionId == session!.id) {
          matchedEntry = s;
          break;
        }
      }

      final entryToUse =
          matchedEntry ??
          SessionViewModelEntry(
            sessionId: session!.id,
            sessionNumber: session!.sessionNumber,
            title: session!.title,
            status: session!.status,
            isDetailedEntered: session?.status.toLowerCase() != 'draft',
          );

      return _buildTileWithEntry(context, ref, entryToUse, index ?? 0);
    } else {
      return const SizedBox.shrink();
    }
  }

  String _mapStatusForToggle(String status) {
    final s = status.toLowerCase();
    if (s == 'deactive' || s == 'inactive') return 'Inactive';
    if (s == 'active') return 'Active';
    return 'Draft';
  }

  Widget _buildStatusToggle(
    BuildContext context,
    WidgetRef ref,
    SessionViewModelEntry entry,
  ) {
    return StatusToggleSwitch(
      width: context.w(80),
      height: context.h(28),
      status: _mapStatusForToggle(entry.status),
      onChanged: (newStatus) {
        if (onStatusChanged != null) {
          onStatusChanged!(newStatus);
        } else {
          _handleDefaultStatusChange(ref, entry, newStatus);
        }
      },
    );
  }

  // Handle Default Status Change Trigger (Highly Decoupled)
  void _handleDefaultStatusChange(
    WidgetRef ref,
    SessionViewModelEntry entry,
    String newStatus,
  ) {
    // if (entry.sessionId != null) {
    //   ref
    //       .read(sessionViewModelProvider.notifier)
    //       .changeSessionStatus(entry.sessionId!, newStatus);
    // }
  }

  Widget _buildTileWithEntry(
    BuildContext context,
    WidgetRef ref,
    SessionViewModelEntry entry,
    int idx,
  ) {
    final bool isDetailed =
        entry.isDetailedEntered ||
        (entry.status.isNotEmpty && entry.status.toLowerCase() != 'draft');
    final sessionTitle = entry.title ?? 'Session ${entry.sessionNumber}';

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
                  '${entry.sessionNumber}',
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
                    mainAxisAlignment: .start,
                    children: [
                      Expanded(
                        child: Text(
                          sessionTitle,
                          style: context.fonts.black14w700,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      context.horizontalSpace(8),
                     

                      // Container(
                      //   padding: const EdgeInsets.symmetric(
                      //     horizontal: 6,
                      //     vertical: 2,
                      //   ),
                      //   decoration: BoxDecoration(
                      //     color: (entry.status.toLowerCase() == 'draft' || entry.status.isEmpty
                      //             ? CustomColors.red
                      //             : CustomColors.green)
                      //         .withValues(alpha: 0.1),
                      //     borderRadius: BorderRadius.circular(4),
                      //   ),
                      //   child: Row(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       Icon(
                      //         entry.status.toLowerCase() == 'draft' || entry.status.isEmpty
                      //             ? Icons.close
                      //             : Icons.check,
                      //         color: entry.status.toLowerCase() == 'draft' || entry.status.isEmpty
                      //             ? CustomColors.red
                      //             : CustomColors.green,
                      //         size: 10,
                      //       ),
                      //       const SizedBox(width: 4),
                      //       Text(
                      //         entry.status.isEmpty ? 'DRAFT' : entry.status,
                      //         style: TextStyle(
                      //           color: entry.status.toLowerCase() == 'draft' || entry.status.isEmpty
                      //               ? CustomColors.red
                      //               : CustomColors.green,
                      //           fontSize: 10,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                  context.verticalSpace(4),
                  Text(
                    'No duration & timing setup found.',
                    style: context.fonts.grey11w400,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                 _buildStatusToggle(context, ref, entry),
                   context.horizontalSpace(12),
                CustomOutlinedButton(
                  width: context.w(110),
                  height: context.h(32),
                  onTap: () {
                    if (onEditDetail != null) {
                      onEditDetail!();
                    } else {
                      _handleDefaultEdit(context, ref, idx, entry);
                    }
                  },
                  label: 'Enter Detail',
                ),
                if (onDelete != null) ...[
                  context.horizontalSpace(12),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: CustomColors.red,
                    ),
                    onPressed: onDelete,
                  ),
                ],
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
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          onExpansionChanged: (expanded) {
            if (onExpansionChanged != null) {
              onExpansionChanged!(expanded);
            } else {
              _handleDefaultExpansion(ref, expanded, entry);
            }
          },
          tilePadding: context.appEdgeInsets(horizontal: 16, vertical: 8),
          childrenPadding: context.appEdgeInsets(horizontal: 20, vertical: 16),
          leading: Container(
            width: context.w(32),
            height: context.w(32),
            decoration: const BoxDecoration(
              color: CustomColors.green,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${entry.sessionNumber}',
                style: context.fonts.white10w700,
              ),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  sessionTitle,
                  style: context.fonts.black14w700,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              context.horizontalSpace(8),
              

              // Container(
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 6,
              //     vertical: 2,
              //   ),
              //   decoration: BoxDecoration(
              //     color: (entry.status.toLowerCase() == 'draft'
              //             ? CustomColors.red
              //             : CustomColors.green)
              //         .withValues(alpha: 0.1),
              //     borderRadius: BorderRadius.circular(4),
              //   ),
              //   child: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       Icon(
              //         entry.status.toLowerCase() == 'draft'
              //             ? Icons.close
              //             : Icons.check,
              //         color: entry.status.toLowerCase() == 'draft'
              //             ? CustomColors.red
              //             : CustomColors.green,
              //         size: 10,
              //       ),
              //       const SizedBox(width: 4),
              //       Text(
              //         entry.status,
              //         style: TextStyle(
              //           color: entry.status.toLowerCase() == 'draft'
              //               ? CustomColors.red
              //               : CustomColors.green,
              //           fontSize: 10,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
          subtitle: Text(
            'Tap to expand blueprint summary details.',
            style: context.fonts.grey11w400,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatusToggle(context, ref, entry),
              context.horizontalSpace(12),
              CustomOutlinedButton(
                width: context.w(100),
                height: context.h(32),
                onTap: () {
                  if (onEditDetail != null) {
                    onEditDetail!();
                  } else {
                    _handleDefaultEdit(context, ref, idx, entry);
                  }
                },
                label: 'Edit Detail',
              ),
              if (onDelete != null) ...[
                context.horizontalSpace(12),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: CustomColors.red,
                  ),
                  onPressed: onDelete,
                ),
              ],
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
            _buildSnapshotDetailRow(
              context,
              'Scheduling Duration',
              entry.durationSnapshot,
              Icons.schedule,
            ),
            _buildSnapshotDetailRow(
              context,
              'Base Price',
              entry.priceSnapshot,
              Icons.payments_outlined,
            ),
            if (entry.productUsageSnapshot.isNotEmpty) ...[
              _buildSnapshotDetailRowHeader(
                context,
                'Materials / Products Used',
                Icons.inventory_2_outlined,
              ),
              ...entry.productUsageSnapshot.map((p) {
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
            if (entry.followUps.isNotEmpty) ...[
              _buildSnapshotDetailRowHeader(
                context,
                'Follow-Up Procedures',
                Icons.replay_outlined,
              ),
              ...entry.followUps.asMap().entries.map((followUpEntry) {
                final idx = followUpEntry.key;
                final fu = followUpEntry.value;
                return Padding(
                  padding: const EdgeInsets.only(left: 28, bottom: 4),
                  child: Text(
                    '• Follow-Up ${idx + 1}: ${fu.type.toUpperCase()} - interval of ${fu.intervalValueController.text} ${fu.intervalUnit} (for ${fu.durationValueController.text} ${fu.durationUnit})',
                    style: context.fonts.grey12w400,
                  ),
                );
              }),
            ],
            if (entry.preInstructionsSnapshot.isNotEmpty) ...[
              context.verticalSpace(8),
              _buildSnapshotDetailRow(
                context,
                'Pre-Care Instructions',
                entry.preInstructionsSnapshot,
                Icons.login_rounded,
              ),
            ],
            if (entry.postInstructionsSnapshot.isNotEmpty) ...[
              context.verticalSpace(8),
              _buildSnapshotDetailRow(
                context,
                'Post-Care Instructions',
                entry.postInstructionsSnapshot,
                Icons.logout_rounded,
              ),
            ],
            if (entry.preNotificationsSnapshot.isNotEmpty) ...[
              _buildSnapshotDetailRowHeader(
                context,
                'Pre-Notifications',
                Icons.notifications_active_outlined,
              ),
              ...entry.preNotificationsSnapshot.map((n) {
                return Padding(
                  padding: const EdgeInsets.only(left: 28, bottom: 4),
                  child: Text('• $n', style: context.fonts.grey12w400),
                );
              }),
            ],
            if (entry.postNotificationsSnapshot.isNotEmpty) ...[
              _buildSnapshotDetailRowHeader(
                context,
                'Post-Notifications',
                Icons.notifications_active_outlined,
              ),
              ...entry.postNotificationsSnapshot.map((n) {
                return Padding(
                  padding: const EdgeInsets.only(left: 28, bottom: 4),
                  child: Text('• $n', style: context.fonts.grey12w400),
                );
              }),
            ],
            context.verticalSpace(8),
            _buildSnapshotDetailRow(
              context,
              'Downtime Restriction Level',
              entry.downtimeSnapshot.toUpperCase(),
              Icons.hourglass_bottom_rounded,
            ),
            if (entry.rolesSnapshot.isNotEmpty) ...[
              context.verticalSpace(8),
              _buildSnapshotDetailRow(
                context,
                'Allowed Roles',
                entry.rolesSnapshot.join(', '),
                Icons.badge_outlined,
              ),
            ],
            context.verticalSpace(8),
            _buildSnapshotDetailRow(
              context,
              'Procedural Consent Form',
              entry.consentSnapshot,
              Icons.fact_check_outlined,
            ),
          ],
        ),
      ),
    );
  }

  // Handle Default Editing Trigger (Highly Decoupled)
  Future<void> _handleDefaultEdit(
    BuildContext context,
    WidgetRef ref,
    int idx,
    SessionViewModelEntry entry,
  ) async {
    final sessionViewModel = ref.read(sessionViewModelProvider.notifier);
    sessionViewModel.reset();

    // Ensure session list has at least this entry
    final currentSessions = ref.read(sessionViewModelProvider).sessions;
    final exists = currentSessions.any((s) => s.sessionId == entry.sessionId);
    if (!exists && session != null) {
      sessionViewModel.setSessions([session!]);
      sessionViewModel.setActiveSessionIndex(0);
    } else {
      sessionViewModel.setActiveSessionIndex(idx);
    }

    if (entry.sessionId != null) {
      final success = await sessionViewModel.fetchAndPopulateSessionDetail(
        entry.sessionId!,
      );
      if (success && context.mounted) {
        context.push(CreateSessionScreen.routeName);
      }
    } else {
      sessionViewModel.setSessionStep(1);
      if (context.mounted) {
        context.push(CreateSessionScreen.routeName);
      }
    }
  }

  // Handle Default Expansion Dynamic API Call
  Future<void> _handleDefaultExpansion(
    WidgetRef ref,
    bool expanded,
    SessionViewModelEntry entry,
  ) async {
    if (expanded && entry.sessionId != null) {
      final sessionViewModel = ref.read(sessionViewModelProvider.notifier);

      // Ensure sessions list has this session
      final currentSessions = ref.read(sessionViewModelProvider).sessions;
      final exists = currentSessions.any((s) => s.sessionId == entry.sessionId);
      if (!exists && session != null) {
        sessionViewModel.setSessions([session!]);
      }

      await sessionViewModel.fetchAndPopulateSessionDetail(entry.sessionId!);
    }
  }

  // Helper Widgets
  Widget _buildSnapshotDetailRow(
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
              value.isEmpty ? '—' : value,
              style: context.fonts.grey12w400,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSnapshotDetailRowHeader(
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
}
