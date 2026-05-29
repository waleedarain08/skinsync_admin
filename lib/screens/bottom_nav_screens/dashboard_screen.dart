import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/widgets/app_badge.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';

import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

class DashboardScreen extends StatelessWidget {
  static const String routeName = '/dashboard';
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.pagePaddingH,
          vertical: AppSpacing.pagePaddingV,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Good Morning, Alex', style: CustomFonts.black32w700),
                      SizedBox(height: 6.h),
                      Text(
                        "Here's a summary of your MedSpa network performance.",
                        style: CustomFonts.grey13w500,
                      ),
                    ],
                  ),
                ),
                _buildDateFilter(),
              ],
            ),
            SizedBox(height: AppSpacing.xxl),
            _buildQuickStats(),
            SizedBox(height: AppSpacing.xxl),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildRevenueChart()),
                SizedBox(width: AppSpacing.xl),
                Expanded(flex: 1, child: _buildTopClinics()),
              ],
            ),
            SizedBox(height: AppSpacing.xxl),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildRecentAppointments()),
                SizedBox(width: AppSpacing.xl),
                Expanded(child: _buildTreatmentAnalytics()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateFilter() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10.h),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: CustomColors.border),
        boxShadow: AppShadows.xs,
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today_rounded, size: 16.sp, color: CustomColors.purple),
          SizedBox(width: AppSpacing.sm),
          Text('Oct 2023', style: CustomFonts.black14w600),
          SizedBox(width: AppSpacing.xs),
          Icon(Icons.keyboard_arrow_down_rounded, size: 18.sp, color: CustomColors.lightGrey),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        _buildStatCard('Total Clinics', '54', '+12%', Icons.domain_rounded, CustomColors.purple),
        SizedBox(width: AppSpacing.md),
        _buildStatCard('Active Patients', '12,450', '+5.2%', Icons.people_rounded, CustomColors.green),
        SizedBox(width: AppSpacing.md),
        _buildStatCard('New Appointments', '3,820', '+18%', Icons.event_available_rounded, CustomColors.lightPurple),
        SizedBox(width: AppSpacing.md),
        _buildStatCard('Total Revenue', '\$1.2M', '+24%', Icons.payments_rounded, CustomColors.green),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String growth, IconData icon, Color color) {
    return Expanded(
      child: BorderdContainerWidget(
        enableHover: true,
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(icon, color: color, size: 20.sp),
                ),
                AppBadge(label: growth, variant: AppBadgeVariant.success),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            Text(value, style: CustomFonts.black20w600),
            SizedBox(height: 2.h),
            Text(title, style: CustomFonts.grey13w500),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart() {
    return BorderdContainerWidget(
      enableHover: true,
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Revenue Overview', style: CustomFonts.black18w600),
              Text('Target: \$1.5M', style: CustomFonts.grey12w400),
            ],
          ),
          SizedBox(height: AppSpacing.xl),
          SizedBox(
            height: 280.h,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (v) => FlLine(color: CustomColors.border, strokeWidth: 1),
                ),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 3),
                      FlSpot(1, 4),
                      FlSpot(2, 3.5),
                      FlSpot(3, 5),
                      FlSpot(4, 4.5),
                      FlSpot(5, 6),
                    ],
                    isCurved: true,
                    color: CustomColors.purple,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          CustomColors.purple.withValues(alpha: 0.2),
                          CustomColors.purple.withValues(alpha: 0),
                        ],
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
      enableHover: true,
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top Clinics', style: CustomFonts.black18w600),
          SizedBox(height: AppSpacing.xl),
          ...List.generate(5, (index) => _buildClinicItem(index)),
        ],
      ),
    );
  }

  Widget _buildClinicItem(int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              gradient: CustomColors.purpleToLightPurpleGradient,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            alignment: Alignment.center,
            child: Text(
              '${index + 1}',
              style: CustomFonts.white12w700,
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Glow MedSpa NY', style: CustomFonts.black14w600),
                Text('450 Active Patients', style: CustomFonts.grey12w400),
              ],
            ),
          ),
          Text('\$42k', style: CustomFonts.purple14w600),
        ],
      ),
    );
  }

  Widget _buildRecentAppointments() {
    return BorderdContainerWidget(
      enableHover: true,
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Activity', style: CustomFonts.black18w600),
              TextButton(
                onPressed: () {},
                child: Text('View Report', style: CustomFonts.purple14w600),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          ...List.generate(4, (index) => _activityItem()),
        ],
      ),
    );
  }

  Widget _activityItem() {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: CustomColors.softGrey,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(Icons.history_edu_rounded, color: CustomColors.grey, size: 18.sp),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: CustomFonts.black13w500,
                    children: [
                      TextSpan(text: 'Jane Cooper ', style: CustomFonts.black13w600),
                      const TextSpan(text: 'booked '),
                      TextSpan(text: 'Botox Treatment ', style: CustomFonts.black13w600),
                      const TextSpan(text: 'at Glow NY'),
                    ],
                  ),
                ),
                Text('2 hours ago', style: CustomFonts.grey12w400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentAnalytics() {
    return BorderdContainerWidget(
      enableHover: true,
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Treatments Distribution', style: CustomFonts.black18w600),
          SizedBox(height: AppSpacing.xl),
          SizedBox(
            height: 200.h,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: 45,
                    color: CustomColors.purple,
                    title: '45%',
                    radius: 40,
                    titleStyle: CustomFonts.white12w400,
                  ),
                  PieChartSectionData(
                    value: 30,
                    color: CustomColors.green,
                    title: '30%',
                    radius: 40,
                    titleStyle: CustomFonts.black12w400,
                  ),
                  PieChartSectionData(
                    value: 25,
                    color: CustomColors.lightPurple,
                    title: '25%',
                    radius: 40,
                    titleStyle: CustomFonts.white12w400,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          _legendItem('Injectables', CustomColors.purple),
          _legendItem('Skin Treatments', CustomColors.green),
          _legendItem('Laser & Energy', CustomColors.lightPurple),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          SizedBox(width: AppSpacing.sm),
          Text(label, style: CustomFonts.grey14w400),
        ],
      ),
    );
  }
}
