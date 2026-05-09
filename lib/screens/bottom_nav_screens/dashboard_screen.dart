import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';

class DashboardScreen extends StatelessWidget {
  static const String routeName = '/dashboard';
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Good Morning, Alex", style: CustomFonts.black30w600.copyWith(color: CustomColors.textMain)),
                  SizedBox(height: 4.h),
                  Text(
                    "Here's a summary of your MedSpa network performance.",
                    style: CustomFonts.grey18w400.copyWith(color: CustomColors.textMuted, fontSize: 14.sp),
                  ),
                ],
              ),
              _buildDateFilter(),
            ],
          ),
          SizedBox(height: 32.h),
          _buildQuickStats(),
          SizedBox(height: 32.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildRevenueChart()),
              SizedBox(width: 24.w),
              Expanded(flex: 1, child: _buildTopClinics()),
            ],
          ),
          SizedBox(height: 32.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildRecentAppointments()),
              SizedBox(width: 24.w),
              Expanded(child: _buildTreatmentAnalytics()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateFilter() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: CustomColors.textMuted.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today_rounded, size: 16.sp, color: CustomColors.brandPrimary),
          SizedBox(width: 10.w),
          Text("Oct 2023", style: TextStyle(color: CustomColors.textMain, fontWeight: FontWeight.w600, fontSize: 13.sp)),
          SizedBox(width: 8.w),
          Icon(Icons.keyboard_arrow_down_rounded, size: 18.sp, color: CustomColors.textMuted),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        _buildStatCard("Total Clinics", "54", "+12%", Icons.business_rounded, CustomColors.brandPrimary),
        SizedBox(width: 16.w),
        _buildStatCard("Active Patients", "12,450", "+5.2%", Icons.people_rounded, CustomColors.brandCyan),
        SizedBox(width: 16.w),
        _buildStatCard("New Appointments", "3,820", "+18%", Icons.event_available_rounded, CustomColors.brandPurple),
        SizedBox(width: 16.w),
        _buildStatCard("Total Revenue", "\$1.2M", "+24%", Icons.payments_rounded, CustomColors.success),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String growth, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: CustomColors.textMuted.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10.r)),
                  child: Icon(icon, color: color, size: 20.sp),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(color: CustomColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20.r)),
                  child: Text(growth, style: TextStyle(color: CustomColors.success, fontWeight: FontWeight.bold, fontSize: 10.sp)),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(value, style: TextStyle(color: CustomColors.textMain, fontSize: 24.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 2.h),
            Text(title, style: TextStyle(color: CustomColors.textMuted, fontSize: 12.sp, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart() {
    return BorderdContainerWidget(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Revenue Overview", style: CustomFonts.black20w600),
              Text("Target: \$1.5M", style: TextStyle(color: CustomColors.textMuted, fontSize: 12.sp)),
            ],
          ),
          SizedBox(height: 32.h),
          SizedBox(
            height: 280.h,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (v) => FlLine(color: CustomColors.textMuted.withValues(alpha: 0.05), strokeWidth: 1)),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [const FlSpot(0, 3), const FlSpot(1, 4), const FlSpot(2, 3.5), const FlSpot(3, 5), const FlSpot(4, 4.5), const FlSpot(5, 6)],
                    isCurved: true,
                    color: CustomColors.brandPrimary,
                    barWidth: 4,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [CustomColors.brandPrimary.withValues(alpha: 0.2), CustomColors.brandPrimary.withValues(alpha: 0)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopClinics() {
    return BorderdContainerWidget(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Top Clinics", style: CustomFonts.black20w600),
          SizedBox(height: 24.h),
          ...List.generate(5, (index) => _buildClinicItem(index)),
        ],
      ),
    );
  }

  Widget _buildClinicItem(int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundColor: CustomColors.brandCyan.withValues(alpha: 0.1),
            child: Text("${index + 1}", style: const TextStyle(color: CustomColors.brandPrimary, fontWeight: FontWeight.bold)),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Glow MedSpa NY", style: TextStyle(color: CustomColors.textMain, fontWeight: FontWeight.w600, fontSize: 13.sp)),
                Text("450 Active Patients", style: TextStyle(color: CustomColors.textMuted, fontSize: 11.sp)),
              ],
            ),
          ),
          Text("\$42k", style: TextStyle(color: CustomColors.textMain, fontWeight: FontWeight.bold, fontSize: 13.sp)),
        ],
      ),
    );
  }

  Widget _buildRecentAppointments() {
    return BorderdContainerWidget(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Recent Activity", style: CustomFonts.black20w600),
              TextButton(onPressed: () {}, child: const Text("View Report")),
            ],
          ),
          SizedBox(height: 16.h),
          ...List.generate(4, (index) => _activityItem(index)),
        ],
      ),
    );
  }

  Widget _activityItem(int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(color: CustomColors.surfaceGhost, borderRadius: BorderRadius.circular(8.r)),
            child: Icon(Icons.history_edu_rounded, color: CustomColors.textMuted, size: 18.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: CustomColors.textMain, fontSize: 13.sp),
                    children: [
                      const TextSpan(text: "Jane Cooper ", style: TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(text: "booked "),
                      const TextSpan(text: "Botox Treatment ", style: TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(text: "at Glow NY"),
                    ],
                  ),
                ),
                Text("2 hours ago", style: TextStyle(color: CustomColors.textMuted, fontSize: 11.sp)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentAnalytics() {
    return BorderdContainerWidget(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Treatments Distribution", style: CustomFonts.black20w600),
          SizedBox(height: 24.h),
          SizedBox(
            height: 200.h,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(value: 45, color: CustomColors.brandPrimary, title: '45%', radius: 40, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  PieChartSectionData(value: 30, color: CustomColors.brandCyan, title: '30%', radius: 40, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  PieChartSectionData(value: 25, color: CustomColors.brandPurple, title: '25%', radius: 40, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
          _legendItem("Injectables", CustomColors.brandPrimary),
          _legendItem("Skin Treatments", CustomColors.brandCyan),
          _legendItem("Laser & Energy", CustomColors.brandPurple),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          SizedBox(width: 12.w),
          Text(label, style: TextStyle(color: CustomColors.textMain, fontSize: 13.sp, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
