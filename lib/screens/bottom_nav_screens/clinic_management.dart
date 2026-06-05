import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/clinic_model.dart';
import 'package:skinsync_admin/models/invite_clinic_model.dart';
import 'package:skinsync_admin/view_models/clinic_view_model.dart';
import 'package:skinsync_admin/widgets/custom_dropdown_widget.dart';
import 'package:skinsync_admin/widgets/app_search_field.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/custom_outlined_button.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/screens/add_new_clinic_screen.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/screens/clinic_detail_screen.dart';
import 'package:skinsync_admin/widgets/app_badge.dart';
import '../../widgets/dailogbox/clinic_dailogbox.dart';
import '../../widgets/dailogbox/standard_dialog.dart';
import '../invite_clinic_detail_screen.dart';

import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

class ClinicManagement extends ConsumerStatefulWidget {
  static const String routeName = '/clinic-management';
  const ClinicManagement({super.key});

  @override
  ConsumerState<ClinicManagement> createState() => _ClinicManagementState();
}

class _ClinicManagementState extends ConsumerState<ClinicManagement> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _activeScrollController;
  late ScrollController _inviteScrollController;
  late TextEditingController _activeSearchController;
  late TextEditingController _inviteSearchController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _activeScrollController = ScrollController();
    _inviteScrollController = ScrollController();
    _activeSearchController = TextEditingController();
    _inviteSearchController = TextEditingController();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(clinicViewModelProvider.notifier).initialize();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _activeScrollController.dispose();
    _inviteScrollController.dispose();
    _activeSearchController.dispose();
    _inviteSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Padding(
        padding: context.appEdgeInsets(
          horizontal: 28,
          vertical: 28,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            context.verticalSpace(32),
            _buildStatsSummary(context),
            context.verticalSpace(32),
            _buildTabs(),
            context.verticalSpace(24),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildActiveClinicsTab(context),
                  _buildPendingInvitationsTab(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Clinic Partners", style: context.fonts.black26w700),
            context.verticalSpace(6),
            Text(
              "Manage and monitor your MedSpa network performance.",
              style: context.fonts.grey13w500,
            ),
          ],
        ),
        CustomPrimaryButton(
          onTap: () => context.push(AddNewClinicScreen.routeName),
          icon: Icons.add_rounded,
          label: 'Add New Clinic',
          width: context.w(200),
        ),
      ],
    );
  }

  Widget _buildStatsSummary(BuildContext context) {
    return Row(
      children: [
        _buildMiniStat(context, "Total Clinics", "48", Icons.business_rounded, CustomColors.purple),
        context.horizontalSpace(16),
        _buildMiniStat(context, "Active Partners", "42", Icons.bolt_rounded, CustomColors.green),
        context.horizontalSpace(16),
        _buildMiniStat(context, "Network Revenue", "\$245K", Icons.payments_rounded, CustomColors.green),
        context.horizontalSpace(16),
        _buildMiniStat(context, "Avg Patient Rating", "4.8", Icons.star_rounded, Colors.amber),
      ],
    );
  }

  Widget _buildMiniStat(BuildContext context, String title, String value, IconData icon, Color color) {
    return Expanded(
      child: BorderdContainerWidget(
        padding: context.appEdgeInsets(all: 20),
        child: Row(
          children: [
            Container(
              padding: context.appEdgeInsets(all: 12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: context.appBorderRadius(all: 8),
              ),
              child: Icon(icon, color: color, size: context.sp(22)),
            ),
            context.horizontalSpace(16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: context.fonts.black18w600),
                Text(title, style: context.fonts.grey12w400),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: CustomColors.border)),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabs: const [
          Tab(text: "Active Clinics"),
          Tab(text: "Pending Invitations"),
        ],
      ),
    );
  }

  Widget _buildActiveClinicsTab(BuildContext context) {
    final state = ref.watch(clinicViewModelProvider);
    final clinics = state.clinics ?? [];
    return Column(
      children: [
        _buildSearchAndFilterBar(context, _activeSearchController, "Search by name, email or location..."),
        context.verticalSpace(16),
        Expanded(
          child: _buildUnifiedTable<ClinicModel>(
            context,
            title: "Partner Directory",
            items: clinics,
            isLoading: state.loading,
            controller: _activeScrollController,
            columns: const [
              DataColumn(label: Text('CLINIC')),
              DataColumn(label: Text('CONTACT')),
              DataColumn(label: Text('LOCATION')),
              DataColumn(label: Text('PACKAGE')),
              DataColumn(label: Text('STATS')),
              DataColumn(label: Text('STATUS')),
              DataColumn(label: Text('ACTIONS')),
            ],
            rowBuilder: (item) => _buildActiveClinicRow(context, item),
          ),
        ),
      ],
    );
  }

  Widget _buildPendingInvitationsTab(BuildContext context) {
    final state = ref.watch(clinicViewModelProvider);
    final inviteClinics = state.inviteClinics ?? [];
    return Column(
      children: [
        _buildSearchAndFilterBar(context, _inviteSearchController, "Search prospect clinics..."),
        context.verticalSpace(16),
        Expanded(
          child: _buildUnifiedTable<InviteClinicModel>(
            context,
            title: "Prospect Pipeline",
            items: inviteClinics,
            isLoading: state.loading,
            controller: _inviteScrollController,
            columns: const [
              DataColumn(label: Text('PROSPECT')),
              DataColumn(label: Text('CONTACT')),
              DataColumn(label: Text('LOCATION')),
              DataColumn(label: Text('STATUS')),
              DataColumn(label: Text('ACTIONS')),
            ],
            rowBuilder: (item) => _buildInviteClinicRow(context, item),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilterBar(BuildContext context, TextEditingController controller, String hint) {
    return Row(
      children: [
        AppSearchField(
          controller: controller,
          hintText: hint,
          onChanged: (val) => setState(() {}),
        ),
        context.horizontalSpace(16),
        CustomOutlinedButton(
          onTap: () => _showFiltersModal(context),
          icon: Icons.filter_list_rounded,
          label: "Filters",
          color: Colors.white,
          textColor: CustomColors.purple,
          height: context.h(52),
        ),
      ],
    );
  }

  void _showFiltersModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StandardDialog(
        title: "Filter Clinics",
        width: context.w(600),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomDropdown<String>(
                    label: "Region",
                    hintText: "All Regions",
                    items: const ["East Coast", "West Coast", "Midwest", "South"]
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (val) {},
                  ),
                ),
                context.horizontalSpace(16),
                Expanded(
                  child: CustomDropdown<String>(
                    label: "Status",
                    hintText: "All Status",
                    items: const ["Active", "Inactive", "Pending"]
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (val) {},
                  ),
                ),
              ],
            ),
            context.verticalSpace(24),
            CustomDropdown<String>(
              label: "Subscription Plan",
              hintText: "All Plans",
              items: const ["Basic", "Standard", "Premium", "Enterprise"]
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (val) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Reset All"),
          ),
          CustomPrimaryButton(
            onTap: () => Navigator.pop(context),
            label: "Apply Filters",
            width: context.w(140),
          ),
        ],
      ),
    );
  }

  Widget _buildUnifiedTable<T>(
    BuildContext context, {
    required String title,
    required List<T> items,
    required bool isLoading,
    required ScrollController controller,
    required List<DataColumn> columns,
    required DataRow Function(T) rowBuilder,
  }) {
    return BorderdContainerWidget(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: context.appEdgeInsets(left: 24, top: 24, right: 24, bottom: 16),
            child: Text(title, style: context.fonts.black18w600),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : items.isEmpty
                    ? Center(
                        child: Padding(
                          padding: context.appEdgeInsets(all: 32),
                          child: Text("No entries found", style: context.fonts.grey13w500),
                        ),
                      )
                    : Scrollbar(
                        controller: controller,
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          controller: controller,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                                  child: DataTable(
                                    headingRowColor: WidgetStateProperty.all(CustomColors.whiteGrey),
                                    rows: List.generate(
                                      items.length,
                                      (index) => rowBuilder(items[index]),
                                    ),
                                    columns: columns,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  DataRow _buildActiveClinicRow(BuildContext context, ClinicModel clinic) {
    return DataRow(
      cells: [
        DataCell(_buildNameCell(context, clinic.name, clinic.logo)),
        DataCell(_buildContactCell(context, clinic.email, clinic.phone)),
        DataCell(Text(clinic.address ?? 'N/A', style: context.fonts.grey13w500)),
        DataCell(_buildPlanBadge(clinic.subscriptionPlan ?? "Standard")),
        DataCell(_buildStatsCell(context, clinic.totalAppointments?.toString() ?? "0", Icons.people_outline_rounded, clinic.rating?.toString() ?? "0", Icons.star_outline_rounded)),
        DataCell(_statusBadge(clinic.status ?? 'Active')),
        DataCell(
          Row(
            children: [
              IconButton(
                tooltip: 'View Details',
                icon: Icon(Icons.visibility_outlined, size: context.sp(20), color: CustomColors.grey),
                onPressed: () {
                  ref.read(clinicViewModelProvider.notifier).selectClinic(clinic);
                  context.push(ClinicDetailScreen.routeName);
                },
              ),
              IconButton(
                tooltip: 'Edit Partner',
                icon: Icon(Icons.edit_outlined, size: context.sp(20), color: CustomColors.grey),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => EditClinicDialogBox(clinic: clinic),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  DataRow _buildInviteClinicRow(BuildContext context, InviteClinicModel clinic) {
    return DataRow(
      cells: [
        DataCell(_buildNameCell(context, clinic.name, clinic.logo)),
        DataCell(_buildContactCell(context, clinic.email, clinic.phone)),
        DataCell(Text(clinic.address, style: context.fonts.grey13w500)),
        DataCell(_invitationStatusBadge(clinic.invitationStatus)),
        DataCell(
          IconButton(
            tooltip: 'View Prospect',
            icon: Icon(Icons.visibility_outlined, size: context.sp(20), color: CustomColors.grey),
            onPressed: () {
              ref.read(clinicViewModelProvider.notifier).selectInviteClinic(clinic);
              context.push(InviteClinicDetailScreen.routeName);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNameCell(BuildContext context, String? name, String? logo) {
    return Row(
      children: [
        CircleAvatar(
          radius: context.r(16),
          backgroundColor: CustomColors.palePurple,
          backgroundImage: (logo != null && logo.isNotEmpty) ? NetworkImage(logo) : null,
          child: (logo == null || logo.isEmpty)
              ? Text(name?[0] ?? "C", style: context.fonts.purple12w700)
              : null,
        ),
        context.horizontalSpace(12),
        Text(name ?? 'N/A', style: context.fonts.black14w600),
      ],
    );
  }

  Widget _buildContactCell(BuildContext context, String? email, String? phone) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(email ?? 'N/A', style: context.fonts.grey13w500),
        Text(phone ?? '', style: context.fonts.grey12w400),
      ],
    );
  }

  Widget _buildPlanBadge(String plan) {
    return AppBadge(label: plan, variant: AppBadgeVariant.secondary);
  }

  Widget _buildStatsCell(BuildContext context, String val1, IconData icon1, String val2, IconData icon2) {
    return Row(
      children: [
        _miniIconStat(context, icon1, val1),
        context.horizontalSpace(12),
        _miniIconStat(context, icon2, val2),
      ],
    );
  }

  Widget _miniIconStat(BuildContext context, IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: context.sp(14), color: CustomColors.lightGrey),
        context.horizontalSpace(4),
        Text(value, style: context.fonts.grey12w400),
      ],
    );
  }

  Widget _statusBadge(String status) {
    final bool isActive = status.toLowerCase() == 'active';
    return AppBadge(
      label: status,
      variant: isActive ? AppBadgeVariant.success : AppBadgeVariant.error,
    );
  }

  Widget _invitationStatusBadge(String status) {
    AppBadgeVariant variant = AppBadgeVariant.info;
    String cleanStatus = status.toLowerCase();
    
    if (cleanStatus.contains('sent') || cleanStatus.contains('invited') || cleanStatus.contains('awaiting')) {
      variant = AppBadgeVariant.info;
    } else if (cleanStatus.contains('interested') || cleanStatus.contains('pending')) {
      variant = AppBadgeVariant.success;
    } else if (cleanStatus.contains('expired')) {
      variant = AppBadgeVariant.error;
    }

    return AppBadge(label: status, variant: variant);
  }
}
