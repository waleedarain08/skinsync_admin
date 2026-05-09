import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/view_models/clinic_view_model.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';
import '../../widgets/dailogbox/clinic_dailogbox.dart';

class ClinicManagement extends ConsumerStatefulWidget {
  static const String routeName = '/clinic-management';
  const ClinicManagement({super.key});

  @override
  ConsumerState<ClinicManagement> createState() => _ClinicManagementState();
}

class _ClinicManagementState extends ConsumerState<ClinicManagement> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(clinicViewModelProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
          _buildClinicsTable(),
        ],
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
            Text("Clinic Management", style: CustomFonts.textMain32w700),
            SizedBox(height: 8.h),
            Text(
              "Manage, monitor, and scale your MedSpa network effortlessly.",
              style: CustomFonts.textMain14w400.copyWith(color: CustomColors.textMuted),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const RegisterClinicDialogBox(),
            );
          },
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text('Add New Clinic', style: CustomFonts.white14w500),
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomColors.deepNavy,
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
        _buildMiniStat("Total Clinics", "48", Icons.business, CustomColors.primaryGold),
        SizedBox(width: 16.w),
        _buildMiniStat("Active Now", "42", Icons.bolt, CustomColors.successGreen),
        SizedBox(width: 16.w),
        _buildMiniStat("Subscription Revenue", "\$245K", Icons.payments_outlined, CustomColors.deepNavy),
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
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: color, size: 24.sp),
            ),
            SizedBox(width: 16.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: CustomFonts.black20w600),
                Text(title, style: CustomFonts.grey18w400.copyWith(fontSize: 12.sp)),
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
              backgroundColor: CustomColors.softChampagne.withValues(alpha: 0.5),
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
        border: Border.all(color: CustomColors.greyColor),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Text("$label: ", style: TextStyle(color: CustomColors.textLight, fontSize: 13.sp)),
          Text(items[0], style: TextStyle(color: CustomColors.textDark, fontWeight: FontWeight.w600, fontSize: 13.sp)),
          Icon(Icons.keyboard_arrow_down, size: 18.sp),
        ],
      ),
    );
  }

  Widget _buildClinicsTable() {
    return BorderdContainerWidget(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Text("Clinic Directory", style: CustomFonts.textMain20w600),
          ),
          Consumer(
            builder: (context, ref, _) {
              final state = ref.watch(clinicViewModelProvider);
              if (state.loading) return const Center(child: CircularProgressIndicator());
              
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 40.w,
                  headingRowColor: WidgetStateProperty.all(CustomColors.softChampagne.withValues(alpha: 0.5)),
                  headingTextStyle: CustomFonts.black16w600.copyWith(fontSize: 14.sp),
                  rows: List.generate(
                    state.clinics?.length ?? 0,
                    (index) => _buildDataRow(state.clinics![index]),
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
              );
            },
          ),
        ],
      ),
    );
  }

  DataRow _buildDataRow(dynamic clinic) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 16.r,
                backgroundColor: CustomColors.primaryGold.withValues(alpha: 0.1),
                child: Text(clinic.name?[0] ?? "C", style: TextStyle(color: CustomColors.primaryGold, fontSize: 12.sp, fontWeight: FontWeight.bold)),
              ),
              SizedBox(width: 12.w),
              Text(clinic.name ?? 'N/A', style: CustomFonts.black14w600),
            ],
          ),
        ),
        DataCell(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(clinic.email ?? 'N/A', style: CustomFonts.black14w400),
              Text(clinic.phone ?? '', style: TextStyle(color: CustomColors.textLight, fontSize: 12.sp)),
            ],
          ),
        ),
        DataCell(Text(clinic.address ?? 'N/A', style: CustomFonts.black14w400)),
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(color: CustomColors.primaryGold.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6.r)),
            child: Text("Premium", style: TextStyle(color: CustomColors.primaryGold, fontSize: 11.sp, fontWeight: FontWeight.bold)),
          ),
        ),
        DataCell(
          Row(
            children: [
              _miniIconStat(Icons.people, "120"),
              SizedBox(width: 8.w),
              _miniIconStat(Icons.calendar_month, "450"),
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
                  builder: (context) => const EditClinicDialogBox(),
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
        Icon(icon, size: 14.sp, color: CustomColors.textLight),
        SizedBox(width: 4.w),
        Text(value, style: TextStyle(color: CustomColors.textDark, fontSize: 12.sp)),
      ],
    );
  }

  Widget _statusBadge(String status) {
    final bool isActive = status.toLowerCase() == 'active';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isActive ? CustomColors.successGreen.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: isActive ? CustomColors.successGreen : Colors.red,
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
