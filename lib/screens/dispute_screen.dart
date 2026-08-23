import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';
import 'package:skinsync_admin/widgets/mini_stat_card.dart';

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
        Text('Dispute Management', style: context.fonts.level1Heading),
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
        const MiniStatCard(
          title: 'Active Disputes',
          value: 12,
          icon: Icons.gavel_outlined,
          color: CustomColors.red,
        ),
        context.horizontalSpace(16),
        const MiniStatCard(
          title: 'Pending Review',
          value: 8,
          icon: Icons.hourglass_top,
          color: CustomColors.amber,
        ),
        context.horizontalSpace(16),
        const MiniStatCard(
          title: 'Resolved (30d)',
          value: 45,
          icon: Icons.check_circle_outline,
          color: CustomColors.green,
        ),
        context.horizontalSpace(16),
        const MiniStatCard(
          title: 'Avg Resolution Time',
          value: 2.4,
          suffix: ' Days',
          icon: Icons.timer_outlined,
          color: CustomColors.black,
        ),
      ],
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
            child: Text('Pending Action', style: context.fonts.subHeading),
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
            decoration: BoxDecoration(
              color: CustomColors.red.withValues(alpha: 0.1),
              borderRadius: context.appBorderRadius(all: 4),
            ),
            child: Text('High', style: context.fonts.red10w700),
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.visibility_outlined, size: 20),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const DisputeDetailsDialog(),
                  );
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.check_circle_outline,
                  size: 20,
                  color: CustomColors.green,
                ),
                onPressed: () {},
              ),
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
            child: Text('Resolution History', style: context.fonts.subHeading),
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
        DataCell(
          Text('Partial Refund Release', style: context.fonts.black14w400),
        ),
        DataCell(Text('Oct 20, 2023', style: context.fonts.black14w400)),
      ],
    );
  }
}
