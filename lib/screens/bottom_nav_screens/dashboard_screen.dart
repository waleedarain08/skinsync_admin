import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/widgets/app_badge.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  static const String routeName = '/dashboard';

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 28, vertical: 28),
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
                      Text(
                        'Good Morning, Alex',
                        style: context.fonts.black32w700,
                      ),
                      context.verticalSpace(6),
                      Text(
                        "Here's a summary of your MedSpa network performance.",
                        style: context.fonts.grey13w500,
                      ),
                    ],
                  ),
                ),
                _buildDateFilter(context),
              ],
            ),
            context.verticalSpace(32),
            _buildQuickStats(context),
            context.verticalSpace(32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildRevenueChart(context)),
                context.horizontalSpace(24),
                Expanded(flex: 1, child: _buildTopClinics(context)),
              ],
            ),
            context.verticalSpace(32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildRecentAppointments(context)),
                context.horizontalSpace(24),
                Expanded(child: _buildTreatmentAnalytics(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateFilter(BuildContext context) {
    return Container(
      padding: context.appEdgeInsets(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: context.appBorderRadius(all: 12),
        border: Border.all(color: CustomColors.border),
        boxShadow: AppShadows.xs(context),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_rounded,
            size: context.sp(16),
            color: CustomColors.purple,
          ),
          context.horizontalSpace(12),
          Text('Oct 2023', style: context.fonts.black14w600),
          context.horizontalSpace(8),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: context.sp(18),
            color: CustomColors.lightGrey,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Row(
      children: [
        _buildStatCard(
          context,
          'Total Clinics',
          '54',
          '+12%',
          Icons.domain_rounded,
          CustomColors.purple,
        ),
        context.horizontalSpace(16),
        _buildStatCard(
          context,
          'Active Patients',
          '12,450',
          '+5.2%',
          Icons.people_rounded,
          CustomColors.green,
        ),
        context.horizontalSpace(16),
        _buildStatCard(
          context,
          'New Appointments',
          '3,820',
          '+18%',
          Icons.event_available_rounded,
          CustomColors.lightPurple,
        ),
        context.horizontalSpace(16),
        _buildStatCard(
          context,
          'Total Revenue',
          '\$1.2M',
          '+24%',
          Icons.payments_rounded,
          CustomColors.green,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    String growth,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: BorderdContainerWidget(
        enableHover: true,
        padding: context.appEdgeInsets(all: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: context.appEdgeInsets(all: 10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: context.appBorderRadius(all: 8),
                  ),
                  child: Icon(icon, color: color, size: context.sp(20)),
                ),
                AppBadge(label: growth, variant: AppBadgeVariant.success),
              ],
            ),
            context.verticalSpace(16),
            Text(value, style: context.fonts.black20w600),
            context.verticalSpace(2),
            Text(title, style: context.fonts.grey13w500),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart(BuildContext context) {
    return BorderdContainerWidget(
      enableHover: true,
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Revenue Overview', style: context.fonts.black18w600),
              Text('Target: \$1.5M', style: context.fonts.grey12w400),
            ],
          ),
          context.verticalSpace(24),
          SizedBox(
            height: context.h(280),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (v) =>
                      const FlLine(color: CustomColors.border, strokeWidth: 1),
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

  Widget _buildTopClinics(BuildContext context) {
    return BorderdContainerWidget(
      enableHover: true,
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top Clinics', style: context.fonts.black18w600),
          context.verticalSpace(24),
          ...List.generate(5, (index) => _buildClinicItem(context, index)),
        ],
      ),
    );
  }

  Widget _buildClinicItem(BuildContext context, int index) {
    return Padding(
      padding: context.appEdgeInsets(bottom: 16),
      child: Row(
        children: [
          Container(
            width: context.w(36),
            height: context.w(36),
            decoration: BoxDecoration(
              gradient: CustomColors.purpleWhiteStateBlueLightGradient,
              borderRadius: context.appBorderRadius(all: 8),
            ),
            alignment: Alignment.center,
            child: Text('${index + 1}', style: context.fonts.white12w700),
          ),
          context.horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Glow MedSpa NY', style: context.fonts.black14w600),
                Text('450 Active Patients', style: context.fonts.grey12w400),
              ],
            ),
          ),
          Text('\$42k', style: context.fonts.purple14w600),
        ],
      ),
    );
  }

  Widget _buildRecentAppointments(BuildContext context) {
    return BorderdContainerWidget(
      enableHover: true,
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Activity', style: context.fonts.black18w600),
              TextButton(
                onPressed: () {},
                child: Text('View Report', style: context.fonts.purple14w600),
              ),
            ],
          ),
          context.verticalSpace(16),
          ...List.generate(4, (index) => _activityItem(context)),
        ],
      ),
    );
  }

  Widget _activityItem(BuildContext context) {
    return Padding(
      padding: context.appEdgeInsets(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: context.appEdgeInsets(all: 8),
            decoration: BoxDecoration(
              color: CustomColors.softGrey,
              borderRadius: context.appBorderRadius(all: 8),
            ),
            child: Icon(
              Icons.history_edu_rounded,
              color: CustomColors.grey,
              size: context.sp(18),
            ),
          ),
          context.horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: context.fonts.black13w500,
                    children: [
                      TextSpan(
                        text: 'Jane Cooper ',
                        style: context.fonts.black13w600,
                      ),
                      const TextSpan(text: 'booked '),
                      TextSpan(
                        text: 'Botox Treatment ',
                        style: context.fonts.black13w600,
                      ),
                      const TextSpan(text: 'at Glow NY'),
                    ],
                  ),
                ),
                Text('2 hours ago', style: context.fonts.grey12w400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentAnalytics(BuildContext context) {
    return BorderdContainerWidget(
      enableHover: true,
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Treatments Distribution', style: context.fonts.black18w600),
          context.verticalSpace(24),
          SizedBox(
            height: context.h(200),
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: 45,
                    color: CustomColors.purple,
                    title: '45%',
                    radius: 40,
                    titleStyle: context.fonts.white12w400,
                  ),
                  PieChartSectionData(
                    value: 30,
                    color: CustomColors.green,
                    title: '30%',
                    radius: 40,
                    titleStyle: context.fonts.black12w400,
                  ),
                  PieChartSectionData(
                    value: 25,
                    color: CustomColors.lightPurple,
                    title: '25%',
                    radius: 40,
                    titleStyle: context.fonts.white12w400,
                  ),
                ],
              ),
            ),
          ),
          context.verticalSpace(24),
          _legendItem(context, 'Injectables', CustomColors.purple),
          _legendItem(context, 'Skin Treatments', CustomColors.green),
          _legendItem(context, 'Laser & Energy', CustomColors.lightPurple),
        ],
      ),
    );
  }

  Widget _legendItem(BuildContext context, String label, Color color) {
    return Padding(
      padding: context.appEdgeInsets(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          context.horizontalSpace(12),
          Text(label, style: context.fonts.grey14w400),
        ],
      ),
    );
  }
}
