import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/treatment_model.dart';
import 'package:skinsync_admin/screens/edit_treatment_screen.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
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
      return GradientScaffold(body: Center(child: Text("No Treatment Selected", style: CustomFonts.black16w400)));
    }

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        elevation: 0,
        centerTitle: true,
        title: Text("Treatment Overview", style: CustomFonts.black20w600),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CustomColors.black),
          onPressed: () => context.pop(),
        ),
        actions: [
          CustomPrimaryButton(
            onTap: () => context.push(EditTreatmentScreen.routeName),
            icon: Icons.edit_outlined,
            label: "Edit Treatment",
            width: 180.w,
          ),
          SizedBox(width: 24.w),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 1000.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(treatment),
                SizedBox(height: 32.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _buildMainContent(treatment)),
                    SizedBox(width: 32.w),
                    Expanded(flex: 2, child: _buildSideContent(treatment)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(TreatmentModel treatment) {
    return BorderdContainerWidget(
      padding: EdgeInsets.all(32.w),
      child: Row(
        children: [
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              color: CustomColors.whiteGrey,
              borderRadius: BorderRadius.circular(20.r),
              image: (treatment.image != null && treatment.image!.isNotEmpty)
                  ? DecorationImage(image: NetworkImage(treatment.image!), fit: BoxFit.cover)
                  : null,
            ),
            child: (treatment.image == null || treatment.image!.isEmpty)
                ? Icon(Icons.medical_services_outlined, size: 48.sp, color: CustomColors.purple)
                : null,
          ),
          SizedBox(width: 32.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(treatment.name ?? "N/A", style: CustomFonts.black26w700),
                    SizedBox(width: 16.w),
                    _statusBadge(treatment.isActive),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(treatment.patientDisplayName ?? "No Display Name", style: CustomFonts.grey16w400),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    _categoryChip(treatment.categoryName ?? "General"),
                    if (treatment.categoryPath != null && treatment.categoryPath!.contains(" > ")) ...[
                      SizedBox(width: 12.w),
                      _categoryChip(treatment.categoryPath!.split(" > ").last, isSub: true),
                    ],
                    if (treatment.baseDurationHours != null || treatment.baseDurationMinutes != null) ...[
                      SizedBox(width: 12.w),
                      _durationChip(treatment.baseDurationHours ?? 0, treatment.baseDurationMinutes ?? 0),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("Base Price", style: CustomFonts.grey13w500),
              Text("\$${treatment.basePrice ?? 0}", style: CustomFonts.green20w600),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(TreatmentModel treatment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoCard("Description", treatment.description ?? "No description available.", icon: Icons.description_outlined),
        SizedBox(height: 24.h),
        _buildAreasList(treatment),
      ],
    );
  }

  Widget _buildSideContent(TreatmentModel treatment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoCard("Logic & Compatibility", null, icon: Icons.psychology_outlined, child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _booleanRow("AI Simulator Ready", treatment.useInAiSimulator),
            SizedBox(height: 24.h),
            Text("Combinable With:", style: CustomFonts.black16w400),
            SizedBox(height: 12.h),
            if (treatment.combinableTreatmentIds == null || treatment.combinableTreatmentIds!.isEmpty)
              Text("No specific combinations defined.", style: CustomFonts.grey13w500)
            else
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: treatment.combinableTreatmentIds!.map((id) => Chip(
                  label: Text("Treatment ID: $id", style: CustomFonts.black10w600),
                  backgroundColor: CustomColors.purple.withValues(alpha: 0.05),
                )).toList(),
              ),
          ],
        )),
        SizedBox(height: 24.h),
        _infoCard("Consumables", null, icon: Icons.inventory_2_outlined, child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Material Name:", style: CustomFonts.grey13w500),
                Text(treatment.materialName ?? "N/A", style: CustomFonts.grey14w600),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Max Quantity:", style: CustomFonts.grey13w500),
                Text("${treatment.maxMaterialQuantity}", style: CustomFonts.purple14w600),
              ],
            ),
          ],
        )),
      ],
    );
  }

  Widget _infoCard(String title, String? text, {required IconData icon, Widget? child}) {
    return BorderdContainerWidget(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20.sp, color: CustomColors.purple),
              SizedBox(width: 12.w),
              Text(title, style: CustomFonts.black18w600),
            ],
          ),
          if (text != null || child != null) ...[
            SizedBox(height: 16.h),
            if (text != null) Text(text, style: CustomFonts.grey14w400h16),
            if (child != null) child,
          ],
        ],
      ),
    );
  }

  Widget _buildAreasList(TreatmentModel treatment) {
    return BorderdContainerWidget(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 20.sp, color: CustomColors.purple),
              SizedBox(width: 12.w),
              Text("Target Body Areas & Configuration", style: CustomFonts.black18w600),
            ],
          ),
          SizedBox(height: 24.h),
          if (treatment.sideAreas == null || treatment.sideAreas!.isEmpty)
            Text("No areas defined for this treatment.", style: CustomFonts.grey14w400)
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: treatment.sideAreas!.length,
              separatorBuilder: (_, _) => Padding(padding: EdgeInsets.symmetric(vertical: 12.h), child: const Divider()),
              itemBuilder: (context, index) {
                final area = treatment.sideAreas![index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.r),
                          decoration: BoxDecoration(color: CustomColors.green.withValues(alpha: 0.1), shape: BoxShape.circle),
                          child: Icon(Icons.location_on_outlined, size: 18.sp, color: CustomColors.purple),
                        ),
                        SizedBox(width: 16.w),
                        Text(area.name ?? "N/A", style: CustomFonts.black16w400),
                        const Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(color: CustomColors.whiteGrey, borderRadius: BorderRadius.circular(20.r)),
                          child: Text("Area", style: CustomFonts.purple13w600),
                        ),
                      ],
                    ),
                    if (area.subAreas != null && area.subAreas!.isNotEmpty) ...[
                      SizedBox(height: 16.h),
                      Padding(
                        padding: EdgeInsets.only(left: 52.w),
                        child: Column(
                          children: area.subAreas!.map((sub) => _buildSubAreaDetailRow(sub)).toList(),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSubAreaDetailRow(SubAreaModel sub) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Icon(Icons.subdirectory_arrow_right, size: 16, color: CustomColors.grey),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(sub.name ?? "N/A", style: CustomFonts.grey14w400),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: CustomColors.purple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text("Max Qty: ${sub.maxMaterialQuantity ?? 0}", style: CustomFonts.purple13w600),
          ),
          SizedBox(width: 12.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: CustomColors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text("\$${sub.basePrice ?? 0}", style: CustomFonts.green13w600),
          ),
        ],
      ),
    );
  }

  Widget _booleanRow(String label, bool value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: CustomFonts.grey14w400),
        Icon(
          value ? Icons.check_circle_rounded : Icons.cancel_rounded,
          color: value ? CustomColors.green : CustomColors.red,
          size: 20.sp,
        ),
      ],
    );
  }

  Widget _statusBadge(bool isActive) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: (isActive ? CustomColors.green : CustomColors.grey).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        isActive ? "ACTIVE" : "INACTIVE",
        style: isActive ? CustomFonts.green10w700 : CustomFonts.grey10w700ls1,
      ),
    );
  }

  Widget _durationChip(int hours, int minutes) {
    String label = "";
    if (hours > 0) label += "$hours hr ";
    if (minutes > 0) label += "$minutes min";
    if (label.isEmpty) label = "N/A";

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: CustomColors.green.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: CustomColors.green.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.access_time_rounded, size: 14.sp, color: CustomColors.green),
          SizedBox(width: 6.w),
          Text(
            label.trim(),
            style: CustomFonts.green13w600,
          ),
        ],
      ),
    );
  }

  Widget _categoryChip(String label, {bool isSub = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isSub ? CustomColors.purple.withValues(alpha: 0.05) : CustomColors.green.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: (isSub ? CustomColors.purple : CustomColors.green).withValues(alpha: 0.1)),
      ),
      child: Text(
        label,
        style: isSub ? CustomFonts.purple13w600 : CustomFonts.purple13w600,
      ),
    );
  }
}
