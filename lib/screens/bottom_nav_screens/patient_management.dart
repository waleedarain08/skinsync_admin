import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/widgets/app_badge.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';

class PatientManagement extends StatefulWidget {
  static const String routeName = '/patient-management';
  const PatientManagement({super.key});

  @override
  State<PatientManagement> createState() => _PatientManagementState();
}

class _PatientManagementState extends State<PatientManagement> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundLight,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.pagePaddingH,
          vertical: AppSpacing.pagePaddingV,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: AppSpacing.xxl),
            _buildQuickMetrics(),
            SizedBox(height: AppSpacing.xxl),
            _buildSearchAndFilters(),
            SizedBox(height: AppSpacing.xl),
            _buildPatientsTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Client Database", style: CustomFonts.black26w700),
        SizedBox(height: 6.h),
        Text(
          "Unified view of all patients across your clinic network.",
          style: CustomFonts.grey13w500,
        ),
      ],
    );
  }

  Widget _buildQuickMetrics() {
    return Row(
      children: [
        _buildMetricCard("Total Patients", "12,840", Icons.people_rounded, CustomColors.primary),
        SizedBox(width: AppSpacing.md),
        _buildMetricCard("Verified Profiles", "8,200", Icons.verified_user_rounded, CustomColors.success),
        SizedBox(width: AppSpacing.md),
        _buildMetricCard("App Users", "9,450", Icons.smartphone_rounded, CustomColors.secondary),
        SizedBox(width: AppSpacing.md),
        _buildMetricCard("Active Network", "3,390", Icons.hub_rounded, CustomColors.brandPurple),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: BorderdContainerWidget(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(icon, color: color, size: 20.sp),
            ),
            SizedBox(height: AppSpacing.md),
            Text(value, style: CustomFonts.black20w600),
            Text(title, style: CustomFonts.grey12w400),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            height: 52.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: CustomColors.borderLight),
              boxShadow: AppShadows.xs,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() {}),
              style: CustomFonts.grey14w400,
              decoration: InputDecoration(
                hintText: "Search by name, ID, or phone...",
                hintStyle: CustomFonts.grey13w500,
                prefixIcon: const Icon(Icons.search_rounded, color: CustomColors.textTertiary, size: 20),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                suffixIcon: _searchController.text.isNotEmpty 
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
              ),
            ),
          ),
        ),
        SizedBox(width: AppSpacing.md),
        _filterDropdown("Select Clinic"),
        SizedBox(width: AppSpacing.sm),
        _filterDropdown("Registration Source"),
        const Spacer(),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.tune_rounded, size: 18),
          label: const Text("Advanced Search"),
        ),
      ],
    );
  }

  Widget _filterDropdown(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: CustomColors.borderLight),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Text(label, style: CustomFonts.black14w600.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500)),
          SizedBox(width: 8.w),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: CustomColors.textTertiary),
        ],
      ),
    );
  }

  Widget _buildPatientsTable() {
    return BorderdContainerWidget(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(AppSpacing.xl),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Patient Records", style: CustomFonts.black18w600),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.file_download_outlined, size: 18),
                  label: const Text("Export Registry"),
                ),
              ],
            ),
          ),
          DataTable(
            columnSpacing: 40.w,
            headingRowColor: WidgetStateProperty.all(CustomColors.backgroundLight),
            columns: const [
              DataColumn(label: Text('PATIENT')),
              DataColumn(label: Text('JOINED DATE')),
              DataColumn(label: Text('HOME CLINIC')),
              DataColumn(label: Text('CHANNEL')),
              DataColumn(label: Text('STATUS')),
              DataColumn(label: Text('ACTIONS')),
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
              CircleAvatar(
                radius: 16.r, 
                backgroundColor: CustomColors.primarySoft, 
                child: Icon(Icons.person_rounded, size: 18.sp, color: CustomColors.primary),
              ),
              SizedBox(width: AppSpacing.sm),
              Column(
                mainAxisAlignment: MainAxisAlignment.center, 
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  Text("Bessie Cooper", style: CustomFonts.black14w600),
                  Text("bessie.c@example.com", style: CustomFonts.grey12w400),
                ],
              ),
            ],
          ),
        ),
        const DataCell(Text("Oct 28, 2023")),
        const DataCell(Text("Glow MedSpa NY")),
        DataCell(
          AppBadge(label: "Mobile App", variant: AppBadgeVariant.brand),
        ),
        DataCell(_statusBadge("Active")),
        DataCell(
          Row(
            children: [
              IconButton(icon: Icon(Icons.visibility_outlined, size: 20.sp, color: CustomColors.textSecondary), onPressed: () {}),
              IconButton(icon: Icon(Icons.more_horiz_rounded, size: 20.sp, color: CustomColors.textSecondary), onPressed: () {}),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statusBadge(String status) {
    return AppBadge(label: status, variant: AppBadgeVariant.success);
  }
}
