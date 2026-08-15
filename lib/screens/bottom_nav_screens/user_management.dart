import 'package:flutter/material.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/widgets/app_search_field.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/dailogbox/user_management_dailog_box.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';
import 'package:skinsync_admin/widgets/mini_stat_card.dart';

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
        padding: context.appEdgeInsets(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            context.verticalSpace(32),
            _buildQuickMetrics(),
            context.verticalSpace(32),
            _buildTabSwitcher(),
            context.verticalSpace(24),
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
        context.verticalSpace(4),
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
        const MiniStatCard(
          title: 'Total Users',
          value: 15240,
          icon: Icons.group_rounded,
          color: CustomColors.purple,
        ),
        context.horizontalSpace(16),
        const MiniStatCard(
          title: 'Active Staff',
          value: 84,
          icon: Icons.admin_panel_settings_rounded,
          color: CustomColors.green,
        ),
        context.horizontalSpace(16),
        const MiniStatCard(
          title: 'New Signups',
          value: 120,
          prefix: '+',
          icon: Icons.person_add_rounded,
          color: CustomColors.purple,
        ),
        context.horizontalSpace(16),
        const MiniStatCard(
          title: 'Reported',
          value: 3,
          icon: Icons.report_problem_rounded,
          color: CustomColors.red,
        ),
      ],
    );
  }

  Widget _buildTabSwitcher() {
    return Container(
      padding: context.appEdgeInsets(all: 4),
      decoration: BoxDecoration(
        color: CustomColors.whiteGrey,
        borderRadius: BorderRadius.circular(12),
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
        padding: context.appEdgeInsets(horizontal: 40, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
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
            padding: context.appEdgeInsets(all: 20),
            child: Row(
              children: [
                Text(_selectedTab == 0 ? 'Patient Users' : 'Clinic Admins', style: context.fonts.black20w600),
                const Spacer(),
                AppSearchField(
                  controller: _searchController,
                  hintText: 'Search by name or email...',
                  onChanged: (val) => setState(() {}),
                  maxWidth: context.w(300),
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
      columnSpacing: context.w(40),
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
              CircleAvatar(radius: context.r(16), backgroundColor: CustomColors.green.withValues(alpha: 0.2), child: Icon(Icons.person_rounded, size: context.sp(18), color: CustomColors.purple)),
              context.horizontalSpace(12),
              Text('Courtney Henry', style: context.fonts.black14w600),
            ],
          ),
        ),
        DataCell(Text('courtney.h@example.com', style: context.fonts.black14w400)),
        DataCell(Text('Oct 24, 2023', style: context.fonts.black14w400)),
        DataCell(
          Container(
            padding: context.appEdgeInsets(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: CustomColors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
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
