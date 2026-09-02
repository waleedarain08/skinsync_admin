// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:skinsync_admin/screens/bottom_nav_screens/patient_management.dart';
// import 'package:skinsync_admin/utils/theme.dart';
// import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
// import 'package:skinsync_admin/widgets/gradient_scaffold.dart';
//
// class SelectedPatientNotifier extends Notifier<PatientDummyModel?> {
//   @override
//   PatientDummyModel? build() => null;
//   void set(PatientDummyModel? p) => state = p;
// }
//
// final selectedPatientProvider =
//     NotifierProvider<SelectedPatientNotifier, PatientDummyModel?>(
//       SelectedPatientNotifier.new,
//     );
//
// class PatientDetailScreen extends ConsumerWidget {
//   static const String routeName = '/patient-detail';
//   const PatientDetailScreen({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final patient = ref.watch(selectedPatientProvider);
//
//     if (patient == null) {
//       return GradientScaffold(
//         body: Center(
//           child: Text(
//             'No Patient Data Found',
//             style: context.fonts.black16w400,
//           ),
//         ),
//       );
//     }
//
//     return GradientScaffold(
//       appBar: AppBar(
//         flexibleSpace: AppDecorations.appBarGradient,
//         title: Text('Patient Profile', style: context.fonts.black18w600),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: CustomColors.black),
//           onPressed: () => context.pop(),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: context.appEdgeInsets(horizontal: 24, vertical: 32),
//         child: Center(
//           child: ConstrainedBox(
//             constraints: BoxConstraints(maxWidth: context.w(1000)),
//             child: Column(
//               children: [
//                 _buildHeaderSection(context, patient),
//                 context.verticalSpace(32),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       flex: 3,
//                       child: _buildMainContent(context, patient),
//                     ),
//                     context.horizontalSpace(32),
//                     Expanded(flex: 2, child: _buildSidebar(context, patient)),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeaderSection(BuildContext context, PatientDummyModel p) {
//     return BorderdContainerWidget(
//       padding: context.appEdgeInsets(all: 32),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 40.r,
//             backgroundColor: CustomColors.palePurple,
//             child: Text(p.name[0], style: context.fonts.purple16w700),
//           ),
//           context.horizontalSpace(32),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Flexible(
//                       child: Text(
//                         p.name,
//                         style: context.fonts.level2Heading,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     context.horizontalSpace(16),
//                     _statusBadge(context, p.status),
//                   ],
//                 ),
//                 context.verticalSpace(8),
//                 Text(p.email, style: context.fonts.purple14w600),
//                 context.verticalSpace(16),
//                 Wrap(
//                   spacing: 12.w,
//                   runSpacing: 12.h,
//                   children: [
//                     _infoChip(context, Icons.phone_android_rounded, p.phone),
//                     _infoChip(
//                       context,
//                       Icons.home_work_outlined,
//                       'Home Clinic: ${p.clinic}',
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMainContent(BuildContext context, PatientDummyModel p) {
//     return Column(
//       children: [
//         _infoSection(context, 'Personal & Account Information', [
//           _detailRow(context, 'Full Legal Name', p.name),
//           _detailRow(context, 'Contact Email', p.email),
//           _detailRow(context, 'Assigned Home Clinic', p.clinic),
//           _detailRow(context, 'Primary Phone Contact', p.phone),
//         ]),
//         context.verticalSpace(24),
//         _infoSection(context, 'Clinical Medical Summary', [
//           _detailRow(
//             context,
//             'Fitzpatrick Skin Type',
//             'Type II (Fair, burning easily)',
//           ),
//           _detailRow(
//             context,
//             'Contradictions & Allergies',
//             'No known medical contradictions or severe drug allergies reported.',
//           ),
//           _detailRow(
//             context,
//             'Clinical Directives',
//             'Maintain skin barrier review; avoid highly aggressive laser energy profiles on active dry patches.',
//           ),
//         ]),
//         context.verticalSpace(24),
//         _infoSection(context, 'Clinical Treatments History', [
//           _historyRow(
//             context,
//             'Oct 28, 2023',
//             'Laser Resurfacing',
//             'Completed successfully; mild transient redness post-procedure.',
//           ),
//           context.verticalSpace(16),
//           _historyRow(
//             context,
//             'Sep 15, 2023',
//             'HydraFacial Signature Session',
//             'Completed; excellent skin hydration response observed.',
//           ),
//         ]),
//       ],
//     );
//   }
//
//   Widget _buildSidebar(BuildContext context, PatientDummyModel p) {
//     return Column(
//       children: [
//         _infoSection(context, 'Patient Metrics', [
//           _statRow(
//             context,
//             Icons.history_edu_rounded,
//             'Total Procedures',
//             '${p.totalTreatments} sessions',
//           ),
//           _statRow(
//             context,
//             Icons.calendar_today_outlined,
//             'Last Visited',
//             p.lastAppointment,
//           ),
//           _statRow(
//             context,
//             Icons.payments_outlined,
//             'Total Lifetime Value',
//             '\$1,850.00',
//           ),
//         ]),
//         context.verticalSpace(24),
//         _infoSection(context, 'Activity Tracking Log', [
//           _timelineStep(
//             context,
//             'Oct 28, 2023',
//             'Procedure Logged',
//             'Laser Resurfacing protocol registered under Glow MedSpa NY.',
//           ),
//           context.verticalSpace(16),
//           _timelineStep(
//             context,
//             'Sep 15, 2023',
//             'Onboarded Partner Network',
//             'Created patient profile from official Client Portal app gateway.',
//           ),
//         ]),
//       ],
//     );
//   }
//
//   Widget _historyRow(
//     BuildContext context,
//     String date,
//     String treatment,
//     String notes,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(treatment, style: context.fonts.black14w600),
//             Text(date, style: context.fonts.grey11w400),
//           ],
//         ),
//         context.verticalSpace(4),
//         Text(notes, style: context.fonts.grey12w400),
//       ],
//     );
//   }
//
//   Widget _timelineStep(
//     BuildContext context,
//     String date,
//     String title,
//     String desc,
//   ) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(
//           Icons.check_circle_rounded,
//           color: CustomColors.green,
//           size: context.sp(16),
//         ),
//         context.horizontalSpace(12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(title, style: context.fonts.black14w600),
//               context.verticalSpace(2),
//               Text(date, style: context.fonts.grey11w400),
//               context.verticalSpace(4),
//               Text(desc, style: context.fonts.grey12w400),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _infoSection(
//     BuildContext context,
//     String title,
//     List<Widget> children,
//   ) {
//     return BorderdContainerWidget(
//       padding: context.appEdgeInsets(all: 24),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title, style: context.fonts.black16w700),
//           context.verticalSpace(24),
//           ...children,
//         ],
//       ),
//     );
//   }
//
//   Widget _detailRow(BuildContext context, String label, String value) {
//     return Padding(
//       padding: context.appEdgeInsets(bottom: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: context.fonts.grey13w500),
//           context.verticalSpace(4),
//           Text(value, style: context.fonts.black14w600),
//         ],
//       ),
//     );
//   }
//
//   Widget _statRow(
//     BuildContext context,
//     IconData icon,
//     String label,
//     String value,
//   ) {
//     return Padding(
//       padding: context.appEdgeInsets(bottom: 16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               Icon(icon, size: context.sp(18), color: CustomColors.grey),
//               context.horizontalSpace(12),
//               Text(label, style: context.fonts.grey13w500),
//             ],
//           ),
//           Flexible(
//             child: Text(
//               value,
//               style: context.fonts.grey14w600,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _statusBadge(BuildContext context, String status) {
//     final bool isActive =
//         status.toLowerCase() == 'active' || status.toLowerCase() == 'new';
//     return Container(
//       padding: context.appEdgeInsets(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: isActive
//             ? CustomColors.green.withValues(alpha: 0.1)
//             : CustomColors.grey.withValues(alpha: 0.1),
//         borderRadius: BorderRadius.circular(20.r),
//       ),
//       child: Text(
//         status.toUpperCase(),
//         style: isActive
//             ? context.fonts.green10w700
//             : context.fonts.grey11w400.copyWith(fontWeight: FontWeight.bold),
//       ),
//     );
//   }
//
//   Widget _infoChip(BuildContext context, IconData icon, String label) {
//     return Container(
//       padding: context.appEdgeInsets(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: CustomColors.whiteGrey,
//         borderRadius: BorderRadius.circular(8.r),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: context.sp(14), color: CustomColors.grey),
//           context.horizontalSpace(8),
//           Text(label, style: context.fonts.grey13w500),
//         ],
//       ),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/screens/shared_treatment_request_screen.dart';
import '../../models/responses/patient_detail_response.dart';
import '../../utils/theme.dart';
import '../../utils/string_utils.dart';
import '../../view_models/patient_view_model.dart';
import '../../view_models/treatment_view_model.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/borderd_container_widget.dart';
import '../../widgets/gradient_scaffold.dart';
import '../widgets/patient_treatment_request.widget.dart';
import '../widgets/status_toggle_switch.dart';
import 'bottom_nav_screens/patient_management.dart';
import 'treatment_detail_screen.dart';

class PatientManagementDetailScreen extends ConsumerStatefulWidget {
  static const String path = 'details';
  static const String routeName =
      '${PatientManagementScreen.routeName}/details';
  final int? patientId;
  const PatientManagementDetailScreen({super.key, this.patientId});

  @override
  ConsumerState<PatientManagementDetailScreen> createState() =>
      _PatientManagementDetailScreenState();
}

class _PatientManagementDetailScreenState
    extends ConsumerState<PatientManagementDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(patientProvider.notifier)
          .getPatientTreatmentRequests(
            initialCall: true,
            patientId: widget.patientId,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final patientState = ref.watch(patientProvider);
    final patient = patientState.patientDetail;
    if (patient == null) {
      return const GradientScaffold(body: Center(child: AppLoader()));
    }

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        elevation: 0,
        centerTitle: true,
        title: Text('Patient Details', style: context.fonts.black18w600),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: CustomColors.black,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(context, patient),
            context.verticalSpace(24),
            _buildInfoSection(context, patient),
            context.verticalSpace(24),
            //    _buildTreatmentRequestsSection(context, patientState),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, PatientDetailData p) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      backgroundColor: CustomColors.white,
      child: Row(
        mainAxisAlignment: .spaceBetween,
        crossAxisAlignment: .end,
        children: [
          Row(
            children: [
              _buildAvatar(context, p.image, 40),
              context.horizontalSpace(24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.patientName.capitalize,
                    style: context.fonts.level2Heading,
                  ),
                  context.verticalSpace(4),
                  Container(
                    padding: context.appEdgeInsets(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: CustomColors.purple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(context.r(20)),
                    ),
                    child: Text(
                      'Active Patient',
                      style: context.fonts.purple12w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          _statusCell(context, p, ref),
        ],
      ),
    );
  }

  Widget _statusCell(
    BuildContext context,
    PatientDetailData patient,
    WidgetRef ref,
  ) {
    return Padding(
      padding: context.appEdgeInsets(horizontal: 16, vertical: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: StatusToggleSwitch(
          status: patient.status,
          onChanged: (newStatus) {
            ref
                .read(patientProvider.notifier)
                .updatePatientStatus(
                  patientId: patient.id,
                  status: newStatus.toLowerCase(),
                );
          },
          width: context.w(100),
          height: context.h(45),
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, PatientDetailData p) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      backgroundColor: CustomColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Contact Information', style: context.fonts.subHeading),
              OutlinedButton.icon(
                onPressed: () {
                  context.pushNamed(
                    SharedTreatmentRequestScreen.routeName,
                    queryParameters: {
                      'patientId': p.id.toString(),
                      'showBackButton': 'true',
                    },
                  );
                },
                icon: const Icon(
                  Icons.list_alt_rounded,
                  color: CustomColors.purple,
                ),
                label: Text(
                  'View Requested Treatments',
                  style: context.fonts.purple14w600,
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(0, 52.h),
                  side: const BorderSide(color: CustomColors.purple),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ],
          ),
          const Divider(color: CustomColors.border, height: 32),
          _infoRow(context, Icons.email_outlined, 'Email Address', p.email),
          if (p.phoneNumber != '')
            _infoRow(
              context,
              Icons.phone_outlined,
              'Phone Number',
              p.phoneNumber,
            ),
        ],
      ),
    );
  }

  Widget _buildTreatmentRequestsSection(
    BuildContext context,
    PatientState state,
  ) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      backgroundColor: CustomColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Treatment Requests', style: context.fonts.subHeading),
              if (state.treatmentLoading)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          const Divider(color: CustomColors.border, height: 32),
          if (state.treatmentRequests.isEmpty && !state.treatmentLoading)
            Padding(
              padding: context.appEdgeInsets(vertical: 20),
              child: Center(
                child: Text(
                  'No treatment requests found',
                  style: context.fonts.grey14w400,
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.treatmentRequests.length,
              itemBuilder: (context, index) {
                final request = state.treatmentRequests[index];
                return SimulationTreatmentRequestCard(
                  request: request,
                  onTreatmentTap: (treatmentId) async {
                    await ref
                        .read(treatmentViewModelProvider.notifier)
                        .fetchTreatmentDetail(treatmentId);
                    if (mounted) {
                      await context.push(TreatmentDetailScreen.routeName);
                    }
                  },
                );
              },
            ),
          if (state.treatmentTotalPage != null &&
              state.treatmentTotalPage! > 1) ...[
            context.verticalSpace(24),
            _buildPagination(context, state),
          ],
        ],
      ),
    );
  }

  Widget _buildPagination(BuildContext context, PatientState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: state.treatmentPage > 1
              ? () => ref
                    .read(patientProvider.notifier)
                    .setTreatmentPageNumber(state.treatmentPage - 1)
              : null,
          icon: const Icon(Icons.arrow_back_ios, size: 16),
        ),
        Text(
          'Page ${state.treatmentPage} of ${state.treatmentTotalPage}',
          style: context.fonts.black14w600,
        ),
        IconButton(
          onPressed: state.treatmentPage < (state.treatmentTotalPage ?? 1)
              ? () => ref
                    .read(patientProvider.notifier)
                    .setTreatmentPageNumber(state.treatmentPage + 1)
              : null,
          icon: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ],
    );
  }

  Widget _infoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.h(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: CustomColors.purple),
          context.horizontalSpace(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: context.fonts.grey12w400),
                context.verticalSpace(4),
                Text(value, style: context.fonts.black14w600, softWrap: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, String? imageUrl, double radius) {
    return ClipOval(
      child: imageUrl != null && imageUrl.isNotEmpty
          ? (imageUrl.startsWith('http')
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    height: context.r(radius * 2),
                    width: context.r(radius * 2),
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        _buildDefaultAvatar(context, radius),
                  )
                : Image.asset(
                    imageUrl,
                    height: context.r(radius * 2),
                    width: context.r(radius * 2),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildDefaultAvatar(context, radius),
                  ))
          : _buildDefaultAvatar(context, radius),
    );
  }

  Widget _buildDefaultAvatar(BuildContext context, double radius) {
    return CircleAvatar(
      radius: context.r(radius),
      backgroundColor: CustomColors.softGrey,
      child: Icon(
        Icons.person,
        size: context.r(radius),
        color: CustomColors.grey,
      ),
    );
  }
}
