import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';
import 'package:skinsync_admin/widgets/app_badge.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';

class AppointmentManagement extends StatefulWidget {
  static const String routeName = '/appointment-management';
  const AppointmentManagement({super.key});

  @override
  State<AppointmentManagement> createState() => _AppointmentManagementState();
}

class _AppointmentManagementState extends State<AppointmentManagement> {
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
            _buildAppointmentMetrics(),
            SizedBox(height: AppSpacing.xxl),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildCalendarView()),
                SizedBox(width: AppSpacing.xl),
                Expanded(flex: 1, child: _buildUpcomingAppointments()),
              ],
            ),
            SizedBox(height: AppSpacing.xxl),
            _buildAppointmentTable(),
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
            Text("Booking Schedule", style: CustomFonts.black26w700),
            SizedBox(height: 6.h),
            Text(
              "Centralized booking management and real-time clinic capacity tracking.",
              style: CustomFonts.grey13w500,
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add_task_rounded, color: Colors.white),
          label: const Text('Book Appointment'),
        ),
      ],
    );
  }

  Widget _buildAppointmentMetrics() {
    return Row(
      children: [
        _buildMetricCard("Upcoming", "1,240", Icons.event_available_rounded, CustomColors.secondary),
        SizedBox(width: AppSpacing.md),
        _buildMetricCard("Completed", "8,450", Icons.check_circle_outline_rounded, CustomColors.success),
        SizedBox(width: AppSpacing.md),
        _buildMetricCard("Cancelled", "120", Icons.cancel_outlined, CustomColors.error),
        SizedBox(width: AppSpacing.md),
        _buildMetricCard("No Shows", "45", Icons.person_off_outlined, CustomColors.warning),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
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

  Widget _buildCalendarView() {
    return BorderdContainerWidget(
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Network Calendar", style: CustomFonts.black18w600),
              Row(
                children: [
                  _calendarAction(Icons.chevron_left_rounded),
                  SizedBox(width: AppSpacing.md),
                  Text("October 2023", style: CustomFonts.black14w600),
                  SizedBox(width: AppSpacing.md),
                  _calendarAction(Icons.chevron_right_rounded),
                ],
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xl),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.5,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: 35,
            itemBuilder: (context, index) {
              final day = index - 2;
              final isCurrentMonth = day > 0 && day <= 31;
              final isSelected = day == 15;
              return Container(
                decoration: BoxDecoration(
                  color: isSelected ? CustomColors.primarySoft : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isSelected ? CustomColors.secondary.withValues(alpha: 0.3) : CustomColors.borderLight.withValues(alpha: 0.5),
                  ),
                ),
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isCurrentMonth ? day.toString() : "",
                      style: isSelected ? CustomFonts.black14w700 : (isCurrentMonth ? CustomFonts.black12w400 : CustomFonts.grey12w400),
                    ),
                    if (isCurrentMonth && (day == 15 || day == 20))
                      Container(
                        margin: EdgeInsets.only(top: 4.h),
                        height: 3.h,
                        width: 12.w,
                        decoration: BoxDecoration(
                          color: CustomColors.secondary,
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _calendarAction(IconData icon) {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: CustomColors.borderLight),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(icon, size: 18, color: CustomColors.textSecondary),
    );
  }

  Widget _buildUpcomingAppointments() {
    return BorderdContainerWidget(
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Today's Queue", style: CustomFonts.black18w600),
          SizedBox(height: AppSpacing.xl),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, index) => _appointmentQueueItem(index),
          ),
        ],
      ),
    );
  }

  Widget _appointmentQueueItem(int index) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: CustomColors.backgroundLight,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: CustomColors.borderLight.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: CustomColors.primarySoft,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Text(
                "10:30", 
                style: CustomFonts.secondary11w600,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Bessie Cooper", style: CustomFonts.black14w600),
                Text("HydraFacial • Glow NY", style: CustomFonts.grey12w400),
              ],
            ),
          ),
          Icon(Icons.more_vert_rounded, size: 18, color: CustomColors.textTertiary),
        ],
      ),
    );
  }

  Widget _buildAppointmentTable() {
    return BorderdContainerWidget(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(AppSpacing.xl),
            child: Text("Registry Log", style: CustomFonts.black18w600),
          ),
          DataTable(
            columnSpacing: 40.w,
            headingRowColor: WidgetStateProperty.all(CustomColors.backgroundLight),
            columns: const [
              DataColumn(label: Text('PATIENT')),
              DataColumn(label: Text('CLINIC')),
              DataColumn(label: Text('PROCEDURE')),
              DataColumn(label: Text('SCHEDULED')),
              DataColumn(label: Text('PROVIDER')),
              DataColumn(label: Text('STATUS')),
            ],
            rows: List.generate(5, (index) => _appointmentRow(index)),
          ),
        ],
      ),
    );
  }

  DataRow _appointmentRow(int index) {
    return DataRow(
      cells: [
        DataCell(Text("Eleanor Pena", style: CustomFonts.black13w600)),
        DataCell(Text("Glow MedSpa NY", style: CustomFonts.black14w400)),
        DataCell(Text("Laser Resurfacing", style: CustomFonts.black14w400)),
        DataCell(Text("Oct 28 • 02:00 PM", style: CustomFonts.black14w400)),
        DataCell(Text("Dr. Sarah Jenkins", style: CustomFonts.black14w400)),
        DataCell(_statusBadge("Confirmed")),
      ],
    );
  }

  Widget _statusBadge(String status) {
    return AppBadge(label: status, variant: AppBadgeVariant.success);
  }
}
