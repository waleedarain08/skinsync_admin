import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/treatment_data_models.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/category_view_model.dart';
import 'package:skinsync_admin/view_models/session_view_model.dart';
import 'package:skinsync_admin/view_models/treatment_data_view_model.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';

class LiveSessionPreviewWidget extends ConsumerWidget {
  const LiveSessionPreviewWidget({super.key});

  Widget _previewSectionHeader(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: CustomColors.purple),
        context.horizontalSpace(8),
        Text(
          title,
          style: context.fonts.black14w700.copyWith(color: CustomColors.purple),
        ),
      ],
    );
  }

  Widget _previewRow(BuildContext context, String label, String value, {bool isHeading = false}) {
    return Padding(
      padding: context.appEdgeInsets(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: isHeading ? context.fonts.black13w600 : context.fonts.grey13w500,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.isEmpty ? 'N/A' : value,
              style: context.fonts.black13w500,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(treatmentViewModelProvider);
    final sessionState = ref.watch(sessionViewModelProvider);

    String formatDeductionTiming(String? value) {
      if (value == null || value.isEmpty) return 'N/A';
      return value.replaceAll('_', ' ');
    }

    final sessionViewModel = ref.read(sessionViewModelProvider.notifier);
    final treatmentViewModel = ref.read(treatmentViewModelProvider.notifier);
    final categoryState = ref.watch(categoryViewModelProvider);
    final dataState = ref.watch(treatmentDataViewModelProvider);

    final String treatmentName = treatmentViewModel.displayNameController.text.trim().isNotEmpty
        ? treatmentViewModel.displayNameController.text.trim()
        : (treatmentViewModel.internalNameController.text.trim().isNotEmpty
            ? treatmentViewModel.internalNameController.text.trim()
            : 'N/A');

    final String categoryName = treatmentViewModel.categoryNameController.text.trim().isNotEmpty
        ? treatmentViewModel.categoryNameController.text.trim()
        : (categoryState.selectedCategoryDetail?.name ?? 'N/A');
    
    // Find the last selected area
    final activeArea = state.areas.where((a) => a.areaController.text.isNotEmpty).lastOrNull;
    final String areaName = activeArea?.areaController.text ?? 'N/A';
    final int activeSessionNum = sessionState.activeSessionIndex + 1;

    // Calculated Duration values
    final String prepTime = sessionViewModel.prepTimeController.text.trim().isEmpty 
        ? '0' 
        : sessionViewModel.prepTimeController.text.trim();
    final String cleanTime = sessionViewModel.cleanupTimeController.text.trim().isEmpty 
        ? '0' 
        : sessionViewModel.cleanupTimeController.text.trim();
    final String baseDuration = sessionViewModel.treatmentDurationController.text.trim().isEmpty 
        ? '0' 
        : sessionViewModel.treatmentDurationController.text.trim();
    final String fixedDuration = sessionViewModel.fixedDurationController.text.trim().isEmpty 
        ? '0' 
        : sessionViewModel.fixedDurationController.text.trim();

    final String durationDisplay = sessionState.isFixedDuration
        ? 'Fixed: $fixedDuration mins'
        : 'Total: ${sessionViewModel.calculateTotalDuration()} mins (Prep: ${prepTime}m, Base: ${baseDuration}m, Clean: ${cleanTime}m)';

    // Pricing values
    final String basePrice = sessionViewModel.basePriceController.text.trim().isEmpty
        ? '0'
        : sessionViewModel.basePriceController.text.trim();
    final String fixedPrice = sessionViewModel.fixedPriceController.text.trim().isEmpty
        ? '0'
        : sessionViewModel.fixedPriceController.text.trim();

    return Container(
      margin: context.appEdgeInsets(all: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: context.appBorderRadius(all: 16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: context.appEdgeInsets(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: CustomColors.purple,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Live Session Blueprint',
                  style: context.fonts.black14w700.copyWith(color: Colors.white),
                ),
                Container(
                  padding: context.appEdgeInsets(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: context.appBorderRadius(all: 20),
                  ),
                  child: Text(
                    'Active Session #$activeSessionNum',
                    style: context.fonts.grey12w600.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: context.appEdgeInsets(all: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _previewSectionHeader(context, 'General Setup', Icons.info_outline),
                  context.verticalSpace(8),
                  _previewRow(context, 'Treatment Name', treatmentName),
                  _previewRow(context, 'Treatment Category', categoryName),
                  _previewRow(context, 'Body Area', areaName),
                  const Divider(),
                  context.verticalSpace(12),
                  _previewSectionHeader(context, 'Inventory & Products', Icons.inventory_2_outlined),
                  context.verticalSpace(8),
                  if (sessionState.productUsageEntries.isEmpty)
                    Text(
                      'No inventory products added (N/A)',
                      style: context.fonts.grey12w400,
                    )
                  else
                    ...sessionState.productUsageEntries.map((e) {
                      final double minQty = double.tryParse(e.minQuantityController.text) ?? 0.0;
                      final double maxQty = double.tryParse(e.maxQuantityController.text) ?? 0.0;

                      final String qtyDisplay = '${minQty.toStringAsFixed(1)} - ${maxQty.toStringAsFixed(1)} ${e.unit}';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: context.appEdgeInsets(all: 12),
                        decoration: BoxDecoration(
                          color: CustomColors.whiteGrey.withValues(alpha: 0.3),
                          borderRadius: context.appBorderRadius(all: 8),
                          border: Border.all(color: CustomColors.border.withValues(alpha: 0.5)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    e.productName,
                                    style: context.fonts.black13w600,
                                  ),
                                ),
                                Text(
                                  qtyDisplay,
                                  style: context.fonts.purple13w600,
                                ),
                              ],
                            ),
                            context.verticalSpace(6),
                            _previewRow(context, 'Usage Type', e.usageType),
                            _previewRow(context, 'Deduction Timing', formatDeductionTiming(e.deductionTiming)),
                            _previewRow(context, 'Substitution Allowed', e.allowSubstitution ? 'Yes' : 'No'),
                            _previewRow(context, 'Per-Unit Duration', '${e.perUnitDurationController.text} mins'),
                            if (e.notesController.text.trim().isNotEmpty) ...[
                              context.verticalSpace(4),
                              Text(
                                'Notes: ${e.notesController.text.trim()}',
                                style: context.fonts.grey12w400.copyWith(fontStyle: FontStyle.italic),
                              ),
                            ],
                          ],
                        ),
                      );
                    }),
                  const Divider(),
                  context.verticalSpace(12),
                  _previewSectionHeader(context, 'Scheduling & Duration', Icons.schedule_outlined),
                  context.verticalSpace(8),
                  _previewRow(context, 'Duration Model', durationDisplay),
                  _previewRow(context, 'Clinic Override', sessionState.allowClinicOverride ? 'Allowed' : 'No'),
                  _previewRow(context, 'Provider Override', sessionState.allowProviderOverride ? 'Allowed' : 'No'),
                  _previewRow(context, 'Online Bookable', sessionState.onlineBookable ? 'Yes' : 'No'),
                  _previewRow(context, 'Manual Approval', sessionState.manualApprovalRequired ? 'Required' : 'No'),
                  const Divider(),
                  context.verticalSpace(12),
                  _previewSectionHeader(context, 'Pricing Models', Icons.payments_outlined),
                  context.verticalSpace(8),
                  if (sessionState.isFixedPrice) ...[
                    _previewRow(context, 'Pricing Type', 'Fixed Price'),
                    _previewRow(context, 'Flat Rate', '\$$fixedPrice'),
                  ] else ...[
                    _previewRow(context, 'Pricing Type', 'Dynamic Pricing'),
                    _previewRow(context, 'Base Price', '\$$basePrice'),
                    ...sessionState.productUsageEntries.map((entry) {
                      final controller = sessionViewModel.getControllerForUnit(entry.unit);
                      final price = controller.text.trim().isEmpty ? '0' : controller.text.trim();
                      return _previewRow(context, 'Price Per ${entry.unit}', '\$$price');
                    }),
                  ],
                  const Divider(),
                  context.verticalSpace(12),
                  _previewSectionHeader(context, 'Procedural Protocols Form', Icons.assignment_turned_in_outlined),
                  context.verticalSpace(12),
                  () {
                    final selectedProtocols = sessionState.selectedProtocolIds
                        .map((id) => dataState.protocols.any((p) => p.id == id)
                            ? dataState.protocols.firstWhere((p) => p.id == id)
                            : null)
                        .whereType<ProtocolItem>()
                        .toList();

                    if (selectedProtocols.isEmpty && sessionState.standaloneNotes.isEmpty) {
                      return Text('No checklist protocols or notes configured (N/A)', style: context.fonts.grey12w400);
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...selectedProtocols.map((protocol) {
                          final noteEntry = sessionState.selectedProtocolNotes.firstWhere(
                            (n) => n.protocolName == protocol.title,
                            orElse: () => TreatmentProtocolNote(
                              protocolName: protocol.title,
                              notes: [],
                            ),
                          );

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: context.appEdgeInsets(all: 14),
                            decoration: BoxDecoration(
                              color: CustomColors.whiteGrey.withValues(alpha: 0.3),
                              borderRadius: context.appBorderRadius(all: 10),
                              border: Border.all(color: CustomColors.border.withValues(alpha: 0.5)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.check_box_outlined,
                                      size: 18,
                                      color: CustomColors.purple,
                                    ),
                                    context.horizontalSpace(8),
                                    Expanded(
                                      child: Text(
                                        protocol.title,
                                        style: context.fonts.black13w600,
                                      ),
                                    ),
                                  ],
                                ),
                                if (noteEntry.notes.isNotEmpty) ...[
                                  context.verticalSpace(10),
                                  const Divider(),
                                  context.verticalSpace(8),
                                  ...noteEntry.notes.map((noteItem) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.crop_square_rounded,
                                            size: 16,
                                            color: CustomColors.grey,
                                          ),
                                          context.horizontalSpace(8),
                                          Expanded(
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  if (noteItem.title != null && noteItem.title!.isNotEmpty)
                                                    TextSpan(
                                                      text: '${noteItem.title}: ',
                                                      style: context.fonts.black13w600,
                                                    ),
                                                  TextSpan(
                                                    text: noteItem.description,
                                                    style: context.fonts.black13w500,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ] else ...[
                                  context.verticalSpace(8),
                                  Text(
                                    'No specific clinical notes added for this protocol.',
                                    style: context.fonts.grey12w400.copyWith(fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }),
                        if (sessionState.standaloneNotes.isNotEmpty) ...[
                          context.verticalSpace(8),
                          Text(
                            'General Clinical Directives:',
                            style: context.fonts.grey12w600,
                          ),
                          context.verticalSpace(10),
                          ...sessionState.standaloneNotes.asMap().entries.map((ent) {
                            final note = ent.value;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: context.appEdgeInsets(all: 12),
                              decoration: BoxDecoration(
                                color: CustomColors.whiteGrey.withValues(alpha: 0.2),
                                borderRadius: context.appBorderRadius(all: 8),
                                border: Border.all(color: CustomColors.border.withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.crop_square_rounded,
                                    size: 16,
                                    color: CustomColors.grey,
                                  ),
                                  context.horizontalSpace(8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (note.title != null && note.title!.isNotEmpty)
                                          Text(
                                            note.title!,
                                            style: context.fonts.black13w600,
                                          ),
                                        context.verticalSpace(2),
                                        Text(
                                          note.description,
                                          style: context.fonts.black13w500,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ],
                    );
                  }(),
                  const Divider(),
                  context.verticalSpace(12),
                  _previewSectionHeader(context, 'Treatment Instructions', Icons.menu_book_outlined),
                  context.verticalSpace(8),
                  _previewRow(
                    context,
                    'Pre-Treatment',
                    sessionViewModel.preTreatmentInstructionsController.text.trim().isEmpty
                        ? 'N/A'
                        : sessionViewModel.preTreatmentInstructionsController.text.trim(),
                  ),
                  _previewRow(
                    context,
                    'Post-Treatment',
                    sessionViewModel.postTreatmentInstructionsController.text.trim().isEmpty
                        ? 'N/A'
                        : sessionViewModel.postTreatmentInstructionsController.text.trim(),
                  ),
                  const Divider(),
                  context.verticalSpace(12),
                  _previewSectionHeader(context, 'Safety & Notifications', Icons.notifications_active_outlined),
                  context.verticalSpace(8),
                  _previewRow(
                    context,
                    'Required Photos',
                    sessionState.requirePostTreatmentPhotos
                        ? '${sessionState.postTreatmentPhotoConfigs.length} milestones'
                        : 'No',
                  ),
                  if (sessionState.requirePostTreatmentPhotos)
                    ...sessionState.postTreatmentPhotoConfigs.map((config) {
                      final days = config.daysController.text.trim().isEmpty ? '0' : config.daysController.text.trim();
                      final count = config.countController.text.trim().isEmpty ? '0' : config.countController.text.trim();
                      return _previewRow(
                        context,
                        '  └ Milestone Day $days',
                        '$count photos',
                      );
                    }),
                  _previewRow(context, 'Pre-Reminders', '${sessionState.preNotificationEntries.length} entries'),
                  _previewRow(context, 'Postcare Alerts', '${sessionState.postNotificationEntries.length} entries'),
                  _previewRow(context, 'Downtime Level', sessionState.downtimeLevel),
                  _previewRow(context, 'Allowed Roles', sessionState.selectedRoles.isEmpty ? 'N/A' : sessionState.selectedRoles.join(', ')),
                  const Divider(),
                  context.verticalSpace(12),
                  _previewSectionHeader(context, 'Patient Consent Form', Icons.fact_check_outlined),
                  context.verticalSpace(8),
                  _previewRow(context, 'Consent Source', sessionState.consentType == 'category' ? 'Category Default' : 'Custom Upload'),
                  if (sessionState.consentType != 'category')
                    _previewRow(
                      context,
                      'Uploaded Form',
                      sessionState.preTreatmentConsentForm?.name ??
                          sessionState.existingConsentForm?.name ??
                          'N/A',
                    ),
                  context.verticalSpace(24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}