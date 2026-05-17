import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/clinic_model.dart';
import 'package:skinsync_admin/models/invite_clinic_model.dart';
import 'package:skinsync_admin/view_models/clinic_view_model.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/screens/add_new_clinic_screen.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';
import '../../widgets/dailogbox/clinic_dailogbox.dart';
import '../invite_clinic_detail_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _activeScrollController = ScrollController();
    _inviteScrollController = ScrollController();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(clinicViewModelProvider.notifier).initialize();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _activeScrollController.dispose();
    _inviteScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundLight,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 32.h),
            _buildStatsSummary(),
            SizedBox(height: 32.h),
            _buildFiltersAndSearch(),
            SizedBox(height: 24.h),
            _buildTabs(),
            SizedBox(height: 24.h),
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
            Text("Clinic Management", style: CustomFonts.headlineLarge),
            SizedBox(height: 8.h),
            Text(
              "Manage, monitor, and scale your MedSpa network effortlessly.",
              style: CustomFonts.bodyMedium.copyWith(color: CustomColors.textSecondary),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {
            context.push(AddNewClinicScreen.routeName);
          },
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text('Add New Clinic', style: CustomFonts.white14w600),
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomColors.deepSlate,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSummary() {
    return Row(
      children: [
        _buildMiniStat("Total Clinics", "48", Icons.business, CustomColors.brandCyan),
        SizedBox(width: 16.w),
        _buildMiniStat("Active Now", "42", Icons.bolt, CustomColors.success),
        SizedBox(width: 16.w),
        _buildMiniStat("Subscription Revenue", "\$245K", Icons.payments_outlined, CustomColors.brandPurple),
        SizedBox(width: 16.w),
        _buildMiniStat("Avg Clinic Rating", "4.8", Icons.star_outline, Colors.amber),
      ],
    );
  }

  Widget _buildMiniStat(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: BorderdContainerWidget(
        padding: EdgeInsets.all(20.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: color, size: 24.sp),
            ),
            SizedBox(width: 16.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: CustomFonts.headlineSmall),
                Text(title, style: CustomFonts.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersAndSearch() {
    return BorderdContainerWidget(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: CupertinoSearchTextField(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              placeholder: "Search clinics by name, email or location...",
              backgroundColor: CustomColors.backgroundLight,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          SizedBox(width: 16.w),
          _buildFilterDropdown("Region", ["All Regions", "East Coast", "West Coast"]),
          SizedBox(width: 12.w),
          _buildFilterDropdown("Status", ["All Status", "Active", "Inactive"]),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(String label, List<String> items) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border.all(color: CustomColors.borderLight),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Text("$label: ", style: CustomFonts.bodySmall),
          Text(items[0], style: CustomFonts.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
          const Icon(Icons.keyboard_arrow_down, size: 18),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: CustomColors.borderLight)),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: CustomColors.deepSlate,
        unselectedLabelColor: CustomColors.textSecondary,
        indicatorColor: CustomColors.brandCyan,
        indicatorWeight: 3,
        labelStyle: CustomFonts.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        tabs: const [
          Tab(text: "Active Clinics"),
          Tab(text: "Clinics to Invite"),
        ],
      ),
    );
  }

  Widget _buildActiveClinicsTab() {
    final state = ref.watch(clinicViewModelProvider);
    final clinics = state.clinics ?? [];
    return _buildUnifiedTable<ClinicModel>(
      title: "Active Clinic Directory",
      items: clinics,
      isLoading: state.loading,
      controller: _activeScrollController,
      columns: const [
        DataColumn(label: Text('Clinic Name')),
        DataColumn(label: Text('Contact')),
        DataColumn(label: Text('Location')),
        DataColumn(label: Text('Plan/Type')),
        DataColumn(label: Text('Stats')),
        DataColumn(label: Text('Status')),
        DataColumn(label: Text('Actions')),
      ],
      rowBuilder: (item) => _buildActiveClinicRow(item),
    );
  }

  Widget _buildPendingInvitationsTab() {
    final state = ref.watch(clinicViewModelProvider);
    final inviteClinics = state.inviteClinics ?? [];
    return _buildUnifiedTable<InviteClinicModel>(
      title: "Prospect Clinic Pipeline",
      items: inviteClinics,
      isLoading: state.loading,
      controller: _inviteScrollController,
      columns: const [
        DataColumn(label: Text('Clinic Name')),
        DataColumn(label: Text('Contact')),
        DataColumn(label: Text('Location')),
        DataColumn(label: Text('Plan/Type')),
        DataColumn(label: Text('Status')),
        DataColumn(label: Text('Actions')),
      ],
      rowBuilder: (item) => _buildInviteClinicRow(item),
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
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Text(title, style: CustomFonts.headlineSmall),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : items.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(40.w),
                          child: Text("No data found", style: CustomFonts.bodyLarge.copyWith(color: CustomColors.textSecondary)),
                        ),
                      )
                    : Scrollbar(
                        controller: controller,
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          controller: controller,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columnSpacing: 40.w,
                              headingRowColor: WidgetStateProperty.all(CustomColors.backgroundLight),
                              headingTextStyle: CustomFonts.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                              rows: List.generate(
                                items.length,
                                (index) => rowBuilder(items[index]),
                              ),
                              columns: columns,
                            ),
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
        DataCell(Text(clinic.address ?? 'N/A', style: CustomFonts.bodyMedium)),
        DataCell(_buildPlanBadge(clinic.subscriptionPlan ?? "Standard")),
        DataCell(_buildStatsCell(clinic.totalAppointments?.toString() ?? "0", Icons.people, clinic.rating?.toString() ?? "0", Icons.star)),
        DataCell(_statusBadge(clinic.status ?? 'Active')),
        DataCell(
          Row(
            children: [
              IconButton(icon: const Icon(Icons.visibility_outlined, size: 20), onPressed: () {}),
              IconButton(icon: const Icon(Icons.edit_outlined, size: 20), onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => EditClinicDialogBox(clinic: clinic),
                );
              }),
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
        DataCell(Text(clinic.address, style: CustomFonts.bodyMedium)),
        DataCell(_buildPlanBadge("Pipeline", isPipeline: true)),
        DataCell(_invitationStatusBadge(clinic.invitationStatus)),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.visibility_outlined, size: 20),
                onPressed: () {
                  ref.read(clinicViewModelProvider.notifier).selectInviteClinic(clinic);
                  context.push(InviteClinicDetailScreen.routeName);
                },
              ),
              _buildContextualIconButton(clinic),
            ],
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
          backgroundColor: CustomColors.brandCyan.withOpacity(0.1),
          backgroundImage: (logo != null && logo.isNotEmpty) ? NetworkImage(logo) : null,
          child: (logo == null || logo.isEmpty)
              ? Text(name?[0] ?? "C", style: TextStyle(color: CustomColors.deepSlate, fontSize: 12.sp, fontWeight: FontWeight.bold))
              : null,
        ),
        SizedBox(width: 12.w),
        Text(name ?? 'N/A', style: CustomFonts.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildContactCell(String? email, String? phone) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(email ?? 'N/A', style: CustomFonts.bodyMedium),
        Text(phone ?? '', style: CustomFonts.bodySmall),
      ],
    );
  }

  Widget _buildPlanBadge(String plan, {bool isPipeline = false}) {
    final color = CustomColors.brandPurple;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6.r)),
      child: Text(plan, style: CustomFonts.bodySmall.copyWith(color: color, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildStatsCell(String val1, IconData icon1, String val2, IconData icon2) {
    return Row(
      children: [
        _miniIconStat(icon1, val1),
        SizedBox(width: 8.w),
        _miniIconStat(icon2, val2),
      ],
    );
  }

  Widget _miniIconStat(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: CustomColors.textSecondary),
        SizedBox(width: 4.w),
        Text(value, style: CustomFonts.bodySmall),
      ],
    );
  }

  Widget _statusBadge(String status) {
    final bool isActive = status.toLowerCase() == 'active';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isActive ? CustomColors.success.withOpacity(0.1) : CustomColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: isActive ? CustomColors.success : CustomColors.error,
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _invitationStatusBadge(String status) {
    Color color = CustomColors.textSecondary;
    String cleanStatus = status.toLowerCase();
    if (cleanStatus.contains('sent') || cleanStatus.contains('invited') || cleanStatus.contains('awaiting')) {
      color = CustomColors.brandCyan;
    } else if (cleanStatus.contains('interested') || cleanStatus.contains('pending')) {
      color = CustomColors.success;
    } else if (cleanStatus.contains('expired')) {
      color = CustomColors.error;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildContextualIconButton(InviteClinicModel clinic) {
    final status = clinic.invitationStatus.toLowerCase();
    if (status == 'invitation sent' || status == 'awaiting response' || status == 'invited') {
      return IconButton(icon: const Icon(Icons.refresh_rounded, size: 20, color: CustomColors.brandCyan), onPressed: () {});
    } else if (status == 'pending onboarding' || status == 'interested') {
      return IconButton(icon: const Icon(Icons.rocket_launch_outlined, size: 20, color: CustomColors.success), onPressed: () {});
    } else {
      return IconButton(icon: const Icon(Icons.mail_outline_rounded, size: 20, color: CustomColors.brandCyan), onPressed: () {});
    }
  }
}
