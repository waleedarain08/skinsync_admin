import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';
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
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 32.h),
            _buildAppointmentMetrics(),
            SizedBox(height: 32.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildCalendarView()),
                SizedBox(width: 24.w),
                Expanded(flex: 1, child: _buildUpcomingAppointments()),
              ],
            ),
            SizedBox(height: 32.h),
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
            Text("Appointment Scheduler", style: CustomFonts.textMain32w700),
            SizedBox(height: 8.h),
            Text(
              "Centralized booking management and real-time clinic capacity tracking.",
              style: CustomFonts.textMain14w400.copyWith(color: CustomColors.textMuted),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add_task, color: Colors.white),
          label: Text('Book Appointment', style: CustomFonts.white14w500),
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomColors.deepNavy,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentMetrics() {
    return Row(
      children: [
        _buildMetricCard("Upcoming", "1,240", Icons.event_available, CustomColors.blueColor),
        SizedBox(width: 16.w),
        _buildMetricCard("Completed", "8,450", Icons.check_circle_outline, CustomColors.successGreen),
        SizedBox(width: 16.w),
        _buildMetricCard("Cancelled", "120", Icons.cancel_outlined, CustomColors.errorRed),
        SizedBox(width: 16.w),
        _buildMetricCard("No Shows", "45", Icons.person_off_outlined, CustomColors.warningOrange),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: BorderdContainerWidget(
        padding: EdgeInsets.all(20.w),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28.sp),
            SizedBox(width: 16.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: CustomFonts.textMain20w600),
                Text(title, style: CustomFonts.textMuted12w400),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarView() {
    return BorderdContainerWidget(
      height: 500.h,
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Clinic Calendar", style: CustomFonts.textMain20w600),
              Row(
                children: [
                  _calendarAction(Icons.chevron_left),
                  SizedBox(width: 8.w),
                  Text("October 2023", style: CustomFonts.textMain16w600),
                  SizedBox(width: 8.w),
                  _calendarAction(Icons.chevron_right),
                ],
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.2,
              ),
              itemCount: 35,
              itemBuilder: (context, index) {
                final day = index - 2;
                final isCurrentMonth = day > 0 && day <= 31;
                return Container(
                  decoration: BoxDecoration(border: Border.all(color: CustomColors.greyColor.withOpacity(0.3))),
                  padding: EdgeInsets.all(8.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isCurrentMonth ? day.toString() : "",
                        style: TextStyle(
                          color: isCurrentMonth ? CustomColors.textDark : CustomColors.textLight.withOpacity(0.3),
                          fontWeight: day == 15 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      if (day == 15 || day == 20)
                        Container(
                          margin: EdgeInsets.only(top: 4.h),
                          height: 4.h,
                          width: double.infinity,
                          decoration: BoxDecoration(color: CustomColors.primaryGold, borderRadius: BorderRadius.circular(2)),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _calendarAction(IconData icon) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(border: Border.all(color: CustomColors.greyColor), borderRadius: BorderRadius.circular(4.r)),
      child: Icon(icon, size: 18),
    );
  }

  Widget _buildUpcomingAppointments() {
    return BorderdContainerWidget(
      height: 500.h,
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Today's Queue", style: CustomFonts.textMain20w600),
          SizedBox(height: 16.h),
          Expanded(
            child: ListView.separated(
              itemCount: 6,
              separatorBuilder: (_, _) => SizedBox(height: 12.h),
              itemBuilder: (context, index) => _appointmentQueueItem(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appointmentQueueItem(int index) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(color: CustomColors.softChampagne.withOpacity(0.5), borderRadius: BorderRadius.circular(10.r)),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: const BoxDecoration(color: CustomColors.primaryGold, shape: BoxShape.circle),
            child: Center(child: Text("10:30", style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold))),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Bessie Cooper", style: CustomFonts.black14w600),
                Text("HydraFacial • NY Clinic", style: TextStyle(color: CustomColors.textLight, fontSize: 11.sp)),
              ],
            ),
          ),
          Icon(Icons.more_vert, size: 18, color: CustomColors.textLight),
        ],
      ),
    );
  }

  Widget _buildAppointmentTable() {
    return BorderdContainerWidget(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Text("All Appointments", style: CustomFonts.textMain20w600),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 40.w,
              headingRowColor: WidgetStateProperty.all(CustomColors.softChampagne.withOpacity(0.5)),
              columns: const [
                DataColumn(label: Text('Patient')),
                DataColumn(label: Text('Clinic')),
                DataColumn(label: Text('Treatment')),
                DataColumn(label: Text('Date & Time')),
                DataColumn(label: Text('Provider')),
                DataColumn(label: Text('Status')),
              ],
              rows: List.generate(5, (index) => _appointmentRow(index)),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _appointmentRow(int index) {
    return DataRow(
      cells: [
        DataCell(Text("Eleanor Pena", style: CustomFonts.black14w600)),
        DataCell(Text("Glow MedSpa NY")),
        DataCell(Text("Laser Resurfacing")),
        DataCell(Text("Oct 28, 2023 • 02:00 PM")),
        DataCell(Text("Dr. Sarah Jenkins")),
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(color: CustomColors.successGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(20.r)),
            child: Text("Confirmed", style: TextStyle(color: CustomColors.successGreen, fontSize: 11.sp, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
