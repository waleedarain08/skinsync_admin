import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import '../widgets/dailogbox/on_view_dailog_box.dart';

import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

class DisputeScreen extends StatelessWidget {
  const DisputeScreen({super.key});
  static const String routeName = '/dispute-screen';

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 32.h),
            _buildDisputeMetrics(),
            SizedBox(height: 32.h),
            _buildPendingDisputesTable(context),
            SizedBox(height: 32.h),
            _buildResolvedDisputesTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Dispute Management", style: CustomFonts.black26w700),
        SizedBox(height: 8.h),
        Text(
          "Review, mediate, and resolve patient-clinic disputes.",
          style: CustomFonts.grey14w400,
        ),
      ],
    );
  }

  Widget _buildDisputeMetrics() {
    return Row(
      children: [
        _buildMetricCard("Active Disputes", "12", Icons.gavel_outlined, CustomColors.red),
        SizedBox(width: 16.w),
        _buildMetricCard("Pending Review", "8", Icons.hourglass_top, CustomColors.amber),
        SizedBox(width: 16.w),
        _buildMetricCard("Resolved (30d)", "45", Icons.check_circle_outline, CustomColors.green),
        SizedBox(width: 16.w),
        _buildMetricCard("Avg Resolution Time", "2.4 Days", Icons.timer_outlined, CustomColors.black),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: BorderdContainerWidget(
        padding: EdgeInsets.all(24.w),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28.sp),
            SizedBox(width: 16.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: CustomFonts.black20w600),
                Text(title, style: CustomFonts.grey12w400),
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
            padding: EdgeInsets.all(20.w),
            child: Text("Pending Action", style: CustomFonts.black20w600),
          ),
          SizedBox(
            height: 300.h,
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
        DataCell(Text('#DSP-421', style: CustomFonts.black14w400)),
        DataCell(Text('Emily Davis', style: CustomFonts.black14w400)),
        DataCell(Text('Pure Skin Care', style: CustomFonts.black14w400)),
        DataCell(Text('Service mismatch', style: CustomFonts.black14w400)),
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(color: CustomColors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4.r)),
            child: Text("High", style: CustomFonts.red10w700), // Updated to static style
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

  Widget _buildResolvedDisputesTable() {
    return BorderdContainerWidget(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Text("Resolution History", style: CustomFonts.black20w600),
          ),
          SizedBox(
            height: 300.h,
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
              rows: List.generate(5, (index) => _resolvedDisputeRow()),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _resolvedDisputeRow() {
    return DataRow(
      cells: [
        DataCell(Text('#DSP-390', style: CustomFonts.black14w400)),
        DataCell(Text('Aura Med Spa', style: CustomFonts.black14w400)),
        DataCell(Text('Admin Alex', style: CustomFonts.black14w400)),
        DataCell(Text('Partial Refund Release', style: CustomFonts.black14w400)),
        DataCell(Text('Oct 20, 2023', style: CustomFonts.black14w400)),
      ],
    );
  }
}
