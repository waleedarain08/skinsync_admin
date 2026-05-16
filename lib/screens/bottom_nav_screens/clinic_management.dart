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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(clinicViewModelProvider.notifier).initialize();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
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
    return _buildClinicsTable(isActiveOnly: true);
  }

  Widget _buildPendingInvitationsTab() {
    final state = ref.watch(clinicViewModelProvider);
    final pendingClinics = state.inviteClinics ?? [];

    if (state.loading) return const Center(child: CircularProgressIndicator());
    
    if (pendingClinics.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mark_email_read_outlined, size: 64.sp, color: CustomColors.textSecondary.withOpacity(0.2)),
            SizedBox(height: 16.h),
            Text("No clinics to invite", style: CustomFonts.bodyLarge.copyWith(color: CustomColors.textSecondary)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.only(top: 16.h),
      itemCount: pendingClinics.length,
      separatorBuilder: (_, __) => SizedBox(height: 16.h),
      itemBuilder: (context, index) => _buildInvitationCard(pendingClinics[index]),
    );
  }

  Widget _buildInvitationCard(InviteClinicModel clinic) {
    return BorderdContainerWidget(
      padding: EdgeInsets.all(24.w),
      child: Row(
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: CustomColors.backgroundLight,
              borderRadius: BorderRadius.circular(12.r),
              image: (clinic.logo != null && clinic.logo!.isNotEmpty)
                  ? DecorationImage(image: NetworkImage(clinic.logo!), fit: BoxFit.cover)
                  : null,
            ),
            child: (clinic.logo == null || clinic.logo!.isEmpty)
                ? Center(child: Text(clinic.name[0], style: TextStyle(color: CustomColors.deepSlate, fontSize: 32.sp, fontWeight: FontWeight.bold)))
                : null,
          ),
          SizedBox(width: 24.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(clinic.name, style: CustomFonts.headlineSmall),
                    SizedBox(width: 16.w),
                    _invitationStatusBadge(clinic.invitationStatus),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 16.sp, color: CustomColors.textSecondary),
                    SizedBox(width: 4.w),
                    Text(clinic.address, style: CustomFonts.bodySmall),
                    SizedBox(width: 24.w),
                    Icon(Icons.calendar_today_outlined, size: 14.sp, color: CustomColors.textSecondary),
                    SizedBox(width: 4.w),
                    Text("Invited: ${clinic.invitedDate}", style: CustomFonts.bodySmall),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    _contactInfo(Icons.email_outlined, clinic.email),
                    SizedBox(width: 24.w),
                    _contactInfo(Icons.phone_outlined, clinic.phone),
                  ],
                ),
                if (clinic.interestedPatientsCount > 0) ...[
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: CustomColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: CustomColors.warning.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.trending_up_rounded, size: 16, color: CustomColors.warning),
                        SizedBox(width: 8.w),
                        Text(
                          "${clinic.interestedPatientsCount} Potential Patients Awaiting Service",
                          style: CustomFonts.bodySmall.copyWith(color: CustomColors.warning, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 32.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildContextualInviteButton(clinic),
              SizedBox(height: 12.h),
              OutlinedButton(
                onPressed: () {
                  ref.read(clinicViewModelProvider.notifier).selectInviteClinic(clinic);
                  context.push(InviteClinicDetailScreen.routeName);
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  side: const BorderSide(color: CustomColors.borderLight),
                ),
                child: Text("View Details", style: CustomFonts.bodySmall.copyWith(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _contactInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14.sp, color: CustomColors.textSecondary),
        SizedBox(width: 6.w),
        Text(text, style: CustomFonts.bodySmall.copyWith(color: CustomColors.textSecondary)),
      ],
    );
  }

  Widget _buildContextualInviteButton(InviteClinicModel clinic) {
    final status = clinic.invitationStatus.toLowerCase();
    
    if (status == 'invitation sent' || status == 'awaiting response' || status == 'invited') {
      return OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.refresh_rounded, size: 16),
        label: const Text("Resend Invite"),
        style: OutlinedButton.styleFrom(
          foregroundColor: CustomColors.brandCyan,
          side: const BorderSide(color: CustomColors.brandCyan),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        ),
      );
    } else if (status == 'pending onboarding' || status == 'interested') {
      return ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.rocket_launch_outlined, size: 16),
        label: const Text("Start Onboarding"),
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.success,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        ),
      );
    } else {
      return ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.mail_outline_rounded, size: 16),
        label: const Text("Invite Clinic"),
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.brandCyan,
          foregroundColor: CustomColors.deepSlate,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        ),
      );
    }
  }

  Widget _invitationStatusBadge(String status) {
    Color color = CustomColors.textSecondary;
    String cleanStatus = status.toLowerCase();

    if (cleanStatus.contains('sent') || cleanStatus.contains('invited') || cleanStatus.contains('awaiting')) {
      color = CustomColors.brandCyan;
    } else if (cleanStatus.contains('interested') || cleanStatus.contains('pending')) {
      color = CustomColors.success;
    } else if (cleanStatus.contains('expired') || cleanStatus.contains('not')) {
      color = CustomColors.error;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10.sp, fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildClinicsTable({bool isActiveOnly = false}) {
    return BorderdContainerWidget(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Text("Active Clinic Directory", style: CustomFonts.headlineSmall),
          ),
          Expanded(
            child: Consumer(
              builder: (context, ref, _) {
                final state = ref.watch(clinicViewModelProvider);
                if (state.loading) return const Center(child: CircularProgressIndicator());
                
                var clinics = state.clinics ?? [];
                // Original logic for active clinics continues here...
            
                if (clinics.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.w),
                      child: Text("No clinics found", style: CustomFonts.bodyLarge.copyWith(color: CustomColors.textSecondary)),
                    ),
                  );
                }
                
                return Scrollbar(
                  child: SingleChildScrollView(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 40.w,
                        headingRowColor: WidgetStateProperty.all(CustomColors.backgroundLight),
                        headingTextStyle: CustomFonts.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                        rows: List.generate(
                          clinics.length,
                          (index) => _buildDataRow(clinics[index]),
                        ),
                        columns: const [
                          DataColumn(label: Text('Clinic Name')),
                          DataColumn(label: Text('Contact')),
                          DataColumn(label: Text('Location')),
                          DataColumn(label: Text('Plan')),
                          DataColumn(label: Text('Stats')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Actions')),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildDataRow(ClinicModel clinic) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 16.r,
                backgroundColor: CustomColors.brandCyan.withOpacity(0.1),
                child: Text(clinic.name?[0] ?? "C", style: TextStyle(color: CustomColors.deepSlate, fontSize: 12.sp, fontWeight: FontWeight.bold)),
              ),
              SizedBox(width: 12.w),
              Text(clinic.name ?? 'N/A', style: CustomFonts.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        DataCell(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(clinic.email ?? 'N/A', style: CustomFonts.bodyMedium),
              Text(clinic.phone ?? '', style: CustomFonts.bodySmall),
            ],
          ),
        ),
        DataCell(Text(clinic.address ?? 'N/A', style: CustomFonts.bodyMedium)),
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(color: CustomColors.brandPurple.withOpacity(0.1), borderRadius: BorderRadius.circular(6.r)),
            child: Text("Premium", style: CustomFonts.bodySmall.copyWith(color: CustomColors.brandPurple, fontWeight: FontWeight.bold)),
          ),
        ),
        DataCell(
          Row(
            children: [
              _miniIconStat(Icons.people, "${clinic.totalAppointments ?? 0}"),
              _miniIconStat(Icons.star, "${clinic.rating ?? 0}"),
            ],
          ),
        ),
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
}
