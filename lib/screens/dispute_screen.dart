import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

import '../widgets/dailogbox/on_view_dailog_box.dart';

class DisputeScreen extends StatelessWidget {
  const DisputeScreen({super.key});
  static const String routeName = '/dispute-screen';

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            context.verticalSpace(32),
            _buildDisputeMetrics(context),
            context.verticalSpace(32),
            _buildPendingDisputesTable(context),
            context.verticalSpace(32),
            _buildResolvedDisputesTable(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Dispute Management', style: context.fonts.black26w700),
        context.verticalSpace(8),
        Text(
          'Review, mediate, and resolve patient-clinic disputes.',
          style: context.fonts.grey14w400,
        ),
      ],
    );
  }

  Widget _buildDisputeMetrics(BuildContext context) {
    return Row(
      children: [
        _buildMetricCard(context, 'Active Disputes', '12', Icons.gavel_outlined, CustomColors.red),
        context.horizontalSpace(16),
        _buildMetricCard(context, 'Pending Review', '8', Icons.hourglass_top, CustomColors.amber),
        context.horizontalSpace(16),
        _buildMetricCard(context, 'Resolved (30d)', '45', Icons.check_circle_outline, CustomColors.green),
        context.horizontalSpace(16),
        _buildMetricCard(context, 'Avg Resolution Time', '2.4 Days', Icons.timer_outlined, CustomColors.black),
      ],
    );
  }

  Widget _buildMetricCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Expanded(
      child: BorderdContainerWidget(
        padding: context.appEdgeInsets(all: 24),
        child: Row(
          children: [
            Icon(icon, color: color, size: context.sp(28)),
            context.horizontalSpace(16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: context.fonts.black20w600),
                Text(title, style: context.fonts.grey12w400),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingDisputesTable(BuildContext context) {
    return BorderdContainerWidget(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: context.appEdgeInsets(all: 20),
            child: Text('Pending Action', style: context.fonts.black20w600),
          ),
          SizedBox(
            height: context.h(300),
            child: DataTable2(
              columnSpacing: 24,
              horizontalMargin: 20,
              minWidth: 1000,
              headingRowColor: WidgetStateProperty.all(CustomColors.softGrey),
              columns: const [
                DataColumn2(label: Text('ID'), size: ColumnSize.S),
                DataColumn2(label: Text('Patient'), size: ColumnSize.L),
                DataColumn2(label: Text('Clinic'), size: ColumnSize.L),
                DataColumn2(label: Text('Reason'), size: ColumnSize.L),
                DataColumn2(label: Text('Priority'), size: ColumnSize.M),
                DataColumn2(label: Text('Actions'), size: ColumnSize.M),
              ],
              rows: List.generate(3, (index) => _disputeRow(context)),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _disputeRow(BuildContext context) {
    return DataRow(
      cells: [
        DataCell(Text('#DSP-421', style: context.fonts.black14w400)),
        DataCell(Text('Emily Davis', style: context.fonts.black14w400)),
        DataCell(Text('Pure Skin Care', style: context.fonts.black14w400)),
        DataCell(Text('Service mismatch', style: context.fonts.black14w400)),
        DataCell(
          Container(
            padding: context.appEdgeInsets(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: CustomColors.red.withValues(alpha: 0.1), borderRadius: context.appBorderRadius(all: 4)),
            child: Text('High', style: context.fonts.red10w700),
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.visibility_outlined, size: 20),
                onPressed: () {
                  showDialog(context: context, builder: (_) => const DisputeDetailsDialog());
                },
              ),
              IconButton(icon: const Icon(Icons.check_circle_outline, size: 20, color: CustomColors.green), onPressed: () {}),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResolvedDisputesTable(BuildContext context) {
    return BorderdContainerWidget(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: context.appEdgeInsets(all: 20),
            child: Text('Resolution History', style: context.fonts.black20w600),
          ),
          SizedBox(
            height: context.h(300),
            child: DataTable2(
              columnSpacing: 24,
              horizontalMargin: 20,
              minWidth: 1000,
              headingRowColor: WidgetStateProperty.all(CustomColors.softGrey),
              columns: const [
                DataColumn2(label: Text('ID'), size: ColumnSize.S),
                DataColumn2(label: Text('Clinic'), size: ColumnSize.L),
                DataColumn2(label: Text('Resolved By'), size: ColumnSize.L),
                DataColumn2(label: Text('Outcome'), size: ColumnSize.L),
                DataColumn2(label: Text('Date'), size: ColumnSize.M),
              ],
              rows: List.generate(5, (index) => _resolvedDisputeRow(context)),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _resolvedDisputeRow(BuildContext context) {
    return DataRow(
      cells: [
        DataCell(Text('#DSP-390', style: context.fonts.black14w400)),
        DataCell(Text('Aura Med Spa', style: context.fonts.black14w400)),
        DataCell(Text('Admin Alex', style: context.fonts.black14w400)),
        DataCell(Text('Partial Refund Release', style: context.fonts.black14w400)),
        DataCell(Text('Oct 20, 2023', style: context.fonts.black14w400)),
      ],
    );
  }
}
