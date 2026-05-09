import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';

class PatientManagement extends StatefulWidget {
  static const String routeName = '/patient-management';
  const PatientManagement({super.key});

  @override
  State<PatientManagement> createState() => _PatientManagementState();
}

class _PatientManagementState extends State<PatientManagement> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 32.h),
          _buildQuickMetrics(),
          SizedBox(height: 32.h),
          _buildFilters(),
          SizedBox(height: 24.h),
          _buildPatientsTable(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Patient Directory", style: CustomFonts.textMain32w700),
        SizedBox(height: 4.h),
        Text(
          "Unified view of all patients across your clinic network.",
          style: CustomFonts.textMain14w400.copyWith(color: CustomColors.textMuted),
        ),
      ],
    );
  }

  Widget _buildQuickMetrics() {
    return Row(
      children: [
        _buildMetricCard("Total Patients", "12,840", Icons.people_rounded, CustomColors.brandPrimary),
        SizedBox(width: 16.w),
        _buildMetricCard("Verified", "8,200", Icons.verified_user_rounded, CustomColors.success),
        SizedBox(width: 16.w),
        _buildMetricCard("Mobile Users", "9,450", Icons.smartphone_rounded, CustomColors.info),
        SizedBox(width: 16.w),
        _buildMetricCard("Walk-ins", "3,390", Icons.directions_walk_rounded, CustomColors.brandPurple),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: CustomColors.textMuted.withValues(alpha: 0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 20.sp),
            ),
            SizedBox(height: 16.h),
            Text(value, style: TextStyle(color: CustomColors.textMain, fontSize: 24.sp, fontWeight: FontWeight.bold)),
            Text(title, style: TextStyle(color: CustomColors.textMuted, fontSize: 12.sp, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return BorderdContainerWidget(
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: CupertinoSearchTextField(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              placeholder: "Search patients...",
              backgroundColor: CustomColors.surfaceGhost,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          SizedBox(width: 16.w),
          _filterBadge("Clinic: All"),
          SizedBox(width: 8.w),
          _filterBadge("Source: All"),
          const Spacer(),
          TextButton.icon(onPressed: () {}, icon: const Icon(Icons.tune_rounded, size: 18), label: const Text("Advanced Filters")),
        ],
      ),
    );
  }

  Widget _filterBadge(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: CustomColors.textMuted.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Text(text, style: TextStyle(color: CustomColors.textMain, fontSize: 12.sp, fontWeight: FontWeight.w600)),
          SizedBox(width: 8.w),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 16),
        ],
      ),
    );
  }

  Widget _buildPatientsTable() {
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
                Text("Patient Records", style: CustomFonts.textMain20w600),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.file_download_outlined, size: 18),
                  label: const Text("Export CSV"),
                  style: OutlinedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h), minimumSize: const Size(0, 40)),
                ),
              ],
            ),
          ),
          DataTable(
            columnSpacing: 40.w,
            headingRowColor: WidgetStateProperty.all(CustomColors.surfaceGhost),
            headingTextStyle: TextStyle(color: CustomColors.textMuted, fontSize: 12.sp, fontWeight: FontWeight.bold),
            columns: const [
              DataColumn(label: Text('Patient')),
              DataColumn(label: Text('Registration')),
              DataColumn(label: Text('Clinic')),
              DataColumn(label: Text('Source')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Actions')),
            ],
            rows: List.generate(5, (index) => _buildPatientRow(index)),
          ),
        ],
      ),
    );
  }

  DataRow _buildPatientRow(int index) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(radius: 16.r, backgroundColor: CustomColors.brandCyan.withValues(alpha: 0.2), child: const Icon(Icons.person_rounded, size: 18, color: CustomColors.brandPrimary)),
              SizedBox(width: 12.w),
              Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("Bessie Cooper", style: TextStyle(color: CustomColors.textMain, fontSize: 13.sp, fontWeight: FontWeight.w600)),
                Text("bessie.c@example.com", style: TextStyle(color: CustomColors.textMuted, fontSize: 11.sp)),
              ]),
            ],
          ),
        ),
        const DataCell(Text("Oct 28, 2023")),
        const DataCell(Text("Glow MedSpa NY")),
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(color: CustomColors.brandPrimary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6.r)),
            child: const Text("Mobile App", style: TextStyle(color: CustomColors.brandPrimary, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ),
        DataCell(_statusBadge("Active")),
        DataCell(
          Row(
            children: [
              IconButton(icon: const Icon(Icons.visibility_outlined, size: 18), onPressed: () {}),
              IconButton(icon: const Icon(Icons.more_horiz_rounded, size: 18), onPressed: () {}),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statusBadge(String status) {
    return Row(
      children: [
        Container(width: 6, height: 6, decoration: const BoxDecoration(color: CustomColors.success, shape: BoxShape.circle)),
        SizedBox(width: 8.w),
        Text(status, style: TextStyle(color: CustomColors.textMain, fontSize: 12.sp, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
