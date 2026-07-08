import 'package:flutter/material.dart';
import 'package:skinsync_admin/models/session_model.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/session_view_model.dart';
import 'package:skinsync_admin/widgets/custom_outlined_button.dart';

class TreatmentSessionExpansionTile extends StatelessWidget {
  final SessionModel? session;
  final SessionViewModelEntry? sessionEntry;
  final int? index;
  final VoidCallback? onEditDetail;
  final VoidCallback? onDelete;
  final ValueChanged<bool>? onExpansionChanged;

  const TreatmentSessionExpansionTile({
    super.key,
    this.session,
    this.sessionEntry,
    this.index,
    this.onEditDetail,
    this.onDelete,
    this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (sessionEntry != null) {
      return _buildCreationStepMode(context, sessionEntry!, index ?? 0);
    } else {
      return _buildDetailMode(
        context,
        session ??
            SessionModel(
              id: 0,
              treatmentId: 0,
              areaId: 0,
              areaName: '',
              title: '',
              sessionNumber: 0,
              status: '',
              currentStep: 0,
              isCompleted: false,
              createdAt: '',
            ),
      );
    }
  }

  // MODE A: Creation Step Mode (used inside SessionsStep setup wizard)
  Widget _buildCreationStepMode(BuildContext context, SessionViewModelEntry entry, int idx) {
    final bool isDetailed = entry.isDetailedEntered;
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
                          color: (entry.status.toLowerCase() == 'draft'
                                  ? CustomColors.red
                                  : CustomColors.green)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              entry.status.toLowerCase() == 'draft'
                                  ? Icons.close
                                  : Icons.check,
                              color: entry.status.toLowerCase() == 'draft'
                                  ? CustomColors.red
                                  : CustomColors.green,
                              size: 10,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              entry.status,
                              style: TextStyle(
                                color: entry.status.toLowerCase() == 'draft'
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
                CustomOutlinedButton(
                  width: context.w(110),
                  height: context.h(32),
                  onTap: onEditDetail ?? () {},
                  label: 'Enter Detail',
                ),
                context.horizontalSpace(12),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: CustomColors.red,
                    ),
                    onPressed: onDelete,
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
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          onExpansionChanged: onExpansionChanged,
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
                '${entry.sessionNumber}',
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
                  color: (entry.status.toLowerCase() == 'draft'
                          ? CustomColors.red
                          : CustomColors.green)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      entry.status.toLowerCase() == 'draft'
                          ? Icons.close
                          : Icons.check,
                      color: entry.status.toLowerCase() == 'draft'
                          ? CustomColors.red
                          : CustomColors.green,
                      size: 10,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      entry.status,
                      style: TextStyle(
                        color: entry.status.toLowerCase() == 'draft'
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
                onTap: onEditDetail ?? () {},
                label: 'Edit Detail',
              ),
              context.horizontalSpace(12),
              if (onDelete != null)
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: CustomColors.red,
                  ),
                  onPressed: onDelete,
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
            if (entry.postNotificationsSnapshot.isNotEmpty) ...[
              _buildSnapshotDetailRowHeader(
                context,
                'Post-Notifications',
                Icons.notifications_active_outlined,
              ),
              ...entry.postNotificationsSnapshot.map((n) {
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

  // MODE B: Detailed read-only Mode (used inside TreatmentDetailScreen)
  Widget _buildDetailMode(BuildContext context, SessionModel s) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: context.appBorderRadius(all: 12),
        border: Border.all(
          color: CustomColors.purple.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: CustomColors.purple.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: context.appBorderRadius(all: 12),
        child: ExpansionTile(
          shape: const RoundedRectangleBorder(side: BorderSide.none),
          collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
          backgroundColor: Colors.white,
          collapsedBackgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  s.title,
                  style: context.fonts.black14w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: CustomColors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  s.status,
                  style: context.fonts.green14w600.copyWith(
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                _sessionMetaChip(
                  context,
                  Icons.calendar_view_day,
                  'Session #${s.sessionNumber}',
                ),
                _sessionMetaChip(
                  context,
                  Icons.layers_outlined,
                  'Step ${s.currentStep}',
                ),
                _sessionMetaChip(
                  context,
                  Icons.location_searching,
                  s.areaName,
                ),
              ],
            ),
          ),
          childrenPadding: context.appEdgeInsets(horizontal: 16, vertical: 16),
          children: [
            const Divider(),
            context.verticalSpace(12),
            _buildDetailRow(context, 'Session ID', '${s.id}'),
            _buildDetailRow(context, 'Treatment ID', '${s.treatmentId}'),
            _buildDetailRow(context, 'Procedure Step', 'Step ${s.currentStep}'),
            _buildDetailRow(context, 'Completion Status', s.isCompleted == true ? 'Completed ✓' : 'In-Progress'),
            _buildDetailRow(context, 'Created Date', _formatTimestamp(s.createdAt)),
          ],
        ),
      ),
    );
  }

  // Shared Helper Widgets
  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: context.fonts.grey13w500),
          Text(value, style: context.fonts.black13w600),
        ],
      ),
    );
  }

  Widget _sessionMetaChip(BuildContext context, IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: CustomColors.grey),
        context.horizontalSpace(4),
        Text(
          label,
          style: context.fonts.grey11w400.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

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

  String _formatTimestamp(dynamic val) {
    if (null == val) return '—';
    try {
      DateTime dt;
      if (val is DateTime) {
        dt = val;
      } else if (val is String) {
        if (val.isEmpty) return '—';
        dt = DateTime.parse(val);
      } else {
        return '—';
      }
      final date = dt.toLocal();
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (_) {
      return '—';
    }
  }
}
