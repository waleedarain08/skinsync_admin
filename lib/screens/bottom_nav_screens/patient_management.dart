import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/widgets/app_search_field.dart';
import 'package:skinsync_admin/widgets/custom_outlined_button.dart';
import 'package:skinsync_admin/widgets/app_badge.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';

import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

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
    return GradientScaffold(
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(
          horizontal: 28,
          vertical: 28,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            context.verticalSpace(32),
            _buildQuickMetrics(context),
            context.verticalSpace(32),
            _buildSearchAndFilters(context),
            context.verticalSpace(24),
            _buildPatientsTable(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Client Database", style: context.fonts.black26w700),
        context.verticalSpace(6),
        Text(
          "Unified view of all patients across your clinic network.",
          style: context.fonts.grey13w500,
        ),
      ],
    );
  }

  Widget _buildQuickMetrics(BuildContext context) {
    return Row(
      children: [
        _buildMetricCard(context, "Total Patients", "12,840", Icons.people_rounded, CustomColors.purple),
        context.horizontalSpace(16),
        _buildMetricCard(context, "Verified Profiles", "8,200", Icons.verified_user_rounded, CustomColors.green),
        context.horizontalSpace(16),
        _buildMetricCard(context, "App Users", "9,450", Icons.smartphone_rounded, CustomColors.green),
        context.horizontalSpace(16),
        _buildMetricCard(context, "Active Network", "3,390", Icons.hub_rounded, CustomColors.purple),
      ],
    );
  }

  Widget _buildMetricCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Expanded(
      child: BorderdContainerWidget(
        padding: context.appEdgeInsets(all: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: context.appEdgeInsets(all: 10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: context.borderRadius(all: 8),
              ),
              child: Icon(icon, color: color, size: context.sp(20)),
            ),
            context.verticalSpace(16),
            Text(value, style: context.fonts.black20w600),
            Text(title, style: context.fonts.grey12w400),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters(BuildContext context) {
    return Row(
      children: [
        AppSearchField(
          controller: _searchController,
          hintText: "Search by name, ID, or phone...",
          onChanged: (val) => setState(() {}),
        ),
        context.horizontalSpace(16),
        _filterDropdown(context, "Select Clinic"),
        context.horizontalSpace(12),
        _filterDropdown(context, "Registration Source"),
        const Spacer(),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.tune_rounded, size: 18),
          label: const Text("Advanced Search"),
        ),
      ],
    );
  }

  Widget _filterDropdown(BuildContext context, String label) {
    return Container(
      padding: context.appEdgeInsets(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: CustomColors.border),
        borderRadius: context.borderRadius(all: 8),
      ),
      child: Row(
        children: [
          Text(label, style: context.fonts.black14w600.copyWith(fontSize: context.sp(12), fontWeight: FontWeight.w500)),
          context.horizontalSpace(8),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: CustomColors.lightGrey),
        ],
      ),
    );
  }

  Widget _buildPatientsTable(BuildContext context) {
    return BorderdContainerWidget(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: context.appEdgeInsets(all: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Patient Records", style: context.fonts.black18w600),
                CustomOutlinedButton(
                  onTap: () {},
                  icon: Icons.file_download_outlined,
                  label: "Export Registry",
                ),
              ],
            ),
          ),
          DataTable(
            columnSpacing: context.w(40),
            headingRowColor: WidgetStateProperty.all(CustomColors.whiteGrey),
            columns: const [
              DataColumn(label: Text('PATIENT')),
              DataColumn(label: Text('JOINED DATE')),
              DataColumn(label: Text('HOME CLINIC')),
              DataColumn(label: Text('CHANNEL')),
              DataColumn(label: Text('STATUS')),
              DataColumn(label: Text('ACTIONS')),
            ],
            rows: List.generate(5, (index) => _buildPatientRow(context, index)),
          ),
        ],
      ),
    );
  }

  DataRow _buildPatientRow(BuildContext context, int index) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: context.r(16), 
                backgroundColor: CustomColors.palePurple, 
                child: Icon(Icons.person_rounded, size: context.sp(18), color: CustomColors.purple),
              ),
              context.horizontalSpace(12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center, 
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  Text("Bessie Cooper", style: context.fonts.black14w600),
                  Text("bessie.c@example.com", style: context.fonts.grey12w400),
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
              IconButton(icon: Icon(Icons.visibility_outlined, size: context.sp(20), color: CustomColors.grey), onPressed: () {}),
              IconButton(icon: Icon(Icons.more_horiz_rounded, size: context.sp(20), color: CustomColors.grey), onPressed: () {}),
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
