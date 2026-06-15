import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/widgets/app_loader.dart';

import '../../models/clinic_model.dart';
import '../../models/invite_clinic_model.dart';
import '../../utils/theme.dart';
import '../../view_models/clinic_view_model.dart';
import '../../widgets/app_search_field.dart';
import '../../widgets/borderd_container_widget.dart';
import '../../widgets/custom_dropdown_widget.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_primary_button.dart';
import '../../widgets/dailogbox/clinic_dailogbox.dart';
import '../../widgets/gradient_scaffold.dart';
import '../../widgets/number_paginator.dart';
import '../add_new_clinic_screen.dart';
import '../clinic_detail_screen.dart';
import '../invite_clinic_detail_screen.dart';

class ClinicManagement extends ConsumerStatefulWidget {
  static const String routeName = '/clinic-management';
  const ClinicManagement({super.key});

  @override
  ConsumerState<ClinicManagement> createState() => _ClinicManagementState();
}

class _ClinicManagementState extends ConsumerState<ClinicManagement>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  String _selectedRegionFilter = 'All Regions';
  String _selectedPlanFilter = 'All Plans';
  String _selectedStatusFilter = 'All Statuses';

  int _activePage = 0;
  int _invitePage = 0;
  static const int _itemsPerPage = 5;

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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(clinicViewModelProvider);
    final clinics = state.clinics ?? [];
    final inviteClinics = state.inviteClinics ?? [];

    // Filter active clinics
    final filteredClinics = clinics.where((c) {
      final query = _searchController.text.toLowerCase();
      final matchesQuery =
          query.isEmpty ||
          (c.name?.toLowerCase().contains(query) ?? false) ||
          (c.email?.toLowerCase().contains(query) ?? false) ||
          (c.address?.toLowerCase().contains(query) ?? false);

      final matchesPlan =
          _selectedPlanFilter == 'All Plans' ||
          c.subscriptionPlan == _selectedPlanFilter;

      final matchesRegion =
          _selectedRegionFilter == 'All Regions' ||
          (c.address?.toLowerCase().contains(
                _selectedRegionFilter.toLowerCase(),
              ) ??
              false);

      final matchesStatus =
          _selectedStatusFilter == 'All Statuses' ||
          (c.status?.toLowerCase() == _selectedStatusFilter.toLowerCase());

      return matchesQuery && matchesPlan && matchesRegion && matchesStatus;
    }).toList();

    // Filter invite clinics
    final filteredInvites = inviteClinics.where((c) {
      final query = _searchController.text.toLowerCase();
      final matchesQuery =
          query.isEmpty ||
          c.name.toLowerCase().contains(query) ||
          c.email.toLowerCase().contains(query) ||
          c.address.toLowerCase().contains(query);

      final matchesRegion =
          _selectedRegionFilter == 'All Regions' ||
          c.address.toLowerCase().contains(_selectedRegionFilter.toLowerCase());

      final matchesStatus =
          _selectedStatusFilter == 'All Statuses' ||
          (_selectedStatusFilter == 'Pending' &&
              c.invitationStatus.toLowerCase().contains('sent'));

      return matchesQuery && matchesRegion && matchesStatus;
    }).toList();

    return GradientScaffold(
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 28, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            context.verticalSpace(32),
            _buildStatsSummary(context),
            context.verticalSpace(32),
            _buildFilters(),
            context.verticalSpace(32),
            _buildTabs(),
            context.verticalSpace(24),
            SizedBox(
              height: context.h(600),
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildActiveClinicsTab(
                    context,
                    filteredClinics,
                    state.loading,
                  ),
                  _buildPendingInvitationsTab(
                    context,
                    filteredInvites,
                    state.loading,
                  ),
                ],
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
            Text('Clinic Partners', style: context.fonts.black26w700),
            context.verticalSpace(6),
            Text(
              'Manage and monitor your MedSpa network performance.',
              style: context.fonts.grey13w500,
            ),
          ],
        ),
        CustomPrimaryButton(
          onTap: () => context.push(AddNewClinicScreen.routeName),
          icon: Icons.add_rounded,
          label: 'Add New Clinic',
          width: context.w(200),
        ),
      ],
    );
  }

  Widget _buildStatsSummary(BuildContext context) {
    return Row(
      children: [
        _buildMiniStat(
          context,
          'Total Clinics',
          '48',
          Icons.business_rounded,
          CustomColors.purple,
        ),
        context.horizontalSpace(16),
        _buildMiniStat(
          context,
          'Active Partners',
          '42',
          Icons.bolt_rounded,
          CustomColors.green,
        ),
        context.horizontalSpace(16),
        _buildMiniStat(
          context,
          'Network Revenue',
          '\$245K',
          Icons.payments_rounded,
          CustomColors.green,
        ),
        context.horizontalSpace(16),
        _buildMiniStat(
          context,
          'Avg Patient Rating',
          '4.8',
          Icons.star_rounded,
          Colors.amber,
        ),
      ],
    );
  }

  Widget _buildMiniStat(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
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
                  Text(
                    value,
                    style: context.fonts.black18w600,
                    overflow: TextOverflow.ellipsis,
                  ),
                  context.verticalSpace(2),
                  Text(
                    title,
                    style: context.fonts.grey11w400,
                    overflow: TextOverflow.ellipsis,
                  ),
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
              hintText: 'Search clinics by name, email or location...',
              onChanged: (val) {
                setState(() {
                  _activePage = 0;
                  _invitePage = 0;
                });
              },
              onClear: () {
                _searchController.clear();
                setState(() {
                  _activePage = 0;
                  _invitePage = 0;
                });
              },
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: CustomDropdown<String>(
              label: 'Region / Network',
              hintText: 'All Regions',
              value: _selectedRegionFilter,
              items: const [
                'All Regions',
                'East Coast',
                'West Coast',
                'Midwest',
                'South',
              ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedRegionFilter = val ?? 'All Regions';
                  _activePage = 0;
                  _invitePage = 0;
                });
              },
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: CustomDropdown<String>(
              label: 'Subscription Plan',
              hintText: 'All Plans',
              value: _selectedPlanFilter,
              items: const [
                'All Plans',
                'Basic',
                'Standard',
                'Premium',
                'Enterprise',
              ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedPlanFilter = val ?? 'All Plans';
                  _activePage = 0;
                  _invitePage = 0;
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
              items: const [
                'All Statuses',
                'Active',
                'Inactive',
                'Pending',
                'Suspended',
              ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedStatusFilter = val ?? 'All Statuses';
                  _activePage = 0;
                  _invitePage = 0;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: CustomColors.border)),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabs: const [
          Tab(text: 'Active Partners'),
          Tab(text: 'Prospect Invitations'),
        ],
      ),
    );
  }

  Widget _buildActiveClinicsTab(
    BuildContext context,
    List<ClinicModel> clinics,
    bool isLoading,
  ) {
    if (isLoading) {
      return const Center(child: AppLoader());
    }

    if (clinics.isEmpty) {
      return _buildEmptyState();
    }

    final totalPages = (clinics.length / _itemsPerPage).ceil();
    final paginatedClinics = clinics
        .skip(_activePage * _itemsPerPage)
        .take(_itemsPerPage)
        .toList();

    return Column(
      children: [
        Expanded(
          child: BorderdContainerWidget(
            padding: EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(4), // Clinic Name / logo
                  1: FlexColumnWidth(3), // Contact / Location
                  2: FlexColumnWidth(2), // Subscription Plan
                  3: FlexColumnWidth(2), // Total Appointments (or Providers)
                  4: FlexColumnWidth(2), // Total Treatments
                  5: FlexColumnWidth(2), // Status
                  6: FlexColumnWidth(2), // Actions
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  // Header Row
                  TableRow(
                    decoration: const BoxDecoration(
                      color: CustomColors.whiteGrey,
                      border: Border(
                        bottom: BorderSide(color: CustomColors.border),
                      ),
                    ),
                    children: [
                      _tableHeaderCell('CLINIC PARTNER'),
                      _tableHeaderCell('CONTACT & REGION'),
                      _tableHeaderCell('PLAN'),
                      _tableHeaderCell('APPOINTMENTS'),
                      _tableHeaderCell('TREATMENTS'),
                      _tableHeaderCell('STATUS'),
                      _tableHeaderCell('ACTIONS'),
                    ],
                  ),
                  // Data Rows
                  ...paginatedClinics.map((clinic) {
                    return TableRow(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: CustomColors.border),
                        ),
                      ),
                      children: [
                        _clinicNameCell(clinic.name, clinic.logo),
                        _clinicContactCell(
                          clinic.email,
                          clinic.phone,
                          clinic.address,
                        ),
                        _tableTextCell(
                          clinic.subscriptionPlan ?? 'Standard',
                          style: context.fonts.black14w600,
                        ),
                        _tableTextCell(
                          '${clinic.totalAppointments ?? 0} Appts',
                          style: context.fonts.grey14w400,
                        ),
                        _tableTextCell(
                          '${clinic.totalTreatments ?? 0} Proc',
                          style: context.fonts.grey14w400,
                        ),
                        _statusBadgeCell(clinic.status ?? 'Active'),
                        _activeActionsCell(clinic),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
        if (totalPages > 1)
          Padding(
            padding: context.appEdgeInsets(vertical: 24),
            child: Center(
              child: NumberPaginator(
                totalPages: totalPages,
                currentPage: _activePage,
                onPageChanged: (pageIndex) {
                  setState(() {
                    _activePage = pageIndex;
                  });
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPendingInvitationsTab(
    BuildContext context,
    List<InviteClinicModel> invites,
    bool isLoading,
  ) {
    if (isLoading) {
      return const Center(child: AppLoader());
    }

    if (invites.isEmpty) {
      return _buildEmptyState();
    }

    final totalPages = (invites.length / _itemsPerPage).ceil();
    final paginatedInvites = invites
        .skip(_invitePage * _itemsPerPage)
        .take(_itemsPerPage)
        .toList();

    return Column(
      children: [
        Expanded(
          child: BorderdContainerWidget(
            padding: EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(4), // Clinic Name / logo
                  1: FlexColumnWidth(4), // Contact / Location
                  2: FlexColumnWidth(3), // Region / Address
                  3: FlexColumnWidth(2), // Status
                  4: FlexColumnWidth(2), // Actions
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  // Header Row
                  TableRow(
                    decoration: const BoxDecoration(
                      color: CustomColors.whiteGrey,
                      border: Border(
                        bottom: BorderSide(color: CustomColors.border),
                      ),
                    ),
                    children: [
                      _tableHeaderCell('PROSPECT CLINIC'),
                      _tableHeaderCell('CONTACT DETAIL'),
                      _tableHeaderCell('LOCATION'),
                      _tableHeaderCell('STATUS'),
                      _tableHeaderCell('ACTIONS'),
                    ],
                  ),
                  // Data Rows
                  ...paginatedInvites.map((clinic) {
                    return TableRow(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: CustomColors.border),
                        ),
                      ),
                      children: [
                        _clinicNameCell(clinic.name, clinic.logo),
                        _clinicContactCell(clinic.email, clinic.phone, null),
                        _tableTextCell(
                          clinic.address,
                          style: context.fonts.grey14w400,
                        ),
                        _invitationStatusBadgeCell(clinic.invitationStatus),
                        _inviteActionsCell(clinic),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
        if (totalPages > 1)
          Padding(
            padding: context.appEdgeInsets(vertical: 24),
            child: Center(
              child: NumberPaginator(
                totalPages: totalPages,
                currentPage: _invitePage,
                onPageChanged: (pageIndex) {
                  setState(() {
                    _invitePage = pageIndex;
                  });
                },
              ),
            ),
          ),
      ],
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

  Widget _clinicNameCell(String? name, String? logo) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundColor: CustomColors.palePurple,
            backgroundImage: (logo != null && logo.isNotEmpty)
                ? NetworkImage(logo)
                : null,
            child: (logo == null || logo.isEmpty)
                ? Text(name?[0] ?? 'C', style: context.fonts.purple12w700)
                : null,
          ),
          context.horizontalSpace(12),
          Expanded(
            child: Text(
              name ?? 'N/A',
              style: context.fonts.black14w600,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _clinicContactCell(String? email, String? phone, String? address) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            email ?? 'N/A',
            style: context.fonts.grey13w500,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (phone != null && phone.isNotEmpty) ...[
            context.verticalSpace(2),
            Text(phone, style: context.fonts.grey12w400),
          ],
          if (address != null && address.isNotEmpty) ...[
            context.verticalSpace(2),
            Text(
              address,
              style: context.fonts.grey11w400,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
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
    final bool isActive = status.toLowerCase() == 'active';
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: isActive
                ? CustomColors.green.withValues(alpha: 0.1)
                : CustomColors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isActive
                  ? CustomColors.green.withValues(alpha: 0.2)
                  : CustomColors.red.withValues(alpha: 0.2),
            ),
          ),
          child: Text(
            status,
            style: context.fonts.grey12w600.copyWith(
              color: isActive ? CustomColors.green : CustomColors.red,
              fontSize: 10.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _invitationStatusBadgeCell(String status) {
    Color badgeColor = Colors.blue;
    final String cleanStatus = status.toLowerCase();

    if (cleanStatus.contains('sent') ||
        cleanStatus.contains('invited') ||
        cleanStatus.contains('awaiting')) {
      badgeColor = Colors.blue;
    } else if (cleanStatus.contains('interested') ||
        cleanStatus.contains('pending')) {
      badgeColor = CustomColors.green;
    } else if (cleanStatus.contains('expired')) {
      badgeColor = CustomColors.red;
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

  Widget _activeActionsCell(ClinicModel clinic) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          IconButton(
            tooltip: 'View Details',
            icon: Icon(
              Icons.visibility_outlined,
              size: 20.sp,
              color: CustomColors.grey,
            ),
            onPressed: () {
              ref.read(clinicViewModelProvider.notifier).selectClinic(clinic);
              context.push(ClinicDetailScreen.routeName);
            },
          ),
          IconButton(
            tooltip: 'Edit Partner',
            icon: Icon(
              Icons.edit_road_rounded,
              size: 20.sp,
              color: CustomColors.purple,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => EditClinicDialogBox(clinic: clinic),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _inviteActionsCell(InviteClinicModel clinic) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          IconButton(
            tooltip: 'View Prospect',
            icon: Icon(
              Icons.visibility_outlined,
              size: 20.sp,
              color: CustomColors.grey,
            ),
            onPressed: () {
              ref
                  .read(clinicViewModelProvider.notifier)
                  .selectInviteClinic(clinic);
              context.push(InviteClinicDetailScreen.routeName);
            },
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
              child: Icon(
                Icons.search_off_rounded,
                size: context.sp(48),
                color: CustomColors.grey,
              ),
            ),
            context.verticalSpace(24),
            Text(
              'No clinics match your refinements',
              style: context.fonts.black18w600,
            ),
            context.verticalSpace(8),
            Text(
              'Try clearing your search keyword, resetting the filters, or onboard a brand new clinic partner.',
              style: context.fonts.grey14w400,
              textAlign: TextAlign.center,
            ),
            context.verticalSpace(24),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomOutlinedButton(
                  onTap: () {
                    _searchController.clear();
                    setState(() {
                      _selectedRegionFilter = 'All Regions';
                      _selectedPlanFilter = 'All Plans';
                      _selectedStatusFilter = 'All Statuses';
                    });
                  },
                  label: 'Clear All Filters',
                  color: Colors.white,
                  textColor: CustomColors.purple,
                ),
                context.horizontalSpace(16),
                CustomPrimaryButton(
                  onTap: () => context.push(AddNewClinicScreen.routeName),
                  icon: Icons.add_rounded,
                  label: 'Add Clinic',
                  width: context.w(180),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
