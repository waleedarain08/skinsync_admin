// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:skinsync_admin/screens/patient_detail_screen.dart';
// import 'package:skinsync_admin/utils/theme.dart';
// import 'package:skinsync_admin/widgets/app_search_field.dart';
// import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
// import 'package:skinsync_admin/widgets/custom_dropdown_widget.dart';
// import 'package:skinsync_admin/widgets/custom_outlined_button.dart';
// import 'package:skinsync_admin/widgets/custom_primary_button.dart';
// import 'package:skinsync_admin/widgets/gradient_scaffold.dart';
// import 'package:skinsync_admin/widgets/mini_stat_card.dart';
// import 'package:skinsync_admin/widgets/number_paginator.dart';
//
// class PatientDummyModel {
//   final String name;
//   final String email;
//   final String phone;
//   final String clinic;
//   final String lastAppointment;
//   final int totalTreatments;
//   final String status;
//
//   PatientDummyModel({
//     required this.name,
//     required this.email,
//     required this.phone,
//     required this.clinic,
//     required this.lastAppointment,
//     required this.totalTreatments,
//     required this.status,
//   });
// }
//
// class PatientManagement extends ConsumerStatefulWidget {
//   static const String routeName = '/patient-management';
//   const PatientManagement({super.key});
//
//   @override
//   ConsumerState<PatientManagement> createState() => _PatientManagementState();
// }
//
// class _PatientManagementState extends ConsumerState<PatientManagement> {
//   final TextEditingController _searchController = TextEditingController();
//
//   String _selectedClinicFilter = 'All Clinics';
//   String _selectedStatusFilter = 'All Statuses';
//
//   int _currentPage = 0;
//   static const int _itemsPerPage = 5;
//
//   final List<PatientDummyModel> _patients = [
//     PatientDummyModel(
//       name: 'Bessie Cooper',
//       email: 'bessie.c@example.com',
//       phone: '(406) 555-0120',
//       clinic: 'Glow MedSpa NY',
//       lastAppointment: 'Oct 28, 2023',
//       totalTreatments: 12,
//       status: 'Active',
//     ),
//     PatientDummyModel(
//       name: 'Eleanor Pena',
//       email: 'eleanor.pena@example.com',
//       phone: '(206) 555-0154',
//       clinic: 'Glow MedSpa NY',
//       lastAppointment: 'Oct 28, 2023',
//       totalTreatments: 8,
//       status: 'Active',
//     ),
//     PatientDummyModel(
//       name: 'Albert Flores',
//       email: 'albert.f@example.com',
//       phone: '(312) 555-0199',
//       clinic: 'Skinsync LA',
//       lastAppointment: 'Oct 29, 2023',
//       totalTreatments: 5,
//       status: 'New',
//     ),
//     PatientDummyModel(
//       name: 'Jane Cooper',
//       email: 'jane.cooper@example.com',
//       phone: '(212) 555-0143',
//       clinic: 'Aesthetic Chicago',
//       lastAppointment: 'Oct 25, 2023',
//       totalTreatments: 2,
//       status: 'Inactive',
//     ),
//     PatientDummyModel(
//       name: 'Wade Warren',
//       email: 'wade.warren@example.com',
//       phone: '(310) 555-0188',
//       clinic: 'Skinsync LA',
//       lastAppointment: 'Oct 12, 2023',
//       totalTreatments: 1,
//       status: 'Archived',
//     ),
//   ];
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Dynamic real-time filter logic
//     final filteredPatients = _patients.where((p) {
//       final query = _searchController.text.toLowerCase();
//       final matchesQuery =
//           query.isEmpty ||
//           p.name.toLowerCase().contains(query) ||
//           p.email.toLowerCase().contains(query) ||
//           p.phone.contains(query);
//
//       final matchesClinic =
//           _selectedClinicFilter == 'All Clinics' ||
//           p.clinic == _selectedClinicFilter;
//
//       final matchesStatus =
//           _selectedStatusFilter == 'All Statuses' ||
//           p.status == _selectedStatusFilter;
//
//       return matchesQuery && matchesClinic && matchesStatus;
//     }).toList();
//
//     final totalPages = (filteredPatients.length / _itemsPerPage).ceil();
//     final paginatedPatients = filteredPatients
//         .skip(_currentPage * _itemsPerPage)
//         .take(_itemsPerPage)
//         .toList();
//
//     return GradientScaffold(
//       body: SingleChildScrollView(
//         padding: context.appEdgeInsets(horizontal: 28, vertical: 28),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildHeader(context),
//             context.verticalSpace(32),
//             _buildQuickMetrics(context),
//             context.verticalSpace(32),
//             _buildFilters(),
//             context.verticalSpace(24),
//             _buildPatientsTable(paginatedPatients),
//             if (totalPages > 1)
//               Padding(
//                 padding: context.appEdgeInsets(vertical: 24),
//                 child: Center(
//                   child: NumberPaginator(
//                     totalPages: totalPages,
//                     currentPage: _currentPage,
//                     onPageChanged: (pageIndex) {
//                       setState(() {
//                         _currentPage = pageIndex;
//                       });
//                     },
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Client Database', style: context.fonts.level1Heading),
//             context.verticalSpace(6),
//             Text(
//               'Unified view of all patients across your clinic network.',
//               style: context.fonts.grey13w500,
//             ),
//           ],
//         ),
//         CustomPrimaryButton(
//           onTap: () {},
//           icon: Icons.file_download_outlined,
//           label: 'Export Registry',
//           width: context.w(180),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildQuickMetrics(BuildContext context) {
//     return Row(
//       children: [
//         const MiniStatCard(
//           title: 'Total Patients',
//           value: 12840,
//           icon: Icons.people_rounded,
//           color: CustomColors.purple,
//         ),
//         context.horizontalSpace(16),
//         const MiniStatCard(
//           title: 'Verified Profiles',
//           value: 8200,
//           icon: Icons.verified_user_rounded,
//           color: CustomColors.green,
//         ),
//         context.horizontalSpace(16),
//         const MiniStatCard(
//           title: 'App Users',
//           value: 9450,
//           icon: Icons.smartphone_rounded,
//           color: CustomColors.green,
//         ),
//         context.horizontalSpace(16),
//         const MiniStatCard(
//           title: 'Active Network',
//           value: 3390,
//           icon: Icons.hub_rounded,
//           color: CustomColors.purple,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildFilters() {
//     return BorderdContainerWidget(
//       padding: EdgeInsets.all(16.w),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Expanded(
//             flex: 3,
//             child: AppSearchField(
//               controller: _searchController,
//               hintText: 'Search patients by name, email or phone...',
//               onChanged: (val) {
//                 setState(() {
//                   _currentPage = 0;
//                 });
//               },
//               onClear: () {
//                 _searchController.clear();
//                 setState(() {
//                   _currentPage = 0;
//                 });
//               },
//             ),
//           ),
//           SizedBox(width: 16.w),
//           Expanded(
//             child: CustomDropdown<String>(
//               label: 'Assigned Clinic',
//               hintText: 'All Clinics',
//               value: _selectedClinicFilter,
//               items: const [
//                 'All Clinics',
//                 'Glow MedSpa NY',
//                 'Skinsync LA',
//                 'Aesthetic Chicago',
//               ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
//               onChanged: (val) {
//                 setState(() {
//                   _selectedClinicFilter = val ?? 'All Clinics';
//                   _currentPage = 0;
//                 });
//               },
//             ),
//           ),
//           SizedBox(width: 12.w),
//           Expanded(
//             child: CustomDropdown<String>(
//               label: 'Status',
//               hintText: 'All Statuses',
//               value: _selectedStatusFilter,
//               items: const [
//                 'All Statuses',
//                 'Active',
//                 'Inactive',
//                 'New',
//                 'Archived',
//               ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
//               onChanged: (val) {
//                 setState(() {
//                   _selectedStatusFilter = val ?? 'All Statuses';
//                   _currentPage = 0;
//                 });
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPatientsTable(List<PatientDummyModel> list) {
//     if (list.isEmpty) {
//       return _buildEmptyState();
//     }
//
//     return BorderdContainerWidget(
//       padding: EdgeInsets.zero,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(12.r),
//         child: Table(
//           columnWidths: const {
//             0: FlexColumnWidth(4), // Patient Name / Email
//             1: FlexColumnWidth(3), // Phone
//             2: FlexColumnWidth(3), // Assigned Clinic
//             3: FlexColumnWidth(3), // Last Appointment
//             4: FlexColumnWidth(2), // Total Treatments
//             5: FlexColumnWidth(2), // Status
//             6: FlexColumnWidth(2), // Actions
//           },
//           defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//           children: [
//             // Header Row
//             TableRow(
//               decoration: const BoxDecoration(
//                 color: CustomColors.whiteGrey,
//                 border: Border(bottom: BorderSide(color: CustomColors.border)),
//               ),
//               children: [
//                 _tableHeaderCell('PATIENT RECORD'),
//                 _tableHeaderCell('PHONE NUMBER'),
//                 _tableHeaderCell('ASSIGNED CLINIC'),
//                 _tableHeaderCell('LAST APPOINTMENT'),
//                 _tableHeaderCell('TREATMENTS'),
//                 _tableHeaderCell('STATUS'),
//                 _tableHeaderCell('ACTIONS'),
//               ],
//             ),
//             // Data Rows
//             ...list.map((p) {
//               return TableRow(
//                 decoration: const BoxDecoration(
//                   border: Border(
//                     bottom: BorderSide(color: CustomColors.border),
//                   ),
//                 ),
//                 children: [
//                   _patientNameCell(p.name, p.email),
//                   _tableTextCell(p.phone, style: context.fonts.grey14w400),
//                   _tableTextCell(p.clinic, style: context.fonts.grey14w400),
//                   _tableTextCell(
//                     p.lastAppointment,
//                     style: context.fonts.black14w600,
//                   ),
//                   _tableTextCell(
//                     '${p.totalTreatments} Proc',
//                     style: context.fonts.grey14w400,
//                   ),
//                   _statusBadgeCell(p.status),
//                   _actionsCell(p),
//                 ],
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _tableHeaderCell(String label) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//       child: Text(
//         label,
//         style: context.fonts.grey12w600.copyWith(letterSpacing: 1),
//       ),
//     );
//   }
//
//   Widget _patientNameCell(String name, String email) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 18.r,
//             backgroundColor: CustomColors.palePurple,
//             child: Text(name[0], style: context.fonts.purple12w700),
//           ),
//           SizedBox(width: 12.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   name,
//                   style: context.fonts.black14w600,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 SizedBox(height: 2.h),
//                 Text(
//                   email,
//                   style: context.fonts.grey11w400,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _tableTextCell(String text, {required TextStyle style}) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//       child: Text(
//         text,
//         style: style,
//         maxLines: 1,
//         overflow: TextOverflow.ellipsis,
//       ),
//     );
//   }
//
//   Widget _statusBadgeCell(String status) {
//     final String cleanStatus = status.toLowerCase();
//     Color badgeColor = CustomColors.green;
//
//     if (cleanStatus == 'archived') {
//       badgeColor = CustomColors.grey;
//     } else if (cleanStatus == 'inactive') {
//       badgeColor = CustomColors.red;
//     } else if (cleanStatus == 'new') {
//       badgeColor = Colors.blue;
//     }
//
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
//             decoration: BoxDecoration(
//               color: badgeColor.withValues(alpha: 0.1),
//               borderRadius: BorderRadius.circular(20.r),
//               border: Border.all(color: badgeColor.withValues(alpha: 0.2)),
//             ),
//             child: Text(
//               status,
//               style: context.fonts.grey12w600.copyWith(
//                 color: badgeColor,
//                 fontSize: 10.sp,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _actionsCell(PatientDummyModel p) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//       child: Row(
//         children: [
//           IconButton(
//             tooltip: 'View Profile',
//             icon: Icon(
//               Icons.visibility_outlined,
//               color: CustomColors.grey,
//               size: 20.sp,
//             ),
//             onPressed: () {
//               ref.read(selectedPatientProvider.notifier).state = p;
//               context.push(PatientDetailScreen.routeName);
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return BorderdContainerWidget(
//       padding: context.appEdgeInsets(all: 48),
//       child: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               padding: context.appEdgeInsets(all: 20),
//               decoration: const BoxDecoration(
//                 color: CustomColors.whiteGrey,
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.search_off_rounded,
//                 size: context.sp(48),
//                 color: CustomColors.grey,
//               ),
//             ),
//             context.verticalSpace(24),
//             Text(
//               'No patients match your filters',
//               style: context.fonts.black18w600,
//             ),
//             context.verticalSpace(8),
//             Text(
//               'Try clearing your search keyword, resetting the filters, or onboard a new client.',
//               style: context.fonts.grey14w400,
//               textAlign: TextAlign.center,
//             ),
//             context.verticalSpace(24),
//             CustomOutlinedButton(
//               onTap: () {
//                 _searchController.clear();
//                 setState(() {
//                   _selectedClinicFilter = 'All Clinics';
//                   _selectedStatusFilter = 'All Statuses';
//                 });
//               },
//               label: 'Clear All Filters',
//               color: Colors.white,
//               textColor: CustomColors.purple,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/responses/patient_list_response.dart';
import '../../utils/responsive.dart';
import '../../utils/theme.dart';
import '../../view_models/patient_view_model.dart';
import '../../widgets/borderd_container_widget.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_primary_button.dart';
import '../../widgets/gradient_scaffold.dart';
import '../../widgets/mini_stat_card.dart';
import '../../widgets/number_paginator.dart';
import '../patient_detail_screen.dart';

class PatientManagementScreen extends ConsumerStatefulWidget {
  static const String routeName = '/patient-management';

  const PatientManagementScreen({super.key});

  @override
  ConsumerState<PatientManagementScreen> createState() =>
      _PatientManagementScreenState();
}

class _PatientManagementScreenState
    extends ConsumerState<PatientManagementScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(patientProvider.notifier).getPatients(initialCall: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const _PatientManagementContent();
  }
}

class _PatientManagementContent extends ConsumerWidget {
  const _PatientManagementContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientState = ref.watch(patientProvider);

    return GradientScaffold(
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 28, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            context.verticalSpace(32),

            _buildQuickInsights(context, patientState),

            context.verticalSpace(32),

            _buildFilters(context, ref, patientState),

            context.verticalSpace(24),

            if (patientState.loading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(60),
                  child: CircularProgressIndicator(),
                ),
              )
            else
              _buildPatientsTable(context, ref, patientState.patients),

            context.verticalSpace(24),

            _buildFooterPaginator(context, ref, patientState),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Patient Database', style: context.fonts.level1Heading),
                  context.verticalSpace(6),
                  Text(
                    // 'Manage clinic active patient directory, medical histories, and active treatment journeys.',
                    'Unified view of all patients across your clinic network.',
                    style: context.fonts.grey13w500,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              CustomPrimaryButton(
                onTap: () {},
                icon: Icons.file_download_outlined,
                label: 'Export Registry',
                width: context.w(180),
              ),
            ],
          ),
        ),
      ],
    );
  }
  // Widget _buildHeader(BuildContext context) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text('Patient Database', style: context.fonts.black26w700),
  //           context.verticalSpace(6),
  //           Text(
  //             'Manage clinic active patient directory, medical histories, and active treatment journeys.',
  //             style: context.fonts.grey13w500,
  //             maxLines: 2,
  //           ),
  //         ],
  //       ),
  //
  //       // CustomPrimaryButton(
  //       //   onTap: () {
  //       //     ScaffoldMessenger.of(context).showSnackBar(
  //       //       const SnackBar(
  //       //         content: Text('Add Patient Form initialization...'),
  //       //       ),
  //       //     );
  //       //   },
  //       //   icon: Icons.add_rounded,
  //       //   label: 'Add New Patient',
  //       //   width: context.w(180),
  //       // ),
  //     ],
  //   );
  // }

  Widget _buildQuickInsights(BuildContext context, PatientState state) {
    return AdaptiveLayoutRowColumn(
      expandedWidget: true,
      crossAlignment: .start,
      widthBetween: 16,
      heightBetween: 16,
      children: [
        MiniStatCard(
          title: 'Total Patients',
          value: state.totalPatients ?? 0,
          icon: Icons.people_alt_outlined,
          color: CustomColors.purple,
        ),

        // context.horizontalSpace(16),
        MiniStatCard(
          title: 'Total Request',
          value: state.totalRequest ?? 0,
          icon: Icons.face_retouching_natural_rounded,
          color: CustomColors.blue,
        ),
      ],
    );
  }

  Widget _buildFilters(
    BuildContext context,
    WidgetRef ref,
    PatientState state,
  ) {
    final controller = ref.read(patientProvider.notifier).searchController;

    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 16),
      child: TextFormField(
        controller: controller,
        style: context.fonts.black14w400,
        decoration: AppDecorations.input(
          context,
          hint: 'Search patients by name, email, or phone number...',
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: CustomColors.grey,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: CustomColors.grey),
                  onPressed: () {
                    controller.clear();

                    ref
                        .read(patientProvider.notifier)
                        .getPatients(initialCall: true);
                  },
                )
              : null,
        ),
        onFieldSubmitted: (_) {
          ref
              .read(patientProvider.notifier)
              .getPatients(initialCall: true, showEasyLoading: true);
        },
      ),
    );
  }

  Widget _buildPatientsTable(
    BuildContext context,
    WidgetRef ref,
    List<PatientData> patients,
  ) {
    if (patients.isEmpty) {
      return _buildEmptyState(context, ref);
    }

    return BorderdContainerWidget(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.r(12)),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(3.5),
            1: FlexColumnWidth(3.5),
            2: FlexColumnWidth(2.5),
            3: FlexColumnWidth(2),
            4: FlexColumnWidth(2),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              decoration: const BoxDecoration(
                color: CustomColors.whiteGrey,
                border: Border(bottom: BorderSide(color: CustomColors.border)),
              ),
              children: [
                _tableHeaderCell(context, 'PATIENT NAME'),
                _tableHeaderCell(context, 'EMAIL'),
                _tableHeaderCell(context, 'PHONE NUMBER'),
                _tableHeaderCell(context, 'TOTAL REQUEST'),
                _tableHeaderCell(context, 'ACTIONS'),
              ],
            ),

            ...patients.map(
              (patient) => TableRow(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: CustomColors.border),
                  ),
                ),
                children: [
                  _patientNameCell(context, patient),

                  _tableTextCell(
                    context,
                    patient.email ?? 'N/A',
                    style: context.fonts.grey14w400,
                  ),

                  _tableTextCell(
                    context,
                    patient.phoneNumber ?? 'N/A',
                    style: context.fonts.grey14w400,
                  ),
                  _tableTextCell(
                    context,
                    '${patient.requestCount ?? 0}',
                    style: context.fonts.grey14w600,
                  ),

                  _actionsCell(context, patient),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tableHeaderCell(BuildContext context, String label) {
    return Padding(
      padding: context.appEdgeInsets(horizontal: 16, vertical: 16),
      child: Text(
        label,
        style: context.fonts.grey12w600.copyWith(letterSpacing: 1),
      ),
    );
  }

  Widget _patientNameCell(BuildContext context, PatientData patient) {
    return Padding(
      padding: context.appEdgeInsets(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: context.r(21),
            backgroundColor: CustomColors.softGrey,
            backgroundImage: patient.image != null && patient.image!.isNotEmpty
                ? NetworkImage(patient.image!)
                : null,
            child: patient.image == null || patient.image!.isEmpty
                ? const Icon(Icons.person, color: CustomColors.grey, size: 20)
                : null,
          ),

          context.horizontalSpace(16),

          Expanded(
            child: Text(
              patient.patientName ?? 'N/A',
              style: context.fonts.black14w600,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableTextCell(
    BuildContext context,
    String text, {
    required TextStyle style,
  }) {
    return Padding(
      padding: context.appEdgeInsets(horizontal: 16, vertical: 16),
      child: Text(
        text,
        style: style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  // Widget _statusBadgeCell(BuildContext context) {
  //   const badgeColor = CustomColors.green;

  //   return Padding(
  //     padding: context.appEdgeInsets(horizontal: 16, vertical: 16),
  //     child: Container(
  //       padding: context.appEdgeInsets(horizontal: 10, vertical: 6),
  //       decoration: BoxDecoration(
  //         color: badgeColor.withValues(alpha: 0.1),
  //         borderRadius: context.appBorderRadius(all: 20),
  //         border: Border.all(color: badgeColor.withValues(alpha: 0.2)),
  //       ),
  //       child: Text(
  //         'Active',
  //         style: context.fonts.grey12w600.copyWith(
  //           color: badgeColor,
  //           fontSize: context.sp(10),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _actionsCell(BuildContext context, PatientData patient) {
    return Padding(
      padding: context.appEdgeInsets(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Consumer(
            builder: (context, ref, _) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'View Patient Details',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(
                      Icons.visibility_outlined,
                      color: CustomColors.grey,
                      size: 20,
                    ),
                    onPressed: () async {
                      if (patient.id == null) return;

                      final success = await ref
                          .read(patientProvider.notifier)
                          .getPatientDetail(patientId: patient.id!);

                      if (success && context.mounted) {
                        context.push(
                          PatientManagementDetailScreen.routeName,
                          extra: patient.id,
                        );
                      }
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
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
              child: const Icon(
                Icons.search_off_rounded,
                size: 48,
                color: CustomColors.grey,
              ),
            ),

            context.verticalSpace(24),

            Text('No patients found', style: context.fonts.black18w600),

            context.verticalSpace(8),

            Text(
              'Try clearing your search keyword or search for another patient.',
              style: context.fonts.grey14w400,
              textAlign: TextAlign.center,
            ),

            context.verticalSpace(24),

            CustomOutlinedButton(
              onTap: () {
                final controller = ref
                    .read(patientProvider.notifier)
                    .searchController;

                controller.clear();

                ref
                    .read(patientProvider.notifier)
                    .getPatients(initialCall: true);
              },
              label: 'Clear Search',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterPaginator(
    BuildContext context,
    WidgetRef ref,
    PatientState state,
  ) {
    final totalPages = state.totalPage ?? 1;

    return Center(
      child: NumberPaginator(
        totalPages: totalPages < 1 ? 1 : totalPages,
        currentPage: (state.page - 1).clamp(
          0,
          totalPages > 0 ? totalPages - 1 : 0,
        ),
        onPageChanged: (pageIndex) {
          ref.read(patientProvider.notifier).setPageNumber(pageIndex + 1);
        },
      ),
    );
  }
}
