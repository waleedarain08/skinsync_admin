import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/screens/appointment_detail_screen.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/widgets/app_search_field.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/custom_dropdown_widget.dart';
import 'package:skinsync_admin/widgets/custom_outlined_button.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';
import 'package:skinsync_admin/widgets/number_paginator.dart';

class AppointmentDummyModel {
  final String patientName;
  final String patientEmail;
  final String treatment;
  final String clinic;
  final String provider;
  final String dateTime;
  final String type;
  final String status;

  AppointmentDummyModel({
    required this.patientName,
    required this.patientEmail,
    required this.treatment,
    required this.clinic,
    required this.provider,
    required this.dateTime,
    required this.type,
    required this.status,
  });
}

class AppointmentManagement extends ConsumerStatefulWidget {
  static const String routeName = '/appointment-management';
  const AppointmentManagement({super.key});

  @override
  ConsumerState<AppointmentManagement> createState() => _AppointmentManagementState();
}

class _AppointmentManagementState extends ConsumerState<AppointmentManagement> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedClinicFilter = 'All Clinics';
  String _selectedProviderFilter = 'All Providers';
  String _selectedTypeFilter = 'All Types';
  String _selectedStatusFilter = 'All Statuses';

  int _currentPage = 0;
  static const int _itemsPerPage = 5;

  final List<AppointmentDummyModel> _appointments = [
    AppointmentDummyModel(
      patientName: 'Eleanor Pena',
      patientEmail: 'eleanor.pena@example.com',
      treatment: 'Laser Resurfacing',
      clinic: 'Glow MedSpa NY',
      provider: 'Dr. Sarah Jenkins',
      dateTime: 'Oct 28 • 02:00 PM',
      type: 'In-Person',
      status: 'Confirmed',
    ),
    AppointmentDummyModel(
      patientName: 'Bessie Cooper',
      patientEmail: 'bessie.c@example.com',
      treatment: 'HydraFacial Glow',
      clinic: 'Glow MedSpa NY',
      provider: 'Nurse Jane Cooper',
      dateTime: 'Oct 28 • 10:30 AM',
      type: 'In-Person',
      status: 'Completed',
    ),
    AppointmentDummyModel(
      patientName: 'Albert Flores',
      patientEmail: 'albert.f@example.com',
      treatment: 'Botox Injectables',
      clinic: 'Skinsync LA',
      provider: 'Dr. Albert Flores',
      dateTime: 'Oct 29 • 11:15 AM',
      type: 'In-Person',
      status: 'Scheduled',
    ),
    AppointmentDummyModel(
      patientName: 'Jane Cooper',
      patientEmail: 'jane.cooper@example.com',
      treatment: 'Chemical Peel',
      clinic: 'Aesthetic Chicago',
      provider: 'Nurse Jane Cooper',
      dateTime: 'Oct 30 • 04:30 PM',
      type: 'Virtual',
      status: 'No Show',
    ),
    AppointmentDummyModel(
      patientName: 'Wade Warren',
      patientEmail: 'wade.warren@example.com',
      treatment: 'Microneedling',
      clinic: 'Skinsync LA',
      provider: 'Dr. Albert Flores',
      dateTime: 'Oct 31 • 09:00 AM',
      type: 'Follow-Up',
      status: 'Cancelled',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dynamically filter list
    final filteredAppointments = _appointments.where((a) {
      final query = _searchController.text.toLowerCase();
      final matchesQuery = query.isEmpty ||
          a.patientName.toLowerCase().contains(query) ||
          a.treatment.toLowerCase().contains(query);

      final matchesClinic = _selectedClinicFilter == 'All Clinics' ||
          a.clinic == _selectedClinicFilter;

      final matchesProvider = _selectedProviderFilter == 'All Providers' ||
          a.provider == _selectedProviderFilter;

      final matchesType = _selectedTypeFilter == 'All Types' ||
          a.type == _selectedTypeFilter;

      final matchesStatus = _selectedStatusFilter == 'All Statuses' ||
          a.status == _selectedStatusFilter;

      return matchesQuery && matchesClinic && matchesProvider && matchesType && matchesStatus;
    }).toList();

    final totalPages = (filteredAppointments.length / _itemsPerPage).ceil();
    final paginatedAppointments = filteredAppointments.skip(_currentPage * _itemsPerPage).take(_itemsPerPage).toList();

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
            _buildFilters(),
            context.verticalSpace(24),
            _buildAppointmentTable(paginatedAppointments),
            if (totalPages > 1)
              Padding(
                padding: context.appEdgeInsets(vertical: 24),
                child: Center(
                  child: NumberPaginator(
                    totalPages: totalPages,
                    currentPage: _currentPage,
                    onPageChanged: (pageIndex) {
                      setState(() {
                        _currentPage = pageIndex;
                      });
                    },
                  ),
                ),
              ),
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
            Text('Booking Schedule', style: context.fonts.black26w700),
            context.verticalSpace(6),
            Text(
              'Centralized booking management and real-time clinic capacity tracking.',
              style: context.fonts.grey13w500,
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
        _buildMetricCard(context, 'Upcoming', '1,240', Icons.event_available_rounded, CustomColors.green),
        context.horizontalSpace(16),
        _buildMetricCard(context, 'Completed', '8,450', Icons.check_circle_outline_rounded, CustomColors.green),
        context.horizontalSpace(16),
        _buildMetricCard(context, 'Cancelled', '120', Icons.cancel_outlined, CustomColors.red),
        context.horizontalSpace(16),
        _buildMetricCard(context, 'No Shows', '45', Icons.person_off_outlined, CustomColors.amber),
      ],
    );
  }

  Widget _buildMetricCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Expanded(
      child: BorderdContainerWidget(
        padding: context.appEdgeInsets(all: 16),
        child: Row(
          children: [
            Container(
              padding: context.appEdgeInsets(all: 10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: context.borderRadius(all: 8),
              ),
              child: Icon(icon, color: color, size: context.sp(20)),
            ),
            context.horizontalSpace(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: context.fonts.black18w600, overflow: TextOverflow.ellipsis),
                  context.verticalSpace(2),
                  Text(title, style: context.fonts.grey11w400, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return BorderdContainerWidget(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: AppSearchField(
              controller: _searchController,
              hintText: 'Search appointments by patient or treatment name...',
              onChanged: (val) {
                setState(() {
                  _currentPage = 0;
                });
              },
              onClear: () {
                _searchController.clear();
                setState(() {
                  _currentPage = 0;
                });
              },
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: CustomDropdown<String>(
              label: 'Clinic',
              hintText: 'All Clinics',
              value: _selectedClinicFilter,
              items: const ['All Clinics', 'Glow MedSpa NY', 'Skinsync LA', 'Aesthetic Chicago']
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _selectedClinicFilter = val ?? 'All Clinics';
                  _currentPage = 0;
                });
              },
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: CustomDropdown<String>(
              label: 'Provider',
              hintText: 'All Providers',
              value: _selectedProviderFilter,
              items: const ['All Providers', 'Dr. Sarah Jenkins', 'Dr. Albert Flores', 'Nurse Jane Cooper']
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _selectedProviderFilter = val ?? 'All Providers';
                  _currentPage = 0;
                });
              },
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: CustomDropdown<String>(
              label: 'Type',
              hintText: 'All Types',
              value: _selectedTypeFilter,
              items: const ['All Types', 'In-Person', 'Virtual', 'Follow-Up']
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _selectedTypeFilter = val ?? 'All Types';
                  _currentPage = 0;
                });
              },
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: CustomDropdown<String>(
              label: 'Status',
              hintText: 'All Statuses',
              value: _selectedStatusFilter,
              items: const ['All Statuses', 'Confirmed', 'Scheduled', 'Completed', 'Cancelled', 'No Show']
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _selectedStatusFilter = val ?? 'All Statuses';
                  _currentPage = 0;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentTable(List<AppointmentDummyModel> list) {
    if (list.isEmpty) {
      return _buildEmptyState();
    }

    return BorderdContainerWidget(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(4), // Patient Details
            1: FlexColumnWidth(3), // Treatment
            2: FlexColumnWidth(3), // Clinic
            3: FlexColumnWidth(3), // Provider
            4: FlexColumnWidth(3), // Scheduled Time
            5: FlexColumnWidth(2), // Appointment Type
            6: FlexColumnWidth(2), // Status
            7: FlexColumnWidth(2), // Actions
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            // Header Row
            TableRow(
              decoration: const BoxDecoration(
                color: CustomColors.whiteGrey,
                border: Border(bottom: BorderSide(color: CustomColors.border)),
              ),
              children: [
                _tableHeaderCell('PATIENT'),
                _tableHeaderCell('TREATMENT'),
                _tableHeaderCell('CLINIC'),
                _tableHeaderCell('PROVIDER'),
                _tableHeaderCell('DATE & TIME'),
                _tableHeaderCell('TYPE'),
                _tableHeaderCell('STATUS'),
                _tableHeaderCell('ACTIONS'),
              ],
            ),
            // Data Rows
            ...list.map((a) {
              return TableRow(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: CustomColors.border)),
                ),
                children: [
                  _patientCell(a.patientName, a.patientEmail),
                  _tableTextCell(a.treatment, style: context.fonts.black14w600),
                  _tableTextCell(a.clinic, style: context.fonts.grey14w400),
                  _tableTextCell(a.provider, style: context.fonts.grey14w400),
                  _tableTextCell(a.dateTime, style: context.fonts.black14w600),
                  _tableTextCell(a.type, style: context.fonts.grey14w400),
                  _statusBadgeCell(a.status),
                  _actionsCell(a),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _tableHeaderCell(String label) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Text(
        label,
        style: context.fonts.grey12w600.copyWith(letterSpacing: 1),
      ),
    );
  }

  Widget _patientCell(String name, String email) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundColor: CustomColors.palePurple,
            child: Text(name[0], style: context.fonts.purple12w700),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: context.fonts.black14w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  email,
                  style: context.fonts.grey11w400,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableTextCell(String text, {required TextStyle style}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Text(
        text,
        style: style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _statusBadgeCell(String status) {
    final String cleanStatus = status.toLowerCase();
    Color badgeColor = CustomColors.green;

    if (cleanStatus == 'cancelled') {
      badgeColor = CustomColors.red;
    } else if (cleanStatus == 'no show') {
      badgeColor = CustomColors.amber;
    } else if (cleanStatus == 'scheduled') {
      badgeColor = Colors.blue;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: badgeColor.withValues(alpha: 0.2)),
          ),
          child: Text(
            status,
            style: context.fonts.grey12w600.copyWith(
              color: badgeColor,
              fontSize: 10.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _actionsCell(AppointmentDummyModel a) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 16.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'View Details',
            icon: Icon(Icons.visibility_outlined, color: CustomColors.grey, size: 20.sp),
            onPressed: () {
              ref.read(selectedAppointmentProvider.notifier).state = a;
              context.push(AppointmentDetailScreen.routeName);
            },
          ),
          IconButton(
            tooltip: 'Reschedule',
            icon: Icon(Icons.edit_calendar_rounded, color: CustomColors.purple, size: 20.sp),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 48),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: context.appEdgeInsets(all: 20),
              decoration: const BoxDecoration(
                color: CustomColors.whiteGrey,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.search_off_rounded, size: context.sp(48), color: CustomColors.grey),
            ),
            context.verticalSpace(24),
            Text('No appointments match your filters', style: context.fonts.black18w600),
            context.verticalSpace(8),
            Text(
              'Try clearing your search keyword, resetting the filters, or schedule a new appointment partner.',
              style: context.fonts.grey14w400,
              textAlign: TextAlign.center,
            ),
            context.verticalSpace(24),
            CustomOutlinedButton(
              onTap: () {
                _searchController.clear();
                setState(() {
                  _selectedClinicFilter = 'All Clinics';
                  _selectedProviderFilter = 'All Providers';
                  _selectedTypeFilter = 'All Types';
                  _selectedStatusFilter = 'All Statuses';
                });
              },
              label: 'Clear All Filters',
              color: Colors.white,
              textColor: CustomColors.purple,
            ),
          ],
        ),
      ),
    );
  }
}
