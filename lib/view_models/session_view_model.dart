// ignore_for_file: avoid_positional_boolean_parameters
import 'dart:developer';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/notification_entry.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/allowed_provider_role_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/constent_form_selection_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/down_time_level_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/final_finish_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/follow_up_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/phase_notifications_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/post_treatment_instruction_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/pre_treatment_instruction_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/post_photos_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/product_usage_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/protocol_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/step_pricing_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/treatment_schedule_request.dart';
import 'package:skinsync_admin/models/responses/down_time_level_response.dart';
import 'package:skinsync_admin/models/responses/treatment_products_response.dart';
import 'package:skinsync_admin/models/responses/session_detail_response.dart';
import 'package:skinsync_admin/models/common_models.dart';
import 'package:collection/collection.dart';
import 'package:skinsync_admin/models/treatment_data_models.dart';
import 'package:skinsync_admin/repositories/product_repository.dart';
import 'package:skinsync_admin/repositories/session_repository.dart';
import 'package:skinsync_admin/services/locator.dart';
import 'package:skinsync_admin/services/media_service.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/utils/exception.dart';
import '../models/session_model.dart';
import 'base_state_model.dart';
import 'base_view_model.dart';

final sessionViewModelProvider =
    NotifierProvider<SessionViewModel, SessionState>(SessionViewModel._);

class SessionState extends BaseStateModel {
  final List<SessionViewModelEntry> sessions;
  final int activeSessionIndex;
  final int sessionStep;
  final int? sessionId;

  // Products/materials
  final List<ProductUsageEntry> productUsageEntries;
  final List<ProductUsageEntry> otherMaterialsUsageEntries;
  final List<TreatmentProductData> products;
  final List<DownTimeLevel> downTimeLevelList;
  final bool isLoadingProducts;
  final String? error;

  // New redesigned MaterialsStep properties
  final int? selectedUnitTypeId;
  final String? selectedUnitTypeName;

  // Protocols
  final List<String> selectedProtocolIds;
  final List<TreatmentProtocolNote> selectedProtocolNotes;
  final List<TreatmentProtocolNoteItem> standaloneNotes;

  // Notifications
  final String preNotificationSource;
  final String postNotificationSource;
  final List<NotificationEntry> preNotificationEntries;
  final List<NotificationEntry> postNotificationEntries;

  // Photos
  final bool requirePostTreatmentPhotos;
  final int requiredPostTreatmentPhotoCount;

  // Consent
  final String consentType;
  final PlatformFile? preTreatmentConsentForm;
  final dynamic existingConsentForm;
  final String consentFormUrl;

  // Attachments
  final List<Attachment> existingPreAttachments;
  final List<Attachment> existingPostAttachments;
  final List<PostTreatmentPhotoConfig> postTreatmentPhotoConfigs;

  // Downtime
  final String downtimeLevel;

  // Roles
  final List<String> selectedRoles;
  final String providerRolesSource;
  final List<String> materialsRoles;
  final String materialsRolesSource;
  final List<String> schedulingRoles;
  final String schedulingRolesSource;
  final List<String> pricingRoles;
  final String pricingRolesSource;

  // Scheduling
  final bool allowClinicOverride;
  final bool allowProviderOverride;
  final bool onlineBookable;
  final bool manualApprovalRequired;
  final bool isFixedDuration;
  final bool isFixedPrice;

  final int totalSessions;
  final int? preNotificationOffset;
  final int? postNotificationOffset;
  final String sessionSource;
  final bool isFollowUpRequired;

  SessionState({
    super.loading,
    super.currentPage,
    super.totalPages,
    super.totalResults,
    this.sessions = const [],
    this.activeSessionIndex = 0,
    this.sessionStep = 1,
    this.sessionId,
    this.productUsageEntries = const [],
    this.otherMaterialsUsageEntries = const [],
    this.products = const [],
    this.isLoadingProducts = false,
    this.selectedUnitTypeId,
    this.selectedUnitTypeName,
    this.error,
    this.selectedProtocolIds = const [],
    this.selectedProtocolNotes = const [],
    this.standaloneNotes = const [],
    this.preNotificationSource = 'Category_Default',
    this.postNotificationSource = 'Category_Default',
    this.preNotificationEntries = const [],
    this.postNotificationEntries = const [],
    this.postTreatmentPhotoConfigs = const [],
    this.requirePostTreatmentPhotos = false,
    this.requiredPostTreatmentPhotoCount = 0,
    this.consentType = 'No_Consent',
    this.preTreatmentConsentForm,
    this.existingConsentForm,
    this.consentFormUrl = '',
    this.existingPreAttachments = const [],
    this.existingPostAttachments = const [],
    this.downtimeLevel = 'No_Downtime',
    this.downTimeLevelList = const [],
    this.selectedRoles = const [],
    this.providerRolesSource = 'Category_Default',
    this.materialsRoles = const [],
    this.materialsRolesSource = 'category',
    this.schedulingRoles = const [],
    this.schedulingRolesSource = 'category',
    this.pricingRoles = const [],
    this.pricingRolesSource = 'category',
    this.allowClinicOverride = false,
    this.allowProviderOverride = false,
    this.onlineBookable = false,
    this.manualApprovalRequired = false,
    this.isFixedDuration = false,
    this.isFixedPrice = false,
    this.totalSessions = 0,
    this.preNotificationOffset,
    this.postNotificationOffset,
    this.sessionSource = 'custom',
    this.isFollowUpRequired = false,
  });

  SessionState copyWith({
    bool? loading,
    int? currentPage,
    int? totalPages,
    int? totalResults,
    List<SessionViewModelEntry>? sessions,
    int? activeSessionIndex,
    int? sessionStep,
    List<ProductUsageEntry>? productUsageEntries,
    List<ProductUsageEntry>? otherMaterialsUsageEntries,
    List<TreatmentProductData>? products,
    List<DownTimeLevel>? downTimeLevelList,
    bool? isLoadingProducts,
    int? selectedUnitTypeId,
    String? selectedUnitTypeName,
    String? error,
    List<String>? selectedProtocolIds,
    List<TreatmentProtocolNote>? selectedProtocolNotes,
    List<TreatmentProtocolNoteItem>? standaloneNotes,
    String? preNotificationSource,
    String? postNotificationSource,
    List<NotificationEntry>? preNotificationEntries,
    List<NotificationEntry>? postNotificationEntries,
    List<PostTreatmentPhotoConfig>? postTreatmentPhotoConfigs,
    bool? requirePostTreatmentPhotos,
    int? requiredPostTreatmentPhotoCount,
    String? consentType,
    PlatformFile? preTreatmentConsentForm,
    dynamic existingConsentForm,
    String? consentFormUrl,
    List<Attachment>? existingPreAttachments,
    List<Attachment>? existingPostAttachments,
    String? downtimeLevel,
    List<String>? selectedRoles,
    String? providerRolesSource,
    List<String>? materialsRoles,
    String? materialsRolesSource,
    List<String>? schedulingRoles,
    String? schedulingRolesSource,
    List<String>? pricingRoles,
    String? pricingRolesSource,
    bool? allowClinicOverride,
    bool? allowProviderOverride,
    bool? onlineBookable,
    bool? manualApprovalRequired,
    bool? isFixedDuration,
    bool? isFixedPrice,
    int? totalSessions,
    int? preNotificationOffset,
    int? postNotificationOffset,
    String? sessionSource,
    bool? isFollowUpRequired,
    int? sessionId,
  }) {
    return SessionState(
      loading: loading ?? this.loading,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalResults: totalResults ?? this.totalResults,
      sessions: sessions ?? this.sessions,
      activeSessionIndex: activeSessionIndex ?? this.activeSessionIndex,
      sessionStep: sessionStep ?? this.sessionStep,
      productUsageEntries: productUsageEntries ?? this.productUsageEntries,
      otherMaterialsUsageEntries:
          otherMaterialsUsageEntries ?? this.otherMaterialsUsageEntries,
      products: products ?? this.products,
      isLoadingProducts: isLoadingProducts ?? this.isLoadingProducts,
      selectedUnitTypeId: selectedUnitTypeId ?? this.selectedUnitTypeId,
      selectedUnitTypeName: selectedUnitTypeName ?? this.selectedUnitTypeName,
      error: error ?? this.error,
      selectedProtocolIds: selectedProtocolIds ?? this.selectedProtocolIds,
      selectedProtocolNotes:
          selectedProtocolNotes ?? this.selectedProtocolNotes,
      standaloneNotes: standaloneNotes ?? this.standaloneNotes,
      preNotificationSource:
          preNotificationSource ?? this.preNotificationSource,
      postNotificationSource:
          postNotificationSource ?? this.postNotificationSource,
      preNotificationEntries:
          preNotificationEntries ?? this.preNotificationEntries,
      postNotificationEntries:
          postNotificationEntries ?? this.postNotificationEntries,
      postTreatmentPhotoConfigs:
          postTreatmentPhotoConfigs ?? this.postTreatmentPhotoConfigs,
      requirePostTreatmentPhotos:
          requirePostTreatmentPhotos ?? this.requirePostTreatmentPhotos,
      requiredPostTreatmentPhotoCount:
          requiredPostTreatmentPhotoCount ??
          this.requiredPostTreatmentPhotoCount,
      consentType: consentType ?? this.consentType,
      preTreatmentConsentForm:
          preTreatmentConsentForm ?? this.preTreatmentConsentForm,
      existingConsentForm: existingConsentForm ?? this.existingConsentForm,
      consentFormUrl: consentFormUrl ?? this.consentFormUrl,
      existingPreAttachments:
          existingPreAttachments ?? this.existingPreAttachments,
      existingPostAttachments:
          existingPostAttachments ?? this.existingPostAttachments,
      downtimeLevel: downtimeLevel ?? this.downtimeLevel,
      selectedRoles: selectedRoles ?? this.selectedRoles,
      providerRolesSource: providerRolesSource ?? this.providerRolesSource,
      materialsRoles: materialsRoles ?? this.materialsRoles,
      materialsRolesSource: materialsRolesSource ?? this.materialsRolesSource,
      schedulingRoles: schedulingRoles ?? this.schedulingRoles,
      schedulingRolesSource:
          schedulingRolesSource ?? this.schedulingRolesSource,
      pricingRoles: pricingRoles ?? this.pricingRoles,
      pricingRolesSource: pricingRolesSource ?? this.pricingRolesSource,
      allowClinicOverride: allowClinicOverride ?? this.allowClinicOverride,
      allowProviderOverride:
          allowProviderOverride ?? this.allowProviderOverride,
      onlineBookable: onlineBookable ?? this.onlineBookable,
      manualApprovalRequired:
          manualApprovalRequired ?? this.manualApprovalRequired,
      isFixedDuration: isFixedDuration ?? this.isFixedDuration,
      isFixedPrice: isFixedPrice ?? this.isFixedPrice,
      totalSessions: totalSessions ?? this.totalSessions,
      preNotificationOffset:
          preNotificationOffset ?? this.preNotificationOffset,
      postNotificationOffset:
          postNotificationOffset ?? this.postNotificationOffset,
      sessionSource: sessionSource ?? this.sessionSource,
      isFollowUpRequired: isFollowUpRequired ?? this.isFollowUpRequired,
      sessionId: sessionId ?? this.sessionId,
      downTimeLevelList: downTimeLevelList ?? this.downTimeLevelList,
    );
  }
}

class SessionViewModel extends BaseViewModel<SessionState> {
  SessionViewModel._() : super(SessionState()) {
    basePriceController.addListener(_triggerRebuild);
    fixedPriceController.addListener(_triggerRebuild);
    treatmentDurationController.addListener(_triggerRebuild);
    prepTimeController.addListener(_triggerRebuild);
    cleanupTimeController.addListener(_triggerRebuild);
    fixedDurationController.addListener(_triggerRebuild);
    preTreatmentInstructionsController.addListener(_triggerRebuild);
    postTreatmentInstructionsController.addListener(_triggerRebuild);
    minUnitsController.addListener(_triggerRebuild);
    maxUnitsController.addListener(_triggerRebuild);
  }

  void reset() {
    log('Session state reset');
    minUnitsController.text = '0';
    maxUnitsController.text = '0';
    state = SessionState(sessions: state.sessions);
  }

  void _triggerRebuild() {
    state = state.copyWith();
  }

  void selectUnitType(int? id, String? name) {
    state = state.copyWith(selectedUnitTypeId: id, selectedUnitTypeName: name);
  }

  void addOtherMaterial(int productId, String name) {
    final alreadyExists = state.otherMaterialsUsageEntries.any(
      (e) => e.productId == productId,
    );
    if (alreadyExists) return;

    final newEntry = ProductUsageEntry(
      productId: productId,
      productName: name,
      unit: 'Unit',
      notesController: TextEditingController(),
      minQuantityController: TextEditingController(text: '0'),
      maxQuantityController: TextEditingController(text: '0'),
      perUnitDurationController: TextEditingController(text: '0'),
      onChanged: _triggerRebuild,
    );
    state = state.copyWith(
      otherMaterialsUsageEntries: [
        ...state.otherMaterialsUsageEntries,
        newEntry,
      ],
    );
  }

  void removeOtherMaterial(int productId) {
    final entry = state.otherMaterialsUsageEntries.firstWhere(
      (e) => e.productId == productId,
    );
    entry.dispose();
    state = state.copyWith(
      otherMaterialsUsageEntries: state.otherMaterialsUsageEntries
          .where((e) => e.productId != productId)
          .toList(),
    );
  }

  void updateOtherMaterialEntry(
    int index, {
    String? deductionTiming,
    bool? allowSubstitution,
    String? notes,
  }) {
    final updatedEntries = [...state.otherMaterialsUsageEntries];
    updatedEntries[index] = updatedEntries[index].copyWith(
      deductionTiming: deductionTiming,
      allowSubstitution: allowSubstitution,
      onChanged: _triggerRebuild,
    );
    state = state.copyWith(otherMaterialsUsageEntries: updatedEntries);
  }

  void syncUnitPriceControllersForState() {
    _triggerRebuild();
  }

  final SessionRepository _sessionRepository = locator<SessionRepository>();

  // Text Controllers for Session Creation Scratchpad
  final basePriceController = TextEditingController(text: '0');
  final fixedPriceController = TextEditingController(text: '0');
  final Map<String, TextEditingController> unitPriceControllers = {};

  final minUnitsController = TextEditingController(text: '0');
  final maxUnitsController = TextEditingController(text: '0');

  final durationHoursController = TextEditingController();
  final durationMinutesController = TextEditingController();

  final treatmentDurationController = TextEditingController();
  final prepTimeController = TextEditingController();
  final cleanupTimeController = TextEditingController();
  final minimumBookingNoticeController = TextEditingController();
  final maximumDaysInAdvanceController = TextEditingController();
  final fixedDurationController = TextEditingController();

  final preTreatmentInstructionsController = TextEditingController();
  final postTreatmentInstructionsController = TextEditingController();

  final preNotificationTitleController = TextEditingController();
  final preNotificationDescriptionController = TextEditingController();
  final postNotificationTitleController = TextEditingController();
  final postNotificationDescriptionController = TextEditingController();

  final totalFollowUpsController = TextEditingController();
  final followUpDurationValueController = TextEditingController();
  final followUpNotesController = TextEditingController();

  final postTreatmentPhotoCountController = TextEditingController(text: '0');

  void addCustomSession(String title, int number) {
    final newSession = SessionViewModelEntry(
      sessionNumber: number,
      title: title,
    );
    state = state.copyWith(sessions: [...state.sessions, newSession]);
  }

  void setSessionId(int? sessionId) {
    state = state.copyWith(sessionId: sessionId);
  }

  Future<bool?> createSession({
    required int treatmentId,
    required int areaId,
    required String title,
    required int sessionNumber,
  }) async {
    return await runSafely<bool?>(
      onLoadingChange: (loading) => state = state.copyWith(loading: loading),
      () async {
        final response = await _sessionRepository.createSession(
          treatmentId: treatmentId,
          areaId: areaId,
          title: title,
          sessionNumber: sessionNumber,
        );
        if (response.isSuccess) {
          await fetchSessions(treatmentId: treatmentId, areaId: areaId);
          return true;
        }
        return false;
      },
    );
  }

  void setSessions(List<SessionModel> fetchedSessions) {
    // Clean old controllers first if any
    for (final session in state.sessions) {
      session.dispose();
    }
    final list = fetchedSessions.map((item) {
      return SessionViewModelEntry(
        sessionId: item.id,
        sessionNumber: item.sessionNumber,
        title: item.title,
        status: item.status,
        isDetailedEntered: item.isCompleted,
      );
    }).toList();
    state = state.copyWith(sessions: list);
  }

  Future<bool?> fetchSessions({
    required int treatmentId,
    required int areaId,
  }) async {
    return await runSafely<bool?>(
      onLoadingChange: (loading) => state = state.copyWith(loading: loading),
      () async {
        final response = await _sessionRepository.getSessions(
          treatmentId: treatmentId,
          areaId: areaId,
        );
        if (response.isSuccess && response.data != null) {
          setSessions(response.data!);
          return true;
        }
        return false;
      },
    );
  }

  Future<bool?> deleteSession({required int sessionId}) async {
    return await runSafely<bool?>(
      onLoadingChange: (loading) => state = state.copyWith(loading: loading),
      () async {
        final response = await _sessionRepository.deleteSession(id: sessionId);
        if (response.isSuccess) {
          return true;
        }
        return false;
      },
    );
  }

  void removeCustomSession(int index) {
    if (index >= 0 && index < state.sessions.length) {
      final updated = List<SessionViewModelEntry>.from(state.sessions);
      final removed = updated.removeAt(index);
      removed.dispose();
      state = state.copyWith(sessions: updated);
    }
  }

  void setActiveSessionIndex(int index) {
    state = state.copyWith(activeSessionIndex: index);
  }

  Future<bool> fetchAndPopulateSessionDetail(int sessionId) async {
    return await runSafely<bool>(
          onLoadingChange: (loading) =>
              state = state.copyWith(loading: loading),
          () async {
            final response = await _sessionRepository.getSessionDetail(
              id: sessionId,
            );
            if (response.isSuccess && response.data != null) {
              final SessionDetailDto detail = response.data!;

              // Set Session ID
              setSessionId(detail.id);

              // 1. Materials Step
              final mappedUsages = detail.productUsages.map((e) {
                final durationMatch = detail.productDurations.firstWhereOrNull(
                  (d) => d.productId == e.productId,
                );
                final perUnitDuration = durationMatch?.perUnitDuration ?? 0.0;

                return ProductUsageEntry(
                  productId: e.productId,
                  productName: e.productName,
                  unit: 'Unit',
                  notesController: TextEditingController(text: e.notes),
                  minQuantityController: TextEditingController(
                    text: e.minQuantity.toString(),
                  ),
                  maxQuantityController: TextEditingController(
                    text: e.maxQuantity.toString(),
                  ),
                  perUnitDurationController: TextEditingController(
                    text: perUnitDuration.toString(),
                  ),
                  allowSubstitution: e.allowSubstitution,
                  deductionTiming: e.deductionTiming,
                );
              }).toList();

              final mappedOtherUsages = detail.otherMaterials?.map((id) {
                final product = state.products.firstWhereOrNull(
                  (p) => p.id == id,
                );
                return ProductUsageEntry(
                  productId: id,
                  productName: product?.name ?? 'Product #{id',
                  unit: 'Unit',
                  notesController: TextEditingController(),
                  minQuantityController: TextEditingController(text: '0'),
                  maxQuantityController: TextEditingController(text: '0'),
                  perUnitDurationController: TextEditingController(text: '0'),
                  allowSubstitution: false,
                  deductionTiming: 'On_Completion', // Default name
                );
              }).toList();

              minUnitsController.text = (detail.minimumUnits ?? 0.0)
                  .toStringAsFixed(0);
              maxUnitsController.text = (detail.maximumUnits ?? 0.0)
                  .toStringAsFixed(0);

              state = state.copyWith(
                productUsageEntries: mappedUsages,
                otherMaterialsUsageEntries: mappedOtherUsages,
                selectedUnitTypeId: detail.selectedUnitTypeId,
              );

              // 2. Schedule Step
              treatmentDurationController.text = detail.baseDuration.toString();
              prepTimeController.text = detail.prepTime.toString();
              cleanupTimeController.text = detail.cleanupTime.toString();
              minimumBookingNoticeController.text = detail.minimumBookingNotice
                  .toString();
              maximumDaysInAdvanceController.text = detail.maximumDaysInAdvance
                  .toString();
              fixedDurationController.text = detail.fixedDuration.toString();

              state = state.copyWith(
                allowClinicOverride: detail.allowClinicOverride,
                allowProviderOverride: detail.allowProviderOverride,
                onlineBookable: detail.onlineBookable,
                manualApprovalRequired: detail.manualApprovalRequired,
                isFixedDuration: detail.isFixedDuration,
              );

              // 3. Pricing Step
              basePriceController.text = detail.basePrice.toString();
              fixedPriceController.text = detail.fixedPrice.toString();
              state = state.copyWith(isFixedPrice: detail.isFixedPrice);

              unitPriceControllers.forEach((_, c) => c.dispose());
              unitPriceControllers.clear();

              for (final override in detail.unitPriceOverrides) {
                final entry = mappedUsages.firstWhereOrNull(
                  (e) => e.productId == override.productId,
                );
                if (entry != null) {
                  final controller = getControllerForUnit(entry.unit);
                  controller.text = override.pricePerUnit.toString();
                }
              }

              // 5. Pre-Treatment Instructions
              preTreatmentInstructionsController.text =
                  detail.preTreatmentInstructions;
              final List<Attachment> preAttachments = detail
                  .preTreatmentAttachments
                  .map((a) {
                    return Attachment(
                      url: a.url,
                      type: a.type ?? 'pdf',
                      name: a.name,
                    );
                  })
                  .toList();

              // 6. Post-Treatment Instructions
              postTreatmentInstructionsController.text =
                  detail.postTreatmentInstructions;
              final List<Attachment> postAttachments = detail
                  .postTreatmentAttachments
                  .map((a) {
                    return Attachment(
                      url: a.url,
                      type: a.type ?? 'pdf',
                      name: a.name,
                    );
                  })
                  .toList();

              // 7. Post-Treatment Photos
              postTreatmentPhotoCountController.text = detail
                  .photoMilestone
                  .length
                  .toString();
              final List<PostTreatmentPhotoConfig> photoConfigs = detail
                  .photoMilestone
                  .map((m) {
                    return PostTreatmentPhotoConfig(
                      days: m.numberOfDays.toString(),
                      count: m.requiredPhotos.toString(),
                    );
                  })
                  .toList();

              state = state.copyWith(
                existingPreAttachments: preAttachments,
                existingPostAttachments: postAttachments,
                requirePostTreatmentPhotos: detail.requirePostTreatmentPhotos,
                postTreatmentPhotoConfigs: photoConfigs,
              );

              // 8 & 9. Phase Notifications
              final List<NotificationEntry> preNotifs = detail.preNotifications
                  .map((n) {
                    return NotificationEntry(
                      titleController: TextEditingController(text: n.title),
                      messageController: TextEditingController(text: n.message),
                      timingValueController: TextEditingController(
                        text: n.timing.toString(),
                      ),
                      timingUnit: n.timingUnit,
                      type: n.type,
                    );
                  })
                  .toList();

              final List<NotificationEntry> postNotifs = detail
                  .postNotifications
                  .map((n) {
                    return NotificationEntry(
                      titleController: TextEditingController(text: n.title),
                      messageController: TextEditingController(text: n.message),
                      timingValueController: TextEditingController(
                        text: n.timing.toString(),
                      ),
                      timingUnit: n.timingUnit,
                      type: n.type,
                    );
                  })
                  .toList();

              state = state.copyWith(
                preNotificationEntries: preNotifs,
                postNotificationEntries: postNotifs,
              );

              // 10. Downtime Level & Provider Roles
              state = state.copyWith(
                downtimeLevel: detail.downtimeLevel,
                selectedRoles: detail.allowedRoles,
                materialsRoles: detail.allowedRoles,
                materialsRolesSource: detail.allowedRoles.isNotEmpty
                    ? 'custom'
                    : 'category',
                schedulingRoles: detail.allowedRoles,
                schedulingRolesSource: detail.allowedRoles.isNotEmpty
                    ? 'custom'
                    : 'category',
                pricingRoles: detail.allowedRoles,
                pricingRolesSource: detail.allowedRoles.isNotEmpty
                    ? 'custom'
                    : 'category',
              );

              // 11. Follow ups
              final List<FollowUpEntry> mappedFollowUps = detail.followUps.map((
                f,
              ) {
                return FollowUpEntry(
                  type: f.type,
                  durationUnit: f.durationUnit,
                  durationValueController: TextEditingController(
                    text: f.durationValue.toString(),
                  ),
                  notesController: TextEditingController(text: f.notes),
                  intervalValueController: TextEditingController(
                    text: f.intervalValue.toString(),
                  ),
                  intervalUnit: f.intervalUnit,
                  isImageRequired: f.isImageRequired,
                );
              }).toList();

              final bool hasFollowUps = mappedFollowUps.isNotEmpty;

              final updatedSessions = state.sessions.map((s) {
                if (s.sessionId == detail.id) {
                  final durationText = detail.isFixedDuration
                      ? "Fixed: ${detail.fixedDuration} mins"
                      : "Total: ${detail.calculatedTotalDuration} mins (Base: ${detail.baseDuration}, Prep: ${detail.prepTime}, Cleanup: ${detail.cleanupTime})";

                  final priceText = detail.isFixedPrice
                      ? "\$${detail.fixedPrice} (Fixed Rate)"
                      : "\$${detail.basePrice} (Base) + Custom Overrides";

                  final List<String> protocols = [];
                  if (detail.clinicalProtocolPdf != null) {
                    protocols.add(
                      "${detail.clinicalProtocolPdf!.name} (Clinical Protocol)",
                    );
                  } else {
                    protocols.add("No clinical protocols configured");
                  }

                  final List<String> preNotifs = detail.preNotifications
                      .map(
                        (n) =>
                            "${n.title} - Send ${n.timing} ${n.timingUnit}(s) before",
                      )
                      .toList();

                  final List<String> postNotifs = detail.postNotifications
                      .map(
                        (n) =>
                            "${n.title} - Send ${n.timing} ${n.timingUnit}(s) after",
                      )
                      .toList();

                  final newS = SessionViewModelEntry(
                    sessionId: s.sessionId,
                    sessionNumber: s.sessionNumber,
                    title: s.title,
                    status: detail.status,
                    totalFollowUpsController: s.totalFollowUpsController,
                    followUps: mappedFollowUps,
                    isDetailedEntered: true,
                    productUsageSnapshot: List<ProductUsageEntry>.from(
                      mappedUsages,
                    ),
                    durationSnapshot: durationText,
                    priceSnapshot: priceText,
                    protocolSnapshot: protocols,
                    preInstructionsSnapshot: detail.preTreatmentInstructions,
                    postInstructionsSnapshot: detail.postTreatmentInstructions,
                    requirePhotosSnapshot: detail.requirePostTreatmentPhotos,
                    photosCountSnapshot: detail.photoMilestone.length,
                    preNotificationsSnapshot: preNotifs,
                    postNotificationsSnapshot: postNotifs,
                    downtimeSnapshot: detail.downtimeLevel,
                    rolesSnapshot: List.from(detail.allowedRoles),
                    consentSnapshot: detail.preTreatmentConsentForm?.name ?? '',
                  );
                  newS.totalFollowUpsController.text = mappedFollowUps.length
                      .toString();
                  return newS;
                }
                return s;
              }).toList();

              state = state.copyWith(
                sessions: updatedSessions,
                isFollowUpRequired: hasFollowUps,
              );

              // 12. Pre-Treatment Consent Form
              state = state.copyWith(
                consentFormUrl: detail.preTreatmentConsentForm?.url ?? '',
              );

              // Now let's set the Step open index
              setSessionStep(detail.currentStep);

              return true;
            }
            return false;
          },
        ) ??
        false;
  }

  void markActiveSessionAsDetailed({
    required String durationText,
    required String priceText,
    required List<String> protocols,
    required String preInstructions,
    required String postInstructions,
    required bool requirePhotosSnapshot,
    required int photosCountSnapshot,
    required List<String> preNotifs,
    required List<String> postNotifs,
    required String downtimeLevel,
    required List<String> selectedRoles,
    required String consentSnapshot,
    required List<ProductUsageEntry> productUsageEntries,
  }) {
    final List<SessionViewModelEntry> updatedSessions = List.from(
      state.sessions,
    );
    if (state.activeSessionIndex < updatedSessions.length) {
      final activeEntry = updatedSessions[state.activeSessionIndex];

      updatedSessions[state.activeSessionIndex] = SessionViewModelEntry(
        sessionId: activeEntry.sessionId,
        sessionNumber: activeEntry.sessionNumber,
        title: activeEntry.title,
        status: 'Completed',
        totalFollowUpsController: activeEntry.totalFollowUpsController,
        followUps: List.from(activeEntry.followUps),
        isDetailedEntered: true,
        productUsageSnapshot: List<ProductUsageEntry>.from(productUsageEntries),
        durationSnapshot: durationText,
        priceSnapshot: priceText,
        protocolSnapshot: protocols,
        preInstructionsSnapshot: preInstructions,
        postInstructionsSnapshot: postInstructions,
        requirePhotosSnapshot: requirePhotosSnapshot,
        photosCountSnapshot: photosCountSnapshot,
        preNotificationsSnapshot: preNotifs,
        postNotificationsSnapshot: postNotifs,
        downtimeSnapshot: downtimeLevel,
        rolesSnapshot: List.from(selectedRoles),
        consentSnapshot: consentSnapshot,
      );
      state = state.copyWith(sessions: updatedSessions);
    }
  }

  void resetSessions() {
    for (final session in state.sessions) {
      session.dispose();
    }
    state = state.copyWith(sessions: const [], activeSessionIndex: 0);
  }

  // Products and Inventory Original Implementations
  Future<void> fetchProductsByTreatmentCategory() async {
    // final treatmentState = ref.read(treatmentViewModelProvider);
    // if (treatmentState.selectedCategoryPath.isEmpty) {
    //   state = state.copyWith(products: [], isLoadingProducts: false);
    //   return;
    // }

    //   state = state.copyWith(isLoadingProducts: true);
    await runSafely(showLoading: true, () async {
      final response = await _sessionRepository.getProductsByTreatment(
        state.selectedUnitTypeId,
      );
      if (response.isSuccess) {
        state = state.copyWith(
          products: response.data ?? [],
          isLoadingProducts: false,
        );
      }
    });
  }

  Future<void> fetchDownTimeLevelByTreatment({required int id}) async {
    await runSafely(showLoading: true, () async {
      final response = await _sessionRepository.getDownTimeLevelByTreatment(
        id: id,
      );
      if (response.isSuccess) {
        state = state.copyWith(downTimeLevelList: response.data ?? []);
      }
    });
  }

  Future<void> addProductUsage(
    int productId,
    String productName,
    String unit,
  ) async {
    if (state.productUsageEntries.any((e) => e.productId == productId)) return;

    EasyLoading.show(status: 'Fetching product details...');
    String resolvedUnit = unit;
    String? resolvedPackageType;
    int? resolvedBoxQuantity;
    double? resolvedClinicCost;
    double? resolvedRetailPrice;

    try {
      final productRepo = locator<ProductRepository>();
      final detail = await productRepo.getProductDetail(id: productId);
      if (detail.data != null) {
        final pData = detail.data!;
        if (pData.unitType != null && pData.unitType!.isNotEmpty) {
          resolvedUnit = pData.unitType!;
        }
        resolvedPackageType = pData.packageType;
        resolvedBoxQuantity = pData.boxQuantity;
        resolvedClinicCost = pData.clinicCost;
        resolvedRetailPrice = pData.retailPricePerUnit;
      }
    } catch (e) {
      log('Error fetching product detail: $e');
    } finally {
      EasyLoading.dismiss();
    }

    final newEntry = ProductUsageEntry(
      productId: productId,
      productName: productName,
      unit: resolvedUnit,
      packageType: resolvedPackageType,
      boxQuantity: resolvedBoxQuantity,
      clinicCost: resolvedClinicCost,
      retailPricePerUnit: resolvedRetailPrice,
      onChanged: _triggerRebuild,
    );

    state = state.copyWith(
      productUsageEntries: [...state.productUsageEntries, newEntry],
    );
  }

  void updateProductUsageEntry(
    int index, {
    String? usageType,
    String? deductionTiming,
    bool? allowSubstitution,
    String? minQty,
    String? maxQuantity,
    String? usageDuration,
    String? usageDose,
    String? usageUnit,
    String? frequencyValue,
    String? frequencyInterval,
    String? instruction,
    String? usageTypeVal,
    String? minQuantity,
  }) {
    final updatedEntries = [...state.productUsageEntries];
    updatedEntries[index] = updatedEntries[index].copyWith(
      usageType: usageTypeVal ?? usageType,
      deductionTiming: deductionTiming,
      allowSubstitution: allowSubstitution,
      onChanged: _triggerRebuild,
    );
    state = state.copyWith(productUsageEntries: updatedEntries);
  }

  void updateProductPerUnitDuration(int index, String durationVal) {
    state = state.copyWith(productUsageEntries: [...state.productUsageEntries]);
  }

  void removeProductUsage(int productId) {
    final entry = state.productUsageEntries.firstWhere(
      (e) => e.productId == productId,
    );
    entry.dispose();
    state = state.copyWith(
      productUsageEntries: state.productUsageEntries
          .where((e) => e.productId != productId)
          .toList(),
    );
  }

  Future<bool?> callProductUsage({required int stepNumber}) async {
    final minUnits = double.tryParse(minUnitsController.text) ?? 0.0;
    final maxUnits = double.tryParse(maxUnitsController.text) ?? 0.0;

    final request = ProductUsagesRequest(
      stepNumber: stepNumber,
      selectedUnitTypeId: state.selectedUnitTypeId,
      minimumUnits: minUnits,
      maximumUnits: maxUnits,
      billableMaterials: state.productUsageEntries.map((e) {
        return ProductUsage(
          productId: e.productId,
          deductionTiming: e.deductionTiming,
          allowSubstitution: e.allowSubstitution,
          notes: e.notesController.text,
        );
      }).toList(),
      otherMaterials: state.otherMaterialsUsageEntries
          .map((e) => e.productId)
          .toList(),
      allowedRoles: state.materialsRoles,
    );

    return await runSafely<bool>(() async {
      await _sessionRepository.productUsage(
        request: request,
        id: state.sessionId!,
      );
      return true;
    });
  }

  double getProductMinQuantity(ProductUsageEntry entry) {
    return double.tryParse(entry.minQuantityController.text) ?? 0.0;
  }

  double calculateProductUsageDuration() {
    double total = 0.0;
    for (final entry in state.productUsageEntries) {
      final minQty = getProductMinQuantity(entry);
      final perUnit =
          double.tryParse(entry.perUnitDurationController.text) ?? 0.0;
      total += minQty * perUnit;
    }
    return total;
  }

  int calculateTotalDuration() {
    final baseDuration = int.tryParse(treatmentDurationController.text) ?? 0;
    final productDuration = calculateProductUsageDuration().toInt();
    final prepTime = int.tryParse(prepTimeController.text) ?? 0;
    final cleanupTime = int.tryParse(cleanupTimeController.text) ?? 0;
    return baseDuration + productDuration + prepTime + cleanupTime;
  }

  // Original callProtocol Implementation
  Future<bool?> callProtocol({
    required int stepNumber,
    required Uint8List bytes,
  }) async {
    final mediaService = MediaService();
    const String pdfName = 'clinicForm.pdf';

    return await runSafely(
      onLoadingChange: (loading) => state = state.copyWith(loading: loading),
      () async {
        ClinicalProtocolPdf? clinicalProtocolPdf;

        if (bytes.isNotEmpty) {
          final uploadedFile = await mediaService.uploadFile(
            'treatment/pdf',
            PlatformFile(name: pdfName, size: bytes.length, bytes: bytes),
          );

          if (uploadedFile == null) {
            throw const UnknownException('Failed to upload');
          }

          clinicalProtocolPdf = ClinicalProtocolPdf(
            name: pdfName,
            url: uploadedFile,
          );
        }

        final response = await _sessionRepository.protocol(
          request: ProtocolRequest(
            stepNumber: stepNumber,
            clinicalProtocolPdf: clinicalProtocolPdf,
          ),
          id: state.sessionId!,
        );

        return response.isSuccess;
      },
    );
  }

  Future<bool?> callStepPricing({required int stepNumber}) async {
    final request = StepPricingRequest(
      stepNumber: stepNumber,
      basePrice: state.isFixedPrice
          ? null
          : int.tryParse(basePriceController.text.trim()),
      unitPriceOverrides: state.isFixedPrice
          ? []
          : state.productUsageEntries.map((entry) {
              final maxQty =
                  (double.tryParse(entry.maxQuantityController.text) ?? 1.0)
                      .ceil();
              entry.syncUnitPriceControllers(maxQty);

              final List<int> prices = [];
              if (entry.useDifferentPricingPerUnit) {
                for (final c in entry.unitPriceControllers) {
                  prices.add(int.tryParse(c.text.trim()) ?? 0);
                }
              } else {
                final singlePrice =
                    int.tryParse(
                      entry.unitPriceControllers.isEmpty
                          ? '0'
                          : entry.unitPriceControllers[0].text.trim(),
                    ) ??
                    0;
                prices.addAll(List.filled(maxQty, singlePrice));
              }

              return UnitPriceOverride(
                productId: entry.productId,
                pricePerUnit: prices,
              );
            }).toList(),
      isFixedPrice: state.isFixedPrice,
      fixedPrice: state.isFixedPrice
          ? int.tryParse(fixedPriceController.text.trim())
          : null,
      allowedRoles: state.pricingRoles,
    );
    log('''
=========== PRODUCT USAGE REQUEST ===========

Step No    : $stepNumber
Body       : ${request.toJson()}
============================================
''');

    return await runSafely<bool>(() async {
      await _sessionRepository.stepPricing(
        request: request,
        id: state.sessionId!,
      );

      log('Step Pricing Created : ${state.sessionId!}');

      return true;
    });
  }

  Future<bool?> callDownTimeLevels({required int stepNumber}) async {
    // Resolve the actual days from the selected level + category presets
    final presets = ref
        .read(treatmentViewModelProvider)
        .selectedCategoryDetail
        ?.downtimePresets;
    final level = state.downtimeLevel;

    final int? downtimeDays = switch (level) {
      'None' => presets?.none ?? 0,
      'Low' => presets?.low ?? 2,
      'Moderate' => presets?.moderate ?? 5,
      'High' => presets?.high ?? 10,
      _ => null,
    };

    final request = DownTimeLevelRequest(
      stepNumber: stepNumber,
      downtimeLevel: level,
      downtimeDays: downtimeDays,
    );

    log('''
=========== DOWNTIME LEVEL REQUEST ===========
Draft ID      : ${state.sessionId}
Downtime Level: $level
Downtime Days : $downtimeDays
Body          : ${request.toJson()}
=============================================
''');

    return await runSafely<bool>(() async {
      await _sessionRepository.downTimeLevels(
        // ← correct endpoint
        request: request,
        id: state.sessionId!,
      );

      log('Step Downtime Saved : ${state.sessionId!}');

      return true;
    });
  }

  Future<bool?> callAllowedProviderRoles({required int stepNumber}) async {
    final bool isCatDefault = state.providerRolesSource == 'category';
    final request = AllowedProviderRolesRequest(
      stepNumber: stepNumber,
      isCatDefualt: isCatDefault,
      allowedRoles: isCatDefault ? [] : state.selectedRoles,
    );

    log('''
=========== ALLOWED PROVIDER ROLES REQUEST ===========
Draft ID             : ${state.sessionId}
Allowed Roles        : ${state.selectedRoles.join(', ')}
Body                 : ${request.toJson()}
======================================================
''');

    return await runSafely<bool>(() async {
      await _sessionRepository.allowedProviderRoles(
        request: request,
        id: state.sessionId!,
      );

      log('Step Allowed Provider Roles Saved : ${state.sessionId!}');

      return true;
    });
  }

  Future<bool?> callPreTreatmentInstructions({required int stepNumber}) async {
    return await runSafely<bool>(() async {
      final attachments = state.existingPreAttachments
          .map(
            (a) =>
                PreTreatmentAttachment(name: a.name, url: a.url, type: a.type),
          )
          .toList();

      final request = PreTreatmentInstructionsRequest(
        stepNumber: stepNumber,
        preTreatmentInstructions:
            preTreatmentInstructionsController.text.trim().isEmpty
            ? null
            : preTreatmentInstructionsController.text.trim(),
        preTreatmentAttachments: attachments.isEmpty ? null : attachments,
      );
      log('''
=========== PRE-TREATMENT INSTRUCTIONS REQUEST ===========
Draft ID   : ${state.sessionId!}
Body       : ${request.toJson()}
============================================
''');

      await _sessionRepository.preTreatmentInstructions(
        request: request,
        id: state.sessionId!,
      );

      log('Pre-Treatment Instructions Created : ${state.sessionId!}');

      return true;
    });
  }

  Future<bool?> callPostTreatmentInstructions({required int stepNumber}) async {
    return await runSafely<bool>(() async {
      final attachments = state.existingPostAttachments
          .map(
            (a) =>
                PostTreatmentAttachment(name: a.name, url: a.url, type: a.type),
          )
          .toList();

      final request = PostTreatmentInstructionsRequest(
        stepNumber: stepNumber,
        postTreatmentInstructions:
            postTreatmentInstructionsController.text.trim().isEmpty
            ? null
            : postTreatmentInstructionsController.text.trim(),
        postTreatmentAttachments: attachments.isEmpty ? null : attachments,
      );
      log('''
=========== POST-TREATMENT INSTRUCTIONS REQUEST ===========
Draft ID   : ${state.sessionId!}
Body       : ${request.toJson()}
============================================
''');

      await _sessionRepository.postTreatmentInstructions(
        request: request,
        id: state.sessionId!,
      );

      log('Post-Treatment Instructions Created : ${state.sessionId!}');

      return true;
    });
  }

  Future<bool?> callPostTreatmentPhotos({required int stepNumber}) async {
    return await runSafely(() async {
      if (state.sessionId == null) {
        throw const UnknownException('Session not found!');
      }
      int totalCount = 0;
      final List<PhotoMilestone> configs = [];

      for (final config in state.postTreatmentPhotoConfigs) {
        final days = int.tryParse(config.daysController.text) ?? 0;
        final count = int.tryParse(config.countController.text) ?? 0;
        totalCount += count;
        configs.add(PhotoMilestone(numberOfDays: days, requiredPhotos: count));
      }

      await _sessionRepository.postTreatmentPhotos(
        id: state.sessionId!,
        requirePostPhotos: state.requirePostTreatmentPhotos,
        count: totalCount,
        configs: configs,
        stepNumber: stepNumber,
      );

      state = state.copyWith(requiredPostTreatmentPhotoCount: totalCount);
      return true;
    });
  }

  Future<bool?> callPhaseNotifications({required int stepNumber}) async {
    return await runSafely(() async {
      final sessionId = state.sessionId;
      if (sessionId == null) {
        throw const UnknownException('Session not found!');
      }

      final bool preIsCatDefault = state.preNotificationSource == 'category';
      final bool postIsCatDefault = state.postNotificationSource == 'category';

      await _sessionRepository.phaseNotifications(
        id: sessionId,
        request: PhaseNotificationsRequest(
          stepNumber: stepNumber,
          preNoti: PreNoti(
            isCatDefault: preIsCatDefault,
            preNotifications: preIsCatDefault
                ? []
                : state.preNotificationEntries.map((entry) {
                    return PhaseNotification(
                      title: entry.titleController.text,
                      message: entry.messageController.text,
                      timing: int.tryParse(entry.timingValueController.text),
                      timingUnit: entry.timingUnit,
                      type: entry.type,
                    );
                  }).toList(),
          ),
          postNoti: PostNoti(
            isCatDefault: postIsCatDefault,
            postNotifications: postIsCatDefault
                ? []
                : state.postNotificationEntries.map((entry) {
                    return PhaseNotification(
                      title: entry.titleController.text,
                      message: entry.messageController.text,
                      timing: int.tryParse(entry.timingValueController.text),
                      timingUnit: entry.timingUnit,
                      type: entry.type,
                    );
                  }).toList(),
          ),
        ),
      );
      return true;
    });
  }

  Future<bool?> createSchedule({required int stepNumber}) async {
    return await runSafely<bool>(() async {
      await _sessionRepository.createSchedule(
        TreatmentScheduleRequest(
          stepNumber: stepNumber,
          baseDuration: state.isFixedDuration
              ? null
              : (int.tryParse(treatmentDurationController.text) ?? 0),
          productDurations: state.isFixedDuration
              ? []
              : state.productUsageEntries
                    .map(
                      (e) => ProductDuration(
                        productId: e.productId,
                        perUnitDuration: double.tryParse(
                          e.perUnitDurationController.text,
                        ),
                      ),
                    )
                    .toList(),
          prepTime: state.isFixedDuration
              ? null
              : (int.tryParse(prepTimeController.text) ?? 0),
          cleanupTime: state.isFixedDuration
              ? null
              : (int.tryParse(cleanupTimeController.text) ?? 0),
          allowClinicOverride: state.allowClinicOverride,
          allowProviderOverride: state.allowProviderOverride,
          onlineBookable: state.onlineBookable,
          manualApprovalRequired: state.manualApprovalRequired,
          minimumBookingNotice: int.tryParse(
            minimumBookingNoticeController.text,
          ),
          maximumDaysInAdvance: int.tryParse(
            maximumDaysInAdvanceController.text,
          ),
          calculatedTotalDuration: state.isFixedDuration
              ? null
              : calculateTotalDuration(),
          fixedDuration: state.isFixedDuration
              ? (int.tryParse(fixedDurationController.text) ?? 0)
              : null,
          isFixedDuration: state.isFixedDuration,
          allowedRoles: state.schedulingRoles,
        ),
        state.sessionId!,
      );
      log('Treatment Area Created : ${state.sessionId!}');

      return true;
    });
  }

  Future<bool?> callConsentFormSelection({required int stepNumber}) async {
    final bool isCatDefault = state.consentType == 'category';
    final request = ConsentFormSelectionRequest(
      stepNumber: stepNumber,
      isCatDefualt: isCatDefault,
      preTreatmentConsentForm: state.preTreatmentConsentForm != null
          ? PreTreatmentConsentForm(
              name: state.preTreatmentConsentForm!.name,
              url: state.consentFormUrl,
            )
          : null,
    );

    log('''
=========== CONSENT FORM SELECTION REQUEST ===========
Session ID           : ${state.sessionId!}
Consent Type         : ${state.consentType}
Consent Form         : ${state.preTreatmentConsentForm?.name}
Body                 : ${request.toJson()}
======================================================
''');

    return await runSafely<bool>(() async {
      await _sessionRepository.consentFormSelection(
        // ← correct endpoint
        request: request,
        id: state.sessionId!,
      );

      log('Step Consent Form Selection Saved : ${state.sessionId!}');

      return true;
    });
  }

  Future<bool?> callFollowUpConfig({required int stepNumber}) async {
    return await runSafely(() async {
      final sessionId = state.sessionId;
      if (sessionId == null) {
        throw const UnknownException('Session not found!');
      }
      await _sessionRepository.followUpConfig(
        id: sessionId,
        request: FollowUpRequest(
          stepNumber: stepNumber,
          followUps: state.sessions
              .expand((session) => session.followUps)
              .map(
                (followUp) => FollowUp(
                  type: followUp.type,
                  durationValue: num.parse(
                    followUp.durationValueController.text,
                  ),
                  durationUnit: followUp.durationUnit,
                  intervalValue: num.parse(
                    followUp.intervalValueController.text,
                  ),
                  intervalUnit: followUp.intervalUnit,
                  isImageRequired: followUp.isImageRequired,
                  notes: followUp.notesController.text,
                ),
              )
              .toList(),
        ),
      );

      return true;
    });
  }

  Future<bool?> callFinalFinish() async {
    return await runSafely(() async {
      final sessionId = state.sessionId;
      if (sessionId == null) {
        throw const UnknownException('Session not found!');
      }
      await _sessionRepository.finalFinish(
        id: sessionId,
        request: FinalFinishRequest(status: 'Active', isCompleted: true),
      );
      await fetchAndPopulateSessionDetail(sessionId);

      return true;
    });
  }

  void toggleProtocolSelection(
    String protocolId, {
    String? protocolName,
    List<ProtocolItem>? masterProtocols,
  }) {
    final List<String> currentSelected = List.from(state.selectedProtocolIds);
    final List<TreatmentProtocolNote> currentNotes = List.from(
      state.selectedProtocolNotes,
    );
    final actualName = protocolName ?? protocolId;

    if (currentSelected.contains(protocolId)) {
      currentSelected.remove(protocolId);
      currentNotes.removeWhere((note) => note.protocolName == actualName);
    } else {
      currentSelected.add(protocolId);
      if (!currentNotes.any((n) => n.protocolName == actualName)) {
        List<TreatmentProtocolNoteItem> initialNotes = [];
        if (masterProtocols != null && masterProtocols.isNotEmpty) {
          final matchingProtocol = masterProtocols.firstWhere(
            (p) => p.id == protocolId,
            orElse: () => masterProtocols.first,
          );
          if (matchingProtocol.id == protocolId &&
              matchingProtocol.descriptions.isNotEmpty) {
            initialNotes = matchingProtocol.descriptions
                .map(
                  (desc) => TreatmentProtocolNoteItem(
                    title: desc.title,
                    description: desc.text,
                    order: 1,
                  ),
                )
                .toList();
          }
        }
        currentNotes.add(
          TreatmentProtocolNote(protocolName: actualName, notes: initialNotes),
        );
      }
    }
    state = state.copyWith(
      selectedProtocolIds: currentSelected,
      selectedProtocolNotes: currentNotes,
    );
  }

  void updateSelectedProtocolIds(List<String> ids) {
    state = state.copyWith(selectedProtocolIds: ids);
  }

  void updateProtocolNotes(
    String protocolId,
    List<TreatmentProtocolNoteItem> notes,
  ) {
    final List<TreatmentProtocolNote> currentNotes = List.from(
      state.selectedProtocolNotes,
    );
    final index = currentNotes.indexWhere((n) => n.protocolName == protocolId);
    if (index != -1) {
      currentNotes[index] = TreatmentProtocolNote(
        protocolName: protocolId,
        notes: notes,
      );
    } else {
      currentNotes.add(
        TreatmentProtocolNote(protocolName: protocolId, notes: notes),
      );
    }
    state = state.copyWith(selectedProtocolNotes: currentNotes);
  }

  void updateStandaloneNotes(List<TreatmentProtocolNoteItem> notes) {
    state = state.copyWith(standaloneNotes: notes);
  }

  void setPreNotificationSource(String source, {dynamic category}) {
    state = state.copyWith(preNotificationSource: source);
  }

  void setPostNotificationSource(String source, {dynamic category}) {
    state = state.copyWith(postNotificationSource: source);
  }

  void setDowntimeLevel(String level) {
    state = state.copyWith(downtimeLevel: level);
  }

  void setProviderRolesSource(String source) {
    state = state.copyWith(providerRolesSource: source);
  }

  void updateFixedDuration(String val) {
    // handled locally or in copyWith as needed
  }

  void addPreNotificationEntry() {
    final newEntry = NotificationEntry(
      titleController: TextEditingController(),
      messageController: TextEditingController(),
      timingValueController: TextEditingController(),
      timingUnit: 'days',
      type: 'reminder',
    );
    state = state.copyWith(
      preNotificationEntries: [...state.preNotificationEntries, newEntry],
    );
  }

  void removePreNotificationEntry(int index) {
    final updated = [...state.preNotificationEntries];
    updated[index].dispose();
    updated.removeAt(index);
    state = state.copyWith(preNotificationEntries: updated);
  }

  void addPostNotificationEntry() {
    final newEntry = NotificationEntry(
      titleController: TextEditingController(),
      messageController: TextEditingController(),
      timingValueController: TextEditingController(),
      timingUnit: 'days',
      type: 'care',
    );
    state = state.copyWith(
      postNotificationEntries: [...state.postNotificationEntries, newEntry],
    );
  }

  void removePostNotificationEntry(int index) {
    final updated = [...state.postNotificationEntries];
    updated[index].dispose();
    state = state.copyWith(
      postNotificationEntries: updated
          .where((e) => e != updated[index])
          .toList(),
    );
  }

  void updateRequiredPostTreatmentPhotoCount(String value) {
    final count = int.tryParse(value) ?? 0;
    state = state.copyWith(requiredPostTreatmentPhotoCount: count);
  }

  void addPostTreatmentPhotoConfig() {
    final newConfig = PostTreatmentPhotoConfig(days: '1', count: '1');
    newConfig.daysController.addListener(_triggerRebuild);
    newConfig.countController.addListener(_triggerRebuild);
    state = state.copyWith(
      postTreatmentPhotoConfigs: [
        ...state.postTreatmentPhotoConfigs,
        newConfig,
      ],
    );
  }

  void removePostTreatmentPhotoConfig(int index) {
    final updated = List<PostTreatmentPhotoConfig>.from(
      state.postTreatmentPhotoConfigs,
    );
    updated[index].dispose();
    updated.removeAt(index);
    state = state.copyWith(postTreatmentPhotoConfigs: updated);
  }

  void setConsentType(String type) {
    state = state.copyWith(consentType: type);
  }

  void removeExistingAttachment(bool isPreTreatment, int index) {
    if (isPreTreatment) {
      final updated = List<Attachment>.from(state.existingPreAttachments);
      updated.removeAt(index);
      state = state.copyWith(existingPreAttachments: updated);
    } else {
      final updated = List<Attachment>.from(state.existingPostAttachments);
      updated.removeAt(index);
      state = state.copyWith(existingPostAttachments: updated);
    }
  }

  Future<void> pickAttachments(bool isPreTreatment) async {
    final FilePickerResult? result = await FilePicker.pickFiles(
      allowMultiple: true,
      withData: true,
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'jpg',
        'jpeg',
        'png',
        'webp',
        'mp4',
        'mov',
        'avi',
        'mkv',
        'webm',
      ],
    );

    if (result == null) return;

    await runSafely(() async {
      final uploaded = <Attachment>[];

      for (final file in result.files) {
        log('Uploading: ${file.name}');

        final url = await MediaService().uploadMedia(
          path: 'treatments',
          file: file,
        );

        if (url == null) {
          throw UnknownException('Failed to upload ${file.name}');
        }

        uploaded.add(
          Attachment(url: url, type: _getFileType(file), name: file.name),
        );

        log('Uploaded: $url');
      }

      if (isPreTreatment) {
        state = state.copyWith(
          existingPreAttachments: [
            ...state.existingPreAttachments,
            ...uploaded,
          ],
        );

        log('PRE TOTAL: ${state.existingPreAttachments.length}');
      } else {
        state = state.copyWith(
          existingPostAttachments: [
            ...state.existingPostAttachments,
            ...uploaded,
          ],
        );

        log('POST TOTAL: ${state.existingPostAttachments.length}');
      }
    });
  }

  String _getFileType(PlatformFile file) {
    final ext = file.extension?.toLowerCase();
    if (ext == 'pdf') return 'pdf';
    if (['jpg', 'jpeg', 'png', 'webp'].contains(ext)) return 'image';
    if (['mp4', 'mov', 'avi', 'mkv'].contains(ext)) return 'video';
    return 'other';
  }

  TextEditingController getControllerForUnit(String unit) {
    if (!unitPriceControllers.containsKey(unit)) {
      final controller = TextEditingController(text: '0');
      controller.addListener(_triggerRebuild);
      unitPriceControllers[unit] = controller;
    }
    return unitPriceControllers[unit]!;
  }

  void toggleRole(String role) {
    final List<String> current = List.from(state.selectedRoles);
    if (current.contains(role)) {
      current.remove(role);
    } else {
      current.add(role);
    }
    state = state.copyWith(selectedRoles: current);
  }

  void setRoles(List<String> roles) {
    state = state.copyWith(selectedRoles: roles);
  }

  void toggleMaterialsRole(String role) {
    final List<String> current = List.from(state.materialsRoles);
    if (current.contains(role)) {
      current.remove(role);
    } else {
      current.add(role);
    }
    state = state.copyWith(materialsRoles: current);
  }

  void setMaterialsRoles(List<String> roles) {
    state = state.copyWith(materialsRoles: roles);
  }

  void setMaterialsRolesSource(String source) {
    state = state.copyWith(materialsRolesSource: source);
  }

  void toggleSchedulingRole(String role) {
    final List<String> current = List.from(state.schedulingRoles);
    if (current.contains(role)) {
      current.remove(role);
    } else {
      current.add(role);
    }
    state = state.copyWith(schedulingRoles: current);
  }

  void setSchedulingRoles(List<String> roles) {
    state = state.copyWith(schedulingRoles: roles);
  }

  void setSchedulingRolesSource(String source) {
    state = state.copyWith(schedulingRolesSource: source);
  }

  void togglePricingRole(String role) {
    final List<String> current = List.from(state.pricingRoles);
    if (current.contains(role)) {
      current.remove(role);
    } else {
      current.add(role);
    }
    state = state.copyWith(pricingRoles: current);
  }

  void setPricingRoles(List<String> roles) {
    state = state.copyWith(pricingRoles: roles);
  }

  void setPricingRolesSource(String source) {
    state = state.copyWith(pricingRolesSource: source);
  }

  void updateSessionFollowUpCount(int sessionIndex, String val) {
    final count = int.tryParse(val) ?? 0;
    final session = state.sessions[sessionIndex];
    final List<FollowUpEntry> fus = List.from(session.followUps);

    if (count > fus.length) {
      for (int i = fus.length; i < count; i++) {
        fus.add(FollowUpEntry());
      }
    } else if (count < fus.length) {
      for (int i = count; i < fus.length; i++) {
        fus[i].dispose();
      }
      fus.removeRange(count, fus.length);
    }

    session.followUps = fus;
    state = state.copyWith(sessions: List.from(state.sessions));
  }

  void updateSessionFollowUpEntry(
    int sessionIndex,
    int fuIndex, {
    String? type,
    String? durationUnit,
    String? intervalUnit,
    bool? isImageRequired,
  }) {
    final session = state.sessions[sessionIndex];
    final fu = session.followUps[fuIndex];
    session.followUps[fuIndex] = fu.copyWith(
      type: type,
      durationUnit: durationUnit,
      intervalUnit: intervalUnit,
      isImageRequired: isImageRequired,
    );
    state = state.copyWith(sessions: List.from(state.sessions));
  }

  Future<void> pickConsentForm() async {
    final FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;

      final String? url = await MediaService().uploadMedia(
        path: 'treatment',
        file: file,
      );

      if (url != null) {
        state = state.copyWith(
          preTreatmentConsentForm: file, // store PlatformFile
          consentFormUrl: url, // store uploaded URL separately
        );
      }
    }
  }

  void removeConsentForm() {
    state = state.copyWith(
      preTreatmentConsentForm: null,
      existingConsentForm: null,
    );
  }

  void toggleRequirePostTreatmentPhotos(bool? value) {
    final active = value ?? false;
    final configs = List<PostTreatmentPhotoConfig>.from(
      state.postTreatmentPhotoConfigs,
    );
    if (active && configs.isEmpty) {
      final newConfig = PostTreatmentPhotoConfig(days: '1', count: '1');
      newConfig.daysController.addListener(_triggerRebuild);
      newConfig.countController.addListener(_triggerRebuild);
      configs.add(newConfig);
    }
    state = state.copyWith(
      requirePostTreatmentPhotos: active,
      postTreatmentPhotoConfigs: configs,
    );
  }

  void toggleAllowClinicOverride(bool? val) {
    state = state.copyWith(allowClinicOverride: val ?? false);
  }

  void toggleAllowProviderOverride(bool? val) {
    state = state.copyWith(allowProviderOverride: val ?? false);
  }

  void toggleOnlineBookable(bool? val) {
    state = state.copyWith(onlineBookable: val ?? false);
  }

  void toggleManualApprovalRequired(bool? val) {
    state = state.copyWith(manualApprovalRequired: val ?? false);
  }

  void toggleIsFixedDuration(bool? val) {
    state = state.copyWith(isFixedDuration: val ?? false);
  }

  void toggleIsFixedPrice(bool? val) {
    state = state.copyWith(isFixedPrice: val ?? false);
  }

  void setSessionStep(int step) {
    state = state.copyWith(sessionStep: step);
  }

  @override
  void dispose() {
    basePriceController.dispose();
    fixedPriceController.dispose();
    for (final controller in unitPriceControllers.values) {
      controller.dispose();
    }
    durationHoursController.dispose();
    durationMinutesController.dispose();
    treatmentDurationController.dispose();
    prepTimeController.dispose();
    cleanupTimeController.dispose();
    minimumBookingNoticeController.dispose();
    maximumDaysInAdvanceController.dispose();
    fixedDurationController.dispose();
    preTreatmentInstructionsController.dispose();
    postTreatmentInstructionsController.dispose();
    preNotificationTitleController.dispose();
    preNotificationDescriptionController.dispose();
    postNotificationTitleController.dispose();
    postNotificationDescriptionController.dispose();
    totalFollowUpsController.dispose();
    followUpDurationValueController.dispose();
    followUpNotesController.dispose();
    postTreatmentPhotoCountController.dispose();
    super.dispose();
  }
}

class SessionViewModelEntry {
  final int? sessionId;
  final int sessionNumber;
  final String? title;
  final String status;
  final TextEditingController totalFollowUpsController;
  List<FollowUpEntry> followUps;
  final bool isDetailedEntered;

  // Configuration snapshot fields
  List<ProductUsageEntry> productUsageSnapshot;
  String durationSnapshot;
  String priceSnapshot;
  List<String> protocolSnapshot;
  String preInstructionsSnapshot;
  String postInstructionsSnapshot;
  bool requirePhotosSnapshot;
  int photosCountSnapshot;
  List<String> preNotificationsSnapshot;
  List<String> postNotificationsSnapshot;
  String downtimeSnapshot;
  List<String> rolesSnapshot;
  String consentSnapshot;

  SessionViewModelEntry({
    required this.sessionNumber,
    this.sessionId,
    this.title,
    this.status = 'Draft',
    TextEditingController? totalFollowUpsController,
    this.followUps = const [],
    this.isDetailedEntered = false,
    this.productUsageSnapshot = const [],
    this.durationSnapshot = '',
    this.priceSnapshot = '',
    this.protocolSnapshot = const [],
    this.preInstructionsSnapshot = '',
    this.postInstructionsSnapshot = '',
    this.requirePhotosSnapshot = false,
    this.photosCountSnapshot = 0,
    this.preNotificationsSnapshot = const [],
    this.postNotificationsSnapshot = const [],
    this.downtimeSnapshot = '',
    this.rolesSnapshot = const [],
    this.consentSnapshot = '',
  }) : totalFollowUpsController =
           totalFollowUpsController ?? TextEditingController();

  void dispose() {
    totalFollowUpsController.dispose();
    for (final fu in followUps) {
      fu.dispose();
    }
  }
}

class FollowUpEntry {
  final String type; // virtual | in_person
  final String durationUnit;
  final TextEditingController durationValueController;
  final TextEditingController notesController;
  final TextEditingController intervalValueController;
  final String intervalUnit;
  final bool isImageRequired;

  FollowUpEntry({
    this.type = 'virtual',
    this.durationUnit = 'minutes',
    TextEditingController? durationValueController,
    TextEditingController? notesController,
    TextEditingController? intervalValueController,
    this.intervalUnit = 'days',
    this.isImageRequired = false,
  }) : durationValueController =
           durationValueController ?? TextEditingController(),
       notesController = notesController ?? TextEditingController(),
       intervalValueController =
           intervalValueController ?? TextEditingController();

  FollowUpEntry copyWith({
    String? type,
    String? durationUnit,
    String? intervalUnit,
    bool? isImageRequired,
  }) {
    return FollowUpEntry(
      type: type ?? this.type,
      durationUnit: durationUnit ?? this.durationUnit,
      durationValueController: durationValueController,
      notesController: notesController,
      intervalValueController: intervalValueController,
      intervalUnit: intervalUnit ?? this.intervalUnit,
      isImageRequired: isImageRequired ?? this.isImageRequired,
    );
  }

  void dispose() {
    durationValueController.dispose();
    notesController.dispose();
    intervalValueController.dispose();
  }
}

class ProductUsageEntry {
  final int productId;
  final String productName;
  final String unit;
  String usageType;
  String? deductionTiming;
  bool allowSubstitution;
  final TextEditingController minQuantityController;
  final TextEditingController maxQuantityController;
  final TextEditingController notesController;
  final TextEditingController perUnitDurationController;

  final String? packageType;
  final int? boxQuantity;
  final double? clinicCost;
  final double? retailPricePerUnit;

  bool useDifferentPricingPerUnit;
  final List<TextEditingController> unitPriceControllers;

  ProductUsageEntry({
    required this.productId,
    required this.productName,
    required this.unit,
    this.usageType = 'Required',
    this.deductionTiming = 'On_Completion',
    this.allowSubstitution = false,
    TextEditingController? minQuantityController,
    TextEditingController? maxQuantityController,
    TextEditingController? notesController,
    TextEditingController? perUnitDurationController,
    this.packageType,
    this.boxQuantity,
    this.clinicCost,
    this.retailPricePerUnit,
    this.useDifferentPricingPerUnit = false,
    List<TextEditingController>? unitPriceControllers,
    VoidCallback? onChanged,
  }) : minQuantityController =
           minQuantityController ?? TextEditingController(text: '1'),
       maxQuantityController =
           maxQuantityController ?? TextEditingController(text: '1'),
       notesController = notesController ?? TextEditingController(),
       perUnitDurationController =
           perUnitDurationController ?? TextEditingController(text: '0.0'),
       unitPriceControllers = unitPriceControllers ?? [] {
    if (onChanged != null) {
      this.minQuantityController.addListener(onChanged);
      this.maxQuantityController.addListener(onChanged);
      this.notesController.addListener(onChanged);
      this.perUnitDurationController.addListener(onChanged);
    }
  }

  void syncUnitPriceControllers(int maxQty) {
    if (unitPriceControllers.length < maxQty) {
      final diff = maxQty - unitPriceControllers.length;
      for (int i = 0; i < diff; i++) {
        unitPriceControllers.add(TextEditingController(text: '0'));
      }
    } else if (unitPriceControllers.length > maxQty) {
      final diff = unitPriceControllers.length - maxQty;
      for (int i = 0; i < diff; i++) {
        final last = unitPriceControllers.removeLast();
        last.dispose();
      }
    }
  }

  ProductUsageEntry copyWith({
    String? usageType,
    String? deductionTiming,
    bool? allowSubstitution,
    String? unit,
    bool? useDifferentPricingPerUnit,
    List<TextEditingController>? unitPriceControllers,
    VoidCallback? onChanged,
  }) {
    return ProductUsageEntry(
      productId: productId,
      productName: productName,
      unit: unit ?? this.unit,
      usageType: usageType ?? this.usageType,
      deductionTiming: deductionTiming ?? this.deductionTiming,
      allowSubstitution: allowSubstitution ?? this.allowSubstitution,
      minQuantityController: minQuantityController,
      maxQuantityController: maxQuantityController,
      notesController: notesController,
      perUnitDurationController: perUnitDurationController,
      packageType: packageType,
      boxQuantity: boxQuantity,
      clinicCost: clinicCost,
      retailPricePerUnit: retailPricePerUnit,
      useDifferentPricingPerUnit:
          useDifferentPricingPerUnit ?? this.useDifferentPricingPerUnit,
      unitPriceControllers: unitPriceControllers ?? this.unitPriceControllers,
      onChanged: onChanged,
    );
  }

  void dispose() {
    minQuantityController.dispose();
    maxQuantityController.dispose();
    notesController.dispose();
    perUnitDurationController.dispose();
    for (final c in unitPriceControllers) {
      c.dispose();
    }
  }
}

class PostTreatmentPhotoConfig {
  final TextEditingController daysController;
  final TextEditingController countController;

  PostTreatmentPhotoConfig({required String days, required String count})
    : daysController = TextEditingController(text: days),
      countController = TextEditingController(text: count);

  void dispose() {
    daysController.dispose();
    countController.dispose();
  }

  PostTreatmentPhotoConfig copyWith({String? days, String? count}) {
    return PostTreatmentPhotoConfig(
      days: days ?? daysController.text,
      count: count ?? countController.text,
    );
  }
}
