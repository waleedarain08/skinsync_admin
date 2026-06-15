import 'package:flutter/material.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'standard_dialog.dart';

class TransactionDetailsDialog extends StatelessWidget {
  const TransactionDetailsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: 'Transaction Details',
      width: context.w(550),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailSection(context, 'Payment Info', {
            'Transaction ID': '#TRX-882194',
            'Date': 'Oct 24, 2025, 14:20',
            'Payment Method': 'Visa •••• 4242',
            'Status': 'Completed',
          }),
          context.verticalSpace(24),
          _buildDetailSection(context, 'Parties', {
            'Clinic': 'Radiant Skin Care',
            'Patient': 'Emily Davis',
          }),
          context.verticalSpace(24),
          _buildDetailSection(context, 'Breakdown', {
            'Service Amount': '\$250.00',
            'Commission (15%)': '\$37.50',
            'Net to Clinic': '\$212.50',
          }),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        CustomPrimaryButton(
          onTap: () => Navigator.pop(context),
          label: 'Download Receipt',
          width: context.w(180),
        ),
      ],
    );
  }

  Widget _buildDetailSection(BuildContext context, String title, Map<String, String> details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.fonts.black16w600),
        context.verticalSpace(12),
        Container(
          padding: context.appEdgeInsets(all: 16),
          decoration: BoxDecoration(
            color: CustomColors.whiteGrey,
            borderRadius: context.appBorderRadius(all: 12),
            border: Border.all(color: CustomColors.border),
          ),
          child: Column(
            children: details.entries.map((e) => Padding(
              padding: context.appEdgeInsets(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e.key, style: context.fonts.grey13w500),
                  Text(e.value, style: context.fonts.black14w600),
                ],
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }
}

class ReleasePaymentDialog extends StatelessWidget {
  final String transactionId;
  final String patientName;
  final String clinicName;
  final String serviceName;
  final String amount;
  final String? feedbackMessage;

  const ReleasePaymentDialog({
    super.key,
    required this.transactionId,
    required this.patientName,
    required this.clinicName,
    required this.serviceName,
    required this.amount,
    this.feedbackMessage,
  });

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: 'Release Payment',
      width: context.w(550),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Please review the transaction details before releasing the funds to the clinic's wallet.",
            style: context.fonts.grey14w400,
          ),
          context.verticalSpace(24),
          Container(
            padding: context.appEdgeInsets(all: 20),
            decoration: BoxDecoration(
              color: CustomColors.whiteGrey,
              borderRadius: context.appBorderRadius(all: 12),
              border: Border.all(color: CustomColors.border),
            ),
            child: Column(
              children: [
                _buildDetailRow(context, 'Transaction ID', transactionId),
                _buildDetailRow(context, 'Patient', patientName),
                _buildDetailRow(context, 'Clinic', clinicName),
                _buildDetailRow(context, 'Service', serviceName),
                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Amount', style: context.fonts.black16w600),
                    Text(amount, style: context.fonts.black20w600.copyWith(color: CustomColors.green)),
                  ],
                ),
              ],
            ),
          ),
          if (feedbackMessage != null) ...[
            context.verticalSpace(24),
            Text('Patient Feedback', style: context.fonts.black16w600),
            context.verticalSpace(8),
            Text(
              feedbackMessage!,
              style: context.fonts.black14w400.copyWith(fontStyle: FontStyle.italic),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        CustomPrimaryButton(
          onTap: () => Navigator.pop(context, true),
          label: 'Confirm Release',
          width: context.w(200),
        ),
      ],
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: context.appEdgeInsets(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: context.fonts.grey13w500),
          Text(value, style: context.fonts.black14w600),
        ],
      ),
    );
  }
}
