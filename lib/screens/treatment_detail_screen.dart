import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/responses/treatment_detail_response.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/widgets/app_network_image.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/dailogbox/basic_info_dialog.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';
import 'package:skinsync_admin/widgets/status_toggle_switch.dart';
import 'package:skinsync_admin/widgets/treatment_session_expansion_tile.dart';

class TreatmentDetailScreen extends ConsumerWidget {
  const TreatmentDetailScreen({super.key});
  static const String routeName = '/treatment-detail';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(treatmentViewModelProvider);
    final detail = state.selectedTreatmentDetail;

    if (state.loading) {
      return Scaffold(
        appBar: AppBar(
          flexibleSpace: AppDecorations.appBarGradient,
          title: const Text('Loading Details...'),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(color: CustomColors.purple),
        ),
      );
    }

    if (detail == null) {
      return Scaffold(
        appBar: AppBar(
          flexibleSpace: AppDecorations.appBarGradient,
          title: const Text('Treatment Details'),
          centerTitle: true,
        ),
        body: const Center(child: Text('No treatment details found (N/A)')),
      );
    }

    final status = detail.status ?? 'Draft';
    final statusColor = status.toLowerCase() == 'active'
        ? CustomColors.green
        : (status.toLowerCase() == 'draft'
              ? CustomColors.amber
              : CustomColors.red);

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        title: Text(
          detail.patientDisplayName ?? 'Treatment Details',
          style: context.fonts.black18w600,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 24, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.w(1100)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Hero Banner & Profile Card
                _buildHeroBannerCard(context, detail, status, statusColor),
                context.verticalSpace(24),

                // Main 2-Column Desktop Grid
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column (Description, Categories, Selected Areas & Nested Sessions)
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDescriptionCard(context, detail),
                          context.verticalSpace(24),
                          _buildCategoriesSection(context, detail),
                          context.verticalSpace(24),
                          _buildAreasWithSessionsSection(context, detail),
                        ],
                      ),
                    ),
                    context.horizontalSpace(24),
                    // Right Column (Quick Stats / Business Logic)
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBusinessLogicCard(context, detail),
                          context.verticalSpace(24),
                          _buildMetadataCard(context, detail),
                        ],
                      ),
                    ),
                  ],
                ),
                context.verticalSpace(48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBannerCard(
    BuildContext context,
    TreatmentDetailDto detail,
    String status,
    Color statusColor,
  ) {
    return BorderdContainerWidget(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: context.appBorderRadius(all: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Image
            AppNetworkImage(
              imageUrl: detail.image ?? '',
              width: double.infinity,
              height: context.h(220),
              fit: BoxFit.cover,
              errorIcon: Icons.image_outlined,
              errorIconSize: 48,
            ),
            Padding(
              padding: context.appEdgeInsets(all: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Circular Icon
                  AppNetworkImage(
                    imageUrl: detail.icon ?? '',
                    width: 64,
                    height: 64,
                    borderRadius: BorderRadius.circular(32),
                    fit: BoxFit.cover,
                    errorIcon: Icons.spa_outlined,
                    errorIconSize: 28,
                  ),
                  context.horizontalSpace(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                detail.patientDisplayName ?? 'N/A',
                                style: context.fonts.level2Heading,
                              ),
                            ),
                            Consumer(
                              builder: (context, ref, child) {
                                return StatusToggleSwitch(
                                  width: context.w(105),
                                  height: context.h(35),
                                  status: status,
                                  onChanged: (newStatus) {
                                    if (detail.id != null) {
                                      ref
                                          .read(
                                            treatmentViewModelProvider.notifier,
                                          )
                                          .changeTreatmentStatus(
                                            detail.id!,
                                            newStatus,
                                            callDetail: true,
                                          );
                                      ref.read(treatmentViewModelProvider.notifier).initialize();

                                    }
                                  },
                                );
                              },
                            ),

                            // Container(
                            //   padding: const EdgeInsets.symmetric(
                            //     horizontal: 12,
                            //     vertical: 4,
                            //   ),
                            //   decoration: BoxDecoration(
                            //     color: statusColor.withValues(alpha: 0.1),
                            //     borderRadius: BorderRadius.circular(12),
                            //     border: Border.all(
                            //       color: statusColor.withValues(alpha: 0.2),
                            //     ),
                            //   ),
                            //   child: Text(
                            //     status,
                            //     style: context.fonts.grey10w700ls1.copyWith(
                            //       color: statusColor,
                            //       fontSize: 11,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        context.verticalSpace(6),
                        Row(
                          children: [
                            const Icon(
                              Icons.tag_rounded,
                              size: 16,
                              color: CustomColors.grey,
                            ),
                            context.horizontalSpace(6),
                            Text(
                              'SKU: ${detail.globalSku ?? "N/A"}',
                              style: context.fonts.grey13w500,
                            ),
                            const Spacer(),

                            Consumer(
                              builder: (context, ref, child) {
                                return GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(
                                          treatmentViewModelProvider.notifier,
                                        )
                                        .setBasicInfoControllers(detail);
                                    BasicInfoDialog.show(
                                      context,
                                      isEditMode: true,
                                      treatmentId: detail.id,
                                    );
                                  },
                                  child: Container(
                                    padding: context.appEdgeInsets(
                                      horizontal: 6,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.r),
                                      border: Border.all(
                                        color: CustomColors.purple,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.update,
                                          size: 16.sp,
                                          color: CustomColors.purple,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          'Update Info',
                                          style: context.fonts.sectionHeading
                                              .copyWith(fontSize: 12.sp),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard(
    BuildContext context,
    TreatmentDetailDto detail,
  ) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.description_outlined,
                color: CustomColors.purple,
                size: 20,
              ),
              context.horizontalSpace(10),
              Text('Description & Details', style: context.fonts.black16w700),
            ],
          ),
          context.verticalSpace(14),
          Text(
            detail.shortDescription ?? 'No short summary provided.',
            style: context.fonts.black14w700.copyWith(color: CustomColors.grey),
          ),
          context.verticalSpace(10),
          const Divider(),
          context.verticalSpace(10),
          Text(
            detail.description ?? 'No detailed description provided.',
            style: context.fonts.grey14w400h16.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection(
    BuildContext context,
    TreatmentDetailDto detail,
  ) {
    final categories = detail.selectedCategories ?? [];

    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.category_outlined,
                color: CustomColors.purple,
                size: 20,
              ),
              context.horizontalSpace(10),
              Text('Assigned Category Path', style: context.fonts.black16w700),
            ],
          ),
          context.verticalSpace(16),
          if (categories.isEmpty)
            Text(
              'No laser categories assigned (N/A)',
              style: context.fonts.grey13w500,
            )
          else
            Text(
              categories.map((cat) => cat.name ?? 'Category').join(', '),
              style: context.fonts.black14w600.copyWith(
                color: CustomColors.purple,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAreasWithSessionsSection(
    BuildContext context,
    TreatmentDetailDto detail,
  ) {
    // final areas = detail.areas ?? [];

    return Consumer(
      builder: (context, ref, _) {
        final areas =
            ref
                .watch(treatmentViewModelProvider)
                .selectedTreatmentDetail
                ?.areas ??
            [];
        return BorderdContainerWidget(
          padding: context.appEdgeInsets(all: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: CustomColors.purple,
                    size: 20,
                  ),
                  context.horizontalSpace(10),
                  Text(
                    'Anatomical Areas & Clinical Sessions',
                    style: context.fonts.black16w700,
                  ),
                ],
              ),
              context.verticalSpace(16),
              if (areas.isEmpty)
                Text(
                  'No anatomical areas selected (N/A)',
                  style: context.fonts.grey13w500,
                )
              else
                Column(
                  children: areas.map((area) {
                    final areaSessions = area.sessions ?? [];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      padding: context.appEdgeInsets(all: 16),
                      decoration: BoxDecoration(
                        color: CustomColors.palePurple.withValues(alpha: 0.03),
                        borderRadius: context.appBorderRadius(all: 12),
                        border: Border.all(
                          color: CustomColors.purple.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.location_searching,
                                color: CustomColors.purple,
                                size: 18,
                              ),
                              context.horizontalSpace(8),
                              Text(
                                area.areaName ?? 'Target Area',
                                style: context.fonts.black14w700.copyWith(
                                  color: CustomColors.purple,
                                ),
                              ),
                            ],
                          ),
                          context.verticalSpace(12),
                          if (areaSessions.isEmpty)
                            Text(
                              'No procedure sessions scheduled for this area.',
                              style: context.fonts.grey12w400,
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: areaSessions.length,
                              separatorBuilder: (_, _) =>
                                  context.verticalSpace(12),
                              itemBuilder: (context, idx) {
                                return TreatmentSessionExpansionTile(
                                  session: areaSessions[idx],
                                );
                              },
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBusinessLogicCard(
    BuildContext context,
    TreatmentDetailDto detail,
  ) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.settings_suggest_outlined,
            color: CustomColors.purple,
            size: 20,
          ),
          context.horizontalSpace(10),
          Text('Business Logic & Rules', style: context.fonts.black16w700),
          context.verticalSpace(16),
          _logicRow(
            context,
            Icons.add_business_outlined,
            'Enable by Default for New Clinics',
            detail.enableByDefault ?? false,
          ),
          context.verticalSpace(12),
          _logicRow(
            context,
            Icons.biotech_outlined,
            'AI Face Simulator Compatibility',
            detail.useInAiSimulator ?? false,
          ),
        ],
      ),
    );
  }

  Widget _logicRow(
    BuildContext context,
    IconData icon,
    String label,
    bool isEnabled,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: isEnabled ? CustomColors.purple : CustomColors.grey,
          size: 20,
        ),
        context.horizontalSpace(12),
        Expanded(child: Text(label, style: context.fonts.black13w600)),
        Text(
          isEnabled ? 'Enabled' : 'Disabled',
          style: isEnabled
              ? context.fonts.purple12w700
              : context.fonts.grey13w500,
        ),
      ],
    );
  }

  Widget _buildMetadataCard(BuildContext context, TreatmentDetailDto detail) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: CustomColors.purple,
                size: 20,
              ),
              context.horizontalSpace(10),
              Text('Audit Information', style: context.fonts.black16w700),
            ],
          ),
          context.verticalSpace(16),
          _detailRow(context, 'Created At', _formatTimestamp(detail.createdAt)),
          context.verticalSpace(10),
          _detailRow(
            context,
            'Last Updated',
            _formatTimestamp(detail.updatedAt),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: context.fonts.grey13w500),
        Text(value, style: context.fonts.black13w600),
      ],
    );
  }

  String _formatTimestamp(DateTime? dt) {
    if (null == dt) return '—';
    try {
      final date = dt.toLocal();
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '—';
    }
  }
}
