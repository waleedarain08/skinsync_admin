import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';
import 'package:skinsync_admin/widgets/app_search_field.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/dailogbox/user_management_dailog_box.dart';

import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

class UserManagement extends StatefulWidget {
  static const String routeName = '/user-management';
  const UserManagement({super.key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  int _selectedTab = 0; // 0 for Patients, 1 for Clinics
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
            _buildQuickMetrics(),
            SizedBox(height: 32.h),
            _buildTabSwitcher(),
            SizedBox(height: 24.h),
            _buildUsersTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('User Management', style: context.fonts.black32w700),
        SizedBox(height: 4.h),
        Text(
          'Manage system access, roles, and status for all participants.',
          style: context.fonts.grey14w400,
        ),
      ],
    );
  }

  Widget _buildQuickMetrics() {
    return Row(
      children: [
        _buildMetricCard('Total Users', '15,240', Icons.group_rounded, CustomColors.purple),
        SizedBox(width: 16.w),
        _buildMetricCard('Active Staff', '84', Icons.admin_panel_settings_rounded, CustomColors.green),
        SizedBox(width: 16.w),
        _buildMetricCard('New Signups', '+120', Icons.person_add_rounded, CustomColors.purple),
        SizedBox(width: 16.w),
        _buildMetricCard('Reported', '3', Icons.report_problem_rounded, CustomColors.red),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: BorderdContainerWidget(
        padding: EdgeInsets.all(24.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10.r)),
              child: Icon(icon, color: color, size: 24.sp),
            ),
            SizedBox(width: 16.w),
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

  Widget _buildTabSwitcher() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: CustomColors.whiteGrey,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _tabItem('Patients', 0),
          _tabItem('Clinics', 1),
        ],
      ),
    );
  }

  Widget _tabItem(String label, int index) {
    final bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: isSelected ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))] : null,
        ),
        child: Text(
          label,
          style: isSelected ? context.fonts.black14w600 : context.fonts.grey13w500,
        ),
      ),
    );
  }

  Widget _buildUsersTable() {
    return BorderdContainerWidget(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              children: [
                Text(_selectedTab == 0 ? 'Patient Users' : 'Clinic Admins', style: context.fonts.black20w600),
                const Spacer(),
                AppSearchField(
                  controller: _searchController,
                  hintText: 'Search by name or email...',
                  onChanged: (val) => setState(() {}),
                  maxWidth: 300.w,
                ),
              ],
            ),
          ),
          const UserDataTable(),
        ],
      ),
    );
  }
}

class UserDataTable extends StatelessWidget {
  const UserDataTable({super.key});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingRowColor: WidgetStateProperty.all(CustomColors.whiteGrey),
      headingTextStyle: context.fonts.grey12w700,
      columnSpacing: 40.w,
      columns: const [
        DataColumn(label: Text('User')),
        DataColumn(label: Text('Email')),
        DataColumn(label: Text('Joined Date')),
        DataColumn(label: Text('Status')),
        DataColumn(label: Text('Actions')),
      ],
      rows: List.generate(5, (index) => _buildUserRow(context, index)),
    );
  }

  DataRow _buildUserRow(BuildContext context, int index) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(radius: 16.r, backgroundColor: CustomColors.green.withValues(alpha: 0.2), child: const Icon(Icons.person_rounded, size: 18, color: CustomColors.purple)),
              SizedBox(width: 12.w),
              Text('Courtney Henry', style: context.fonts.black14w600),
            ],
          ),
        ),
        DataCell(Text('courtney.h@example.com', style: context.fonts.black14w400)),
        DataCell(Text('Oct 24, 2023', style: context.fonts.black14w400)),
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(color: CustomColors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20.r)),
            child: Text('Active', style: context.fonts.green10w700),
          ),
        ),
        DataCell(
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const UserManagementDialogBox(),
              );
            },
          ),
        ),
      ],
    );
  }
}
