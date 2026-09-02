import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../utils/theme.dart';
import '../../view_models/patient_view_model.dart';
import '../../view_models/treatment_view_model.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/gradient_scaffold.dart';
import '../../widgets/patient_treatment_request.widget.dart';

import 'treatment_detail_screen.dart';

class SharedTreatmentRequestScreen extends ConsumerStatefulWidget {
  static const String routeName = '/shared-treatmnet-request-screen';
  final int? patientId;
  final int? clinicId;
  final bool showBackButton;
  const SharedTreatmentRequestScreen({
    super.key,
    this.patientId,
    this.clinicId,
    this.showBackButton = false,
  });

  @override
  ConsumerState<SharedTreatmentRequestScreen> createState() =>
      _SharedTreatmentRequestScreenState();
}

class _SharedTreatmentRequestScreenState
    extends ConsumerState<SharedTreatmentRequestScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(patientProvider.notifier)
          .getPatientTreatmentRequests(
            initialCall: true,
            patientId: widget.patientId,
            clinicId: widget.clinicId,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final patientState = ref.watch(patientProvider);

    return GradientScaffold(
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            context.verticalSpace(32),

            _buildTreatmentRequestsSection(context, patientState),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showBackButton) ...[
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: CustomColors.black,
            ),
            onPressed: () => context.pop(),
          ),
          context.horizontalSpace(10),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shared Treatment Requests',
                style: context.fonts.level1Heading,
              ),
              context.verticalSpace(6),
              Text(
                'Review and manage treatment requests shared between clinics for coordinated patient care.',
                style: context.fonts.grey13w500,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTreatmentRequestsSection(
    BuildContext context,
    PatientState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.treatmentLoading)
          SizedBox(
            width: 16.w,
            height: 16.w,
            child: const Center(child: AppLoader()),
          ),
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
    );
  }

Widget _buildPagination(BuildContext context, PatientState state) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton(
        onPressed: state.treatmentPage > 1
            ? () => ref.read(patientProvider.notifier).setTreatmentPageNumber(
                  state.treatmentPage - 1,
                  patientId: widget.patientId,
                  clinicId: widget.clinicId,
                )
            : null,
        icon: const Icon(Icons.arrow_back_ios, size: 16),
      ),
      Text(
        'Page ${state.treatmentPage} of ${state.treatmentTotalPage}',
        style: context.fonts.black14w600,
      ),
      IconButton(
        onPressed: state.treatmentPage < (state.treatmentTotalPage ?? 1)
            ? () => ref.read(patientProvider.notifier).setTreatmentPageNumber(
                  state.treatmentPage + 1,
                  patientId: widget.patientId,
                  clinicId: widget.clinicId,
                )
            : null,
        icon: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    ],
  );
}
}
