import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/app_badge.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';

import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

class AppointmentManagement extends StatefulWidget {
  static const String routeName = '/appointment-management';
  const AppointmentManagement({super.key});

  @override
  State<AppointmentManagement> createState() => _AppointmentManagementState();
}

class _AppointmentManagementState extends State<AppointmentManagement> {
  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(
          horizontal: 28,
          vertical: 28,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            context.verticalSpace(32),
            _buildAppointmentMetrics(context),
            context.verticalSpace(32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildCalendarView(context)),
                context.horizontalSpace(24),
                Expanded(flex: 1, child: _buildUpcomingAppointments(context)),
              ],
            ),
            context.verticalSpace(32),
            _buildAppointmentTable(context),
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
            Text("Booking Schedule", style: CustomFonts.black26w700),
            context.verticalSpace(6),
            Text(
              "Centralized booking management and real-time clinic capacity tracking.",
              style: CustomFonts.grey13w500,
            ),
          ],
        ),
        CustomPrimaryButton(
          onTap: () {},
          icon: Icons.add_task_rounded,
          label: 'Book Appointment',
        ),
      ],
    );
  }

  Widget _buildAppointmentMetrics(BuildContext context) {
    return Row(
      children: [
        _buildMetricCard(context, "Upcoming", "1,240", Icons.event_available_rounded, CustomColors.green),
        context.horizontalSpace(16),
        _buildMetricCard(context, "Completed", "8,450", Icons.check_circle_outline_rounded, CustomColors.green),
        context.horizontalSpace(16),
        _buildMetricCard(context, "Cancelled", "120", Icons.cancel_outlined, CustomColors.red),
        context.horizontalSpace(16),
        _buildMetricCard(context, "No Shows", "45", Icons.person_off_outlined, CustomColors.amber),
      ],
    );
  }

  Widget _buildMetricCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Expanded(
      child: BorderdContainerWidget(
        padding: context.appEdgeInsets(all: 20),
        child: Row(
          children: [
            Container(
              padding: context.appEdgeInsets(all: 12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: context.borderRadius(all: 8),
              ),
              child: Icon(icon, color: color, size: context.sp(22)),
            ),
            context.horizontalSpace(16),
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

  Widget _buildCalendarView(BuildContext context) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Network Calendar", style: CustomFonts.black18w600),
              Row(
                children: [
                  _calendarAction(context, Icons.chevron_left_rounded),
                  context.horizontalSpace(16),
                  Text("October 2023", style: CustomFonts.black14w600),
                  context.horizontalSpace(16),
                  _calendarAction(context, Icons.chevron_right_rounded),
                ],
              ),
            ],
          ),
          context.verticalSpace(24),
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
                  color: isSelected ? CustomColors.palePurple : Colors.transparent,
                  borderRadius: context.borderRadius(all: 8),
                  border: Border.all(
                    color: isSelected ? CustomColors.green.withValues(alpha: 0.3) : CustomColors.border.withValues(alpha: 0.5),
                  ),
                ),
                padding: context.appEdgeInsets(all: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isCurrentMonth ? day.toString() : "",
                      style: isSelected ? CustomFonts.black14w700 : (isCurrentMonth ? CustomFonts.black12w400 : CustomFonts.grey12w400),
                    ),
                    if (isCurrentMonth && (day == 15 || day == 20))
                      Container(
                        margin: context.appEdgeInsets(top: 4),
                        height: context.h(3),
                        width: context.w(12),
                        decoration: BoxDecoration(
                          color: CustomColors.green,
                          borderRadius: BorderRadius.circular(AppRadius.full(context)),
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

  Widget _calendarAction(BuildContext context, IconData icon) {
    return Container(
      padding: context.appEdgeInsets(all: 8),
      decoration: BoxDecoration(
        color: CustomColors.white,
        border: Border.all(color: CustomColors.border),
        borderRadius: context.borderRadius(all: 8),
      ),
      child: Icon(icon, size: context.sp(18), color: CustomColors.grey),
    );
  }

  Widget _buildUpcomingAppointments(BuildContext context) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Today's Queue", style: CustomFonts.black18w600),
          context.verticalSpace(24),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (_, _) => context.verticalSpace(12),
            itemBuilder: (context, index) => _appointmentQueueItem(context, index),
          ),
        ],
      ),
    );
  }

  Widget _appointmentQueueItem(BuildContext context, int index) {
    return Container(
      padding: context.appEdgeInsets(all: 12),
      decoration: BoxDecoration(
        color: CustomColors.whiteGrey,
        borderRadius: context.borderRadius(all: 10),
        border: Border.all(color: CustomColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: context.w(44),
            height: context.w(44),
            decoration: BoxDecoration(
              color: CustomColors.palePurple,
              borderRadius: context.borderRadius(all: 8),
            ),
            child: Center(
              child: Text(
                "10:30", 
                style: CustomFonts.green11w600,
              ),
            ),
          ),
          context.horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Bessie Cooper", style: CustomFonts.black14w600),
                Text("HydraFacial • Glow NY", style: CustomFonts.grey12w400),
              ],
            ),
          ),
          const Icon(Icons.more_vert_rounded, size: 18, color: CustomColors.lightGrey),
        ],
      ),
    );
  }

  Widget _buildAppointmentTable(BuildContext context) {
    return BorderdContainerWidget(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: context.appEdgeInsets(all: 24),
            child: Text("Registry Log", style: CustomFonts.black18w600),
          ),
          DataTable(
            columnSpacing: context.w(40),
            headingRowColor: WidgetStateProperty.all(CustomColors.whiteGrey),
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
