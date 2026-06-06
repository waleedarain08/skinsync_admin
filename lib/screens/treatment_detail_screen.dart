import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:skinsync_admin/models/treatment_model.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/app_badge.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';

import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

class TreatmentDetailScreen extends ConsumerWidget {
  const TreatmentDetailScreen({super.key});
  static const String routeName = '/treatment-detail';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(treatmentViewModelProvider);
    final treatment = state.selectedTreatment;

    if (treatment == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text("Treatment not found")),
      );
    }

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        title: Text(treatment.name ?? "Treatment Profile", style: context.fonts.black18w600),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              // viewModel.selectTreatment(treatment);
              // context.push(EditTreatmentScreen.routeName);
            },
          ),
          context.horizontalSpace(16),
        ],
      ),
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 28, vertical: 32),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.w(1000)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(context, treatment),
                context.verticalSpace(32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildPrimaryInfo(context, treatment)),
                    context.horizontalSpace(24),
                    Expanded(child: _buildSecondaryStats(context, treatment)),
                  ],
                ),
                context.verticalSpace(32),
                _buildAreasAndLogic(context, treatment),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, TreatmentModel treatment) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 32),
      child: Row(
        children: [
          Container(
            width: context.w(120),
            height: context.w(120),
            decoration: BoxDecoration(
              color: CustomColors.softGrey,
              borderRadius: context.appBorderRadius(all: 20),
              image: (treatment.image != null && treatment.image!.isNotEmpty)
                  ? DecorationImage(image: NetworkImage(treatment.image!), fit: BoxFit.cover)
                  : null,
            ),
            child: (treatment.image == null || treatment.image!.isEmpty)
                ? Icon(Icons.image_outlined, size: context.sp(48), color: CustomColors.lightGrey)
                : null,
          ),
          context.horizontalSpace(32),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(treatment.name ?? "N/A", style: context.fonts.black26w700),
                    context.horizontalSpace(16),
                    AppBadge(
                      label: (treatment.status).toUpperCase(),
                      variant: treatment.status == 'active' 
                          ? AppBadgeVariant.success 
                          : (treatment.status == 'draft' ? AppBadgeVariant.warning : AppBadgeVariant.neutral),
                    ),
                  ],
                ),
                context.verticalSpace(8),
                Text(
                  treatment.categoryPath ?? "No Category Assigned",
                  style: context.fonts.purple14w600,
                ),
                context.verticalSpace(12),
                Row(
                  children: [
                    _headerMeta(context, Icons.timer_outlined, "${treatment.baseDurationHours ?? 0}h ${treatment.baseDurationMinutes ?? 0}m"),
                    context.horizontalSpace(24),
                    _headerMeta(context, Icons.payments_outlined, "Base \$${treatment.basePrice?.toStringAsFixed(2) ?? '0.00'}"),
                    context.horizontalSpace(24),
                    _headerMeta(context, Icons.inventory_2_outlined, treatment.materialName ?? "No Consumable"),
                  ],
                ),
              ],
            ),
          ),
          CustomPrimaryButton(
            onTap: () {},
            label: "Export Protocol",
            width: context.w(160),
            icon: Icons.ios_share_rounded,
          ),
        ],
      ),
    );
  }

  Widget _headerMeta(BuildContext context, IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: context.sp(18), color: CustomColors.grey),
        context.horizontalSpace(8),
        Text(label, style: context.fonts.grey14w600),
      ],
    );
  }

  Widget _buildPrimaryInfo(BuildContext context, TreatmentModel treatment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoSection(context, "Patient-Facing Description", treatment.shortDescription ?? "No summary provided."),
        context.verticalSpace(24),
        _infoSection(context, "Clinical Protocol & Process", treatment.description ?? "No detailed clinical information provided."),
        context.verticalSpace(32),
        Text("Material Mapping", style: context.fonts.black18w600),
        context.verticalSpace(16),
        BorderdContainerWidget(
          padding: context.appEdgeInsets(all: 20),
          child: Row(
            children: [
              const Icon(Icons.layers_outlined, color: CustomColors.purple),
              context.horizontalSpace(16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(treatment.materialName ?? "None", style: context.fonts.black14w600),
                  Text("Max per procedure: ${treatment.maxMaterialQuantity}", style: context.fonts.grey12w400),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.fonts.black14w700),
        context.verticalSpace(12),
        Text(
          content,
          style: context.fonts.grey14w400h16,
        ),
      ],
    );
  }

  Widget _buildSecondaryStats(BuildContext context, TreatmentModel treatment) {
    return Column(
      children: [
        _statCard(context, "Network Usage", "84 Clinics", Icons.hub_outlined),
        context.verticalSpace(16),
        _statCard(context, "Avg. Actual Price", "\$342.00", Icons.analytics_outlined),
        context.verticalSpace(16),
        _statCard(context, "Patient Popularity", "Top 5", Icons.trending_up_rounded),
        context.verticalSpace(32),
        BorderdContainerWidget(
          backgroundColor: CustomColors.softGrey,
          padding: context.appEdgeInsets(all: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("AI Simulator", style: context.fonts.black14w600),
              context.verticalSpace(8),
              Row(
                children: [
                  Icon(
                    treatment.useInAiSimulator ? Icons.check_circle_rounded : Icons.cancel_rounded,
                    color: treatment.useInAiSimulator ? CustomColors.green : CustomColors.red,
                    size: context.sp(18),
                  ),
                  context.horizontalSpace(8),
                  Text(
                    treatment.useInAiSimulator ? "Compatible" : "Not Enabled",
                    style: treatment.useInAiSimulator ? context.fonts.green14w600 : context.fonts.red14w600,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statCard(BuildContext context, String title, String value, IconData icon) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 20),
      child: Row(
        children: [
          Icon(icon, color: CustomColors.lightGrey, size: context.sp(20)),
          context.horizontalSpace(16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: context.fonts.grey12w400),
              Text(value, style: context.fonts.black16w600),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAreasAndLogic(BuildContext context, TreatmentModel treatment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Target Areas & Sub-Area Logic", style: context.fonts.black18w600),
        context.verticalSpace(16),
        if (treatment.sideAreas == null || treatment.sideAreas!.isEmpty)
          const Text("No specific area logic defined.")
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 2.2,
            ),
            itemCount: treatment.sideAreas!.length,
            itemBuilder: (context, index) {
              final area = treatment.sideAreas![index];
              return _buildAreaCard(context, area);
            },
          ),
      ],
    );
  }

  Widget _buildAreaCard(BuildContext context, SideAreaModel area) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: CustomColors.purple, size: 18),
              context.horizontalSpace(8),
              Text(area.name ?? "Unknown Area", style: context.fonts.black16w600),
            ],
          ),
          context.verticalSpace(16),
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (area.subAreas ?? []).map((sub) => Container(
                padding: context.appEdgeInsets(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: CustomColors.palePurple,
                  borderRadius: context.appBorderRadius(all: 6),
                ),
                child: Text(
                  "${sub.name} (Max: ${sub.maxMaterialQuantity})",
                  style: context.fonts.purple11w600.copyWith(fontSize: context.sp(10)),
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
