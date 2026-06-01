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
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.pagePaddingH,
          vertical: AppSpacing.pagePaddingV,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: AppSpacing.xxl),
            _buildStatsSummary(),
            SizedBox(height: AppSpacing.xxl),
            _buildTabs(),
            SizedBox(height: AppSpacing.xl),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildActiveClinicsTab(),
                  _buildPendingInvitationsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Clinic Partners", style: CustomFonts.black26w700),
            SizedBox(height: 6.h),
            Text(
              "Manage and monitor your MedSpa network performance.",
              style: CustomFonts.grey13w500,
            ),
          ],
        ),
        CustomPrimaryButton(
          onTap: () => context.push(AddNewClinicScreen.routeName),
          icon: Icons.add_rounded,
          label: 'Add New Clinic',
          width: 200.w,
        ),
      ],
    );
  }

  Widget _buildStatsSummary() {
    return Row(
      children: [
        _buildMiniStat("Total Clinics", "48", Icons.business_rounded, CustomColors.purple),
        SizedBox(width: AppSpacing.md),
        _buildMiniStat("Active Partners", "42", Icons.bolt_rounded, CustomColors.green),
        SizedBox(width: AppSpacing.md),
        _buildMiniStat("Network Revenue", "\$245K", Icons.payments_rounded, CustomColors.green),
        SizedBox(width: AppSpacing.md),
        _buildMiniStat("Avg Patient Rating", "4.8", Icons.star_rounded, Colors.amber),
      ],
    );
  }

  Widget _buildMiniStat(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: BorderdContainerWidget(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(icon, color: color, size: 22.sp),
            ),
            SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: CustomFonts.black18w600),
                Text(title, style: CustomFonts.grey12w400),
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

  Widget _buildActiveClinicsTab() {
    final state = ref.watch(clinicViewModelProvider);
    final clinics = state.clinics ?? [];
    return Column(
      children: [
        _buildSearchAndFilterBar(_activeSearchController, "Search by name, email or location..."),
        SizedBox(height: AppSpacing.md),
        Expanded(
          child: _buildUnifiedTable<ClinicModel>(
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
            rowBuilder: (item) => _buildActiveClinicRow(item),
          ),
        ),
      ],
    );
  }

  Widget _buildPendingInvitationsTab() {
    final state = ref.watch(clinicViewModelProvider);
    final inviteClinics = state.inviteClinics ?? [];
    return Column(
      children: [
        _buildSearchAndFilterBar(_inviteSearchController, "Search prospect clinics..."),
        SizedBox(height: AppSpacing.md),
        Expanded(
          child: _buildUnifiedTable<InviteClinicModel>(
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
            rowBuilder: (item) => _buildInviteClinicRow(item),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilterBar(TextEditingController controller, String hint) {
    return Row(
      children: [
        AppSearchField(
          controller: controller,
          hintText: hint,
          onChanged: (val) => setState(() {}),
        ),
        SizedBox(width: AppSpacing.md),
        OutlinedButton.icon(
          onPressed: () => _showFiltersModal(),
          icon: const Icon(Icons.filter_list_rounded, size: 20),
          label: const Text("Filters"),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            minimumSize: Size(0, 52.h),
          ),
        ),
      ],
    );
  }

  void _showFiltersModal() {
    showDialog(
      context: context,
      builder: (context) => StandardDialog(
        title: "Filter Clinics",
        width: 600.w,
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
                SizedBox(width: AppSpacing.md),
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
            SizedBox(height: AppSpacing.xl),
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
            width: 140.w,
          ),
        ],
      ),
    );
  }

  Widget _buildUnifiedTable<T>({
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
            padding: EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, AppSpacing.md),
            child: Text(title, style: CustomFonts.black18w600),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : items.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppSpacing.xxl),
                          child: Text("No entries found", style: CustomFonts.grey13w500),
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

  DataRow _buildActiveClinicRow(ClinicModel clinic) {
    return DataRow(
      cells: [
        DataCell(_buildNameCell(clinic.name, clinic.logo)),
        DataCell(_buildContactCell(clinic.email, clinic.phone)),
        DataCell(Text(clinic.address ?? 'N/A', style: CustomFonts.grey13w500)),
        DataCell(_buildPlanBadge(clinic.subscriptionPlan ?? "Standard")),
        DataCell(_buildStatsCell(clinic.totalAppointments?.toString() ?? "0", Icons.people_outline_rounded, clinic.rating?.toString() ?? "0", Icons.star_outline_rounded)),
        DataCell(_statusBadge(clinic.status ?? 'Active')),
        DataCell(
          Row(
            children: [
              IconButton(
                tooltip: 'View Details',
                icon: Icon(Icons.visibility_outlined, size: 20.sp, color: CustomColors.grey),
                onPressed: () {
                  ref.read(clinicViewModelProvider.notifier).selectClinic(clinic);
                  context.push(ClinicDetailScreen.routeName);
                },
              ),
              IconButton(
                tooltip: 'Edit Partner',
                icon: Icon(Icons.edit_outlined, size: 20.sp, color: CustomColors.grey),
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

  DataRow _buildInviteClinicRow(InviteClinicModel clinic) {
    return DataRow(
      cells: [
        DataCell(_buildNameCell(clinic.name, clinic.logo)),
        DataCell(_buildContactCell(clinic.email, clinic.phone)),
        DataCell(Text(clinic.address, style: CustomFonts.grey13w500)),
        DataCell(_invitationStatusBadge(clinic.invitationStatus)),
        DataCell(
          IconButton(
            tooltip: 'View Prospect',
            icon: Icon(Icons.visibility_outlined, size: 20.sp, color: CustomColors.grey),
            onPressed: () {
              ref.read(clinicViewModelProvider.notifier).selectInviteClinic(clinic);
              context.push(InviteClinicDetailScreen.routeName);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNameCell(String? name, String? logo) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16.r,
          backgroundColor: CustomColors.palePurple,
          backgroundImage: (logo != null && logo.isNotEmpty) ? NetworkImage(logo) : null,
          child: (logo == null || logo.isEmpty)
              ? Text(name?[0] ?? "C", style: CustomFonts.purple12w700)
              : null,
        ),
        SizedBox(width: AppSpacing.sm),
        Text(name ?? 'N/A', style: CustomFonts.black14w600),
      ],
    );
  }

  Widget _buildContactCell(String? email, String? phone) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(email ?? 'N/A', style: CustomFonts.grey13w500),
        Text(phone ?? '', style: CustomFonts.grey12w400),
      ],
    );
  }

  Widget _buildPlanBadge(String plan) {
    return AppBadge(label: plan, variant: AppBadgeVariant.secondary);
  }

  Widget _buildStatsCell(String val1, IconData icon1, String val2, IconData icon2) {
    return Row(
      children: [
        _miniIconStat(icon1, val1),
        SizedBox(width: AppSpacing.sm),
        _miniIconStat(icon2, val2),
      ],
    );
  }

  Widget _miniIconStat(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: CustomColors.lightGrey),
        SizedBox(width: 4.w),
        Text(value, style: CustomFonts.grey12w400),
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
