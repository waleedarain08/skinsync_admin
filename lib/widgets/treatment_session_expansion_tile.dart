import 'package:flutter/material.dart';
import 'package:skinsync_admin/models/responses/treatment_detail_response.dart';
import 'package:skinsync_admin/utils/theme.dart';

class TreatmentSessionExpansionTile extends StatelessWidget {
  final TreatmentSessionDto session;

  const TreatmentSessionExpansionTile({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
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
                  session.title ?? 'Clinical Procedure Session',
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
                  session.status ?? 'Active',
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
                  'Session #${session.sessionNumber}',
                ),
                _sessionMetaChip(
                  context,
                  Icons.layers_outlined,
                  'Step ${session.currentStep ?? 2}',
                ),
                _sessionMetaChip(
                  context,
                  Icons.location_searching,
                  session.areaName ?? 'Target Area',
                ),
              ],
            ),
          ),
          childrenPadding: context.appEdgeInsets(horizontal: 16, vertical: 16),
          children: [
            const Divider(),
            context.verticalSpace(12),
            _buildDetailRow(context, 'Session ID', '${session.id ?? "—"}'),
            _buildDetailRow(context, 'Treatment ID', '${session.treatmentId ?? "—"}'),
            _buildDetailRow(context, 'Procedure Step', 'Step ${session.currentStep ?? 12}'),
            _buildDetailRow(context, 'Completion Status', session.isCompleted == true ? 'Completed ✓' : 'In-Progress'),
            _buildDetailRow(context, 'Created Date', _formatTimestamp(session.createdAt)),
          ],
        ),
      ),
    );
  }

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

  String _formatTimestamp(DateTime? dt) {
    if (null == dt) return '—';
    try {
      final date = dt.toLocal();
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (_) {
      return '—';
    }
  }
}
