import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/responses/patient_list_response.dart';
import '../../utils/enums.dart';
import '../../utils/responsive.dart';
import '../../utils/theme.dart';
import '../../view_models/patient_view_model.dart';
import '../../widgets/borderd_container_widget.dart';
import '../../widgets/custom_dropdown_widget.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_primary_button.dart';
import '../../widgets/gradient_scaffold.dart';
import '../../widgets/mini_stat_card.dart';
import '../../widgets/number_paginator.dart';
import '../../widgets/status_toggle_switch.dart';
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
  PatientStatus _selectedStatusFilter = PatientStatus.all;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(patientProvider.notifier).getPatients(initialCall: true);
    });
  }

  @override
  Widget build(BuildContext context) {
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

  // class _PatientManagementContent extends ConsumerWidget {
  //   const _PatientManagementContent();
  //
  //   @override
  //   Widget build(BuildContext context, WidgetRef ref) {
  //     final patientState = ref.watch(patientProvider);
  //
  //     return
  //   }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Patient Database', style: context.fonts.level1Heading),
                  context.verticalSpace(6),
                  Text(
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

  Widget _buildQuickInsights(BuildContext context, PatientState state) {
    return AdaptiveLayoutRowColumn(
      expandedWidget: true,
      crossAlignment: CrossAxisAlignment.start,
      widthBetween: 16,
      heightBetween: 16,
      children: [
        MiniStatCard(
          title: 'Total Patients',
          value: state.totalPatients ?? 0,
          icon: Icons.people_alt_outlined,
          color: CustomColors.purple,
        ),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 2,
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
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: CustomDropdown<PatientStatus>(
              label: 'Status',
              hintText: 'All Statuses',
              value: _selectedStatusFilter,
              items: PatientStatus.values
                  .map(
                    (status) => DropdownMenuItem(
                      value: status,
                      child: Text(status.label),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _selectedStatusFilter = val ?? PatientStatus.all;
                  ref
                      .read(patientProvider.notifier)
                      .getPatients(
                        initialCall: true,
                        showEasyLoading: true,
                        status: val,
                      );
                });
              },
            ),
          ),
        ],
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
                _tableHeaderCell(context, 'STATUS'),
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
                  _statusCell(context, patient, ref),
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

  Widget _statusCell(BuildContext context, PatientData patient, WidgetRef ref) {
    return Padding(
      padding: context.appEdgeInsets(horizontal: 16, vertical: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: StatusToggleSwitch(
          status: patient.status,
          onChanged: (newStatus) {
            if (patient.id != null) {
              ref
                  .read(patientProvider.notifier)
                  .updatePatientStatus(
                    patientId: patient.id!,
                    status: newStatus.toLowerCase(),
                  );
            }
          },
          width: context.w(100),
          height: context.h(45),
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
