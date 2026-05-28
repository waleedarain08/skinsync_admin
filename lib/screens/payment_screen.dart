import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import '../widgets/dailogbox/payment_dailog_box.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});
  static const String routeName = '/payment-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundLight,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 32.h),
            _buildFinancialOverview(),
            SizedBox(height: 32.h),
            _buildPendingReleasesTable(context),
            SizedBox(height: 32.h),
            _buildPaymentHistoryTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Payment Management", style: CustomFonts.black26w700),
        SizedBox(height: 8.h),
        Text(
          "Manage financial flows, transaction disputes, and clinic payouts.",
          style: CustomFonts.grey14w400,
        ),
      ],
    );
  }

  Widget _buildFinancialOverview() {
    return Row(
      children: [
        _buildFinancialStat("Total Revenue", "\$1,245,000", Icons.payments_outlined, CustomColors.primaryGold),
        SizedBox(width: 16.w),
        _buildFinancialStat("Pending Payouts", "\$12,450", Icons.hourglass_empty, CustomColors.warningOrange),
        SizedBox(width: 16.w),
        _buildFinancialStat("Successful Payouts", "\$845,000", Icons.check_circle_outline, CustomColors.successGreen),
        SizedBox(width: 16.w),
        _buildFinancialStat("Active Disputes", "4", Icons.gavel_outlined, CustomColors.errorRed),
      ],
    );
  }

  Widget _buildFinancialStat(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: BorderdContainerWidget(
        padding: EdgeInsets.all(24.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12.r)),
              child: Icon(icon, color: color, size: 24.sp),
            ),
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

  Widget _buildPendingReleasesTable(BuildContext context) {
    return BorderdContainerWidget(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Pending Payout Releases", style: CustomFonts.black20w600),
                Text("8 Actions Required", style: CustomFonts.warning14w600),
              ],
            ),
          ),
          SizedBox(
            height: 300.h,
            child: DataTable2(
              columnSpacing: 24,
              horizontalMargin: 20,
              minWidth: 1000,
              headingRowColor: WidgetStateProperty.all(CustomColors.surfaceMuted),
              columns: const [
                DataColumn2(label: Text('Transaction ID'), size: ColumnSize.L),
                DataColumn2(label: Text('Clinic'), size: ColumnSize.L),
                DataColumn2(label: Text('Patient'), size: ColumnSize.L),
                DataColumn2(label: Text('Amount'), size: ColumnSize.M),
                DataColumn2(label: Text('Date'), size: ColumnSize.M),
                DataColumn2(label: Text('Action'), size: ColumnSize.M),
              ],
              rows: List.generate(3, (index) => _pendingPayoutRow(context)),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _pendingPayoutRow(BuildContext context) {
    return DataRow(
      cells: [
        DataCell(Text('TXN-82910', style: CustomFonts.black14w400)),
        DataCell(Text('Glow MedSpa NY', style: CustomFonts.black14w400)),
        DataCell(Text('Sarah Jenkins', style: CustomFonts.black14w400)),
        DataCell(Text('\$450.00', style: CustomFonts.success14w600)),
        DataCell(Text('Oct 28, 2023', style: CustomFonts.black14w400)),
        DataCell(
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const ReleasePaymentDialog(
                  transactionId: "TXN-82910",
                  patientName: "Sarah Jenkins",
                  clinicName: "Glow MedSpa NY",
                  serviceName: "Dermal Fillers",
                  amount: "\$450.00",
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.deepNavy,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              minimumSize: Size(0, 36.h),
            ),
            child: Text("Release", style: CustomFonts.white12w600),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentHistoryTable() {
    return BorderdContainerWidget(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Text("Payout History", style: CustomFonts.black20w600),
          ),
          SizedBox(
            height: 400.h,
            child: DataTable2(
              columnSpacing: 24,
              horizontalMargin: 20,
              minWidth: 1000,
              headingRowColor: WidgetStateProperty.all(CustomColors.surfaceMuted),
              columns: const [
                DataColumn2(label: Text('Ref ID'), size: ColumnSize.L),
                DataColumn2(label: Text('Clinic'), size: ColumnSize.L),
                DataColumn2(label: Text('Amount'), size: ColumnSize.M),
                DataColumn2(label: Text('Released On'), size: ColumnSize.M),
                DataColumn2(label: Text('Status'), size: ColumnSize.M),
              ],
              rows: List.generate(5, (index) => _payoutHistoryRow()),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _payoutHistoryRow() {
    return DataRow(
      cells: [
        DataCell(Text('REF-001928', style: CustomFonts.black14w400)),
        DataCell(Text('Radiance Beauty', style: CustomFonts.black14w400)),
        DataCell(Text('\$2,800.00', style: CustomFonts.black14w400)),
        DataCell(Text('Oct 24, 2023', style: CustomFonts.black14w400)),
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(color: CustomColors.successGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20.r)),
            child: Text("Released", style: CustomFonts.success14w600), // Updated to a static style
          ),
        ),
      ],
    );
  }
}
