import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import '../widgets/dailogbox/on_view_dailog_box.dart';

class DisputeScreen extends StatelessWidget {
  const DisputeScreen({super.key});
  static const String routeName = '/dispute-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.dashboardBackgroundColor,
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
        Text("Dispute Management", style: CustomFonts.black30w600),
        SizedBox(height: 8.h),
        Text(
          "Review, mediate, and resolve patient-clinic disputes.",
          style: CustomFonts.grey18w400,
        ),
      ],
    );
  }

  Widget _buildDisputeMetrics() {
    return Row(
      children: [
        _buildMetricCard("Active Disputes", "12", Icons.gavel_outlined, CustomColors.errorRed),
        SizedBox(width: 16.w),
        _buildMetricCard("Pending Review", "8", Icons.hourglass_top, CustomColors.warningOrange),
        SizedBox(width: 16.w),
        _buildMetricCard("Resolved (30d)", "45", Icons.check_circle_outline, CustomColors.successGreen),
        SizedBox(width: 16.w),
        _buildMetricCard("Avg Resolution Time", "2.4 Days", Icons.timer_outlined, CustomColors.deepNavy),
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
                Text(title, style: CustomFonts.grey18w400.copyWith(fontSize: 12.sp)),
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
              headingRowColor: WidgetStateProperty.all(CustomColors.softChampagne.withOpacity(0.5)),
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
        const DataCell(Text('#DSP-421')),
        const DataCell(Text('Emily Davis')),
        const DataCell(Text('Pure Skin Care')),
        const DataCell(Text('Service mismatch')),
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(color: CustomColors.errorRed.withOpacity(0.1), borderRadius: BorderRadius.circular(4.r)),
            child: const Text("High", style: TextStyle(color: CustomColors.errorRed, fontSize: 10, fontWeight: FontWeight.bold)),
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
              IconButton(icon: const Icon(Icons.check_circle_outline, size: 20, color: CustomColors.successGreen), onPressed: () {}),
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
              headingRowColor: WidgetStateProperty.all(CustomColors.softChampagne.withOpacity(0.5)),
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
        const DataCell(Text('#DSP-390')),
        const DataCell(Text('Aura Med Spa')),
        const DataCell(Text('Admin Alex')),
        const DataCell(Text('Partial Refund Release')),
        const DataCell(Text('Oct 20, 2023')),
      ],
    );
  }
}
