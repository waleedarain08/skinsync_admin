import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/appointment_management.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

class SelectedAppointmentNotifier extends Notifier<AppointmentDummyModel?> {
  @override
  AppointmentDummyModel? build() => null;
  void set(AppointmentDummyModel? a) => state = a;
}

final selectedAppointmentProvider = NotifierProvider<SelectedAppointmentNotifier, AppointmentDummyModel?>(
  SelectedAppointmentNotifier.new,
);

class AppointmentDetailScreen extends ConsumerWidget {
  static const String routeName = '/appointment-detail';
  const AppointmentDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointment = ref.watch(selectedAppointmentProvider);

    if (appointment == null) {
      return GradientScaffold(
        body: Center(
          child: Text('No Appointment Data Found', style: context.fonts.black16w400),
        ),
      );
    }

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        title: Text('Appointment Details', style: context.fonts.black18w600),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CustomColors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 24, vertical: 32),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.w(1000)),
            child: Column(
              children: [
                _buildHeaderSection(context, appointment),
                context.verticalSpace(32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _buildMainContent(context, appointment)),
                    context.horizontalSpace(32),
                    Expanded(flex: 2, child: _buildSidebar(context, appointment)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, AppointmentDummyModel a) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 32),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.r,
            backgroundColor: CustomColors.palePurple,
            child: Text(a.patientName[0], style: context.fonts.purple16w700),
          ),
          context.horizontalSpace(32),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        a.patientName,
                        style: context.fonts.black26w700,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    context.horizontalSpace(16),
                    _statusBadge(context, a.status),
                  ],
                ),
                context.verticalSpace(8),
                Text('${a.treatment} • ${a.clinic}', style: context.fonts.purple14w600),
                context.verticalSpace(16),
                Wrap(
                  spacing: 12.w,
                  runSpacing: 12.h,
                  children: [
                    _infoChip(context, Icons.calendar_today_outlined, 'Scheduled: ${a.dateTime}'),
                    _infoChip(context, Icons.person_outline_rounded, 'Provider: ${a.provider}'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, AppointmentDummyModel a) {
    return Column(
      children: [
        _infoSection(context, 'Appointment & Schedule details', [
          _detailRow(context, 'Consultation / Service Type', a.type),
          _detailRow(context, 'Assigned Practitioner', a.provider),
          _detailRow(context, 'Scheduled Session Time', a.dateTime),
          _detailRow(context, 'Est. Duration', '45 Minutes'),
        ]),
        context.verticalSpace(24),
        _infoSection(context, 'Patient Record Summary', [
          _detailRow(context, 'Patient Name', a.patientName),
          _detailRow(context, 'Contact Email', a.patientEmail),
          _detailRow(context, 'Assigned Home Clinic', a.clinic),
        ]),
        context.verticalSpace(24),
        _infoSection(context, 'Internal Clinical Notes', [
          Text(
            'Patient requested a focused skin review prior to starting the ${a.treatment} session. Please monitor baseline redness and lot history codes for skin suitability.',
            style: context.fonts.grey14w400h16,
          ),
        ]),
      ],
    );
  }

  Widget _buildSidebar(BuildContext context, AppointmentDummyModel a) {
    return Column(
      children: [
        _infoSection(context, 'Performance Directory', [
          _statRow(context, Icons.local_hospital_outlined, 'Associated Clinic', a.clinic),
          _statRow(context, Icons.payments_outlined, 'Est. Revenue', '\$150.00'),
        ]),
        context.verticalSpace(24),
        _infoSection(context, 'Activity Tracking Log', [
          _timelineStep(context, '09:12 AM', 'Appointment Booked', 'Processed automatically via mobile application gateway.'),
          context.verticalSpace(16),
          _timelineStep(context, '09:30 AM', 'Practitioner Confirmed', 'Assigned practitioner ${a.provider} accepted request.'),
        ]),
      ],
    );
  }

  Widget _timelineStep(BuildContext context, String time, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle_rounded, color: CustomColors.green, size: context.sp(16)),
        context.horizontalSpace(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: context.fonts.black14w600),
              context.verticalSpace(2),
              Text(time, style: context.fonts.grey11w400),
              context.verticalSpace(4),
              Text(desc, style: context.fonts.grey12w400),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoSection(BuildContext context, String title, List<Widget> children) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.fonts.black16w700),
          context.verticalSpace(24),
          ...children,
        ],
      ),
    );
  }

  Widget _detailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: context.appEdgeInsets(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: context.fonts.grey13w500),
          context.verticalSpace(4),
          Text(value, style: context.fonts.black14w600),
        ],
      ),
    );
  }

  Widget _statRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: context.appEdgeInsets(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: context.sp(18), color: CustomColors.grey),
              context.horizontalSpace(12),
              Text(label, style: context.fonts.grey13w500),
            ],
          ),
          Flexible(child: Text(value, style: context.fonts.grey14w600, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _statusBadge(BuildContext context, String status) {
    final bool isCompleted = status.toLowerCase() == 'completed' || status.toLowerCase() == 'confirmed';
    return Container(
      padding: context.appEdgeInsets(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isCompleted ? CustomColors.green.withValues(alpha: 0.1) : CustomColors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status.toUpperCase(),
        style: isCompleted ? context.fonts.green10w700 : context.fonts.amber10w800ls1,
      ),
    );
  }

  Widget _infoChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: context.appEdgeInsets(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: CustomColors.whiteGrey, borderRadius: BorderRadius.circular(8.r)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: context.sp(14), color: CustomColors.grey),
          context.horizontalSpace(8),
          Text(label, style: context.fonts.grey13w500),
        ],
      ),
    );
  }
}
