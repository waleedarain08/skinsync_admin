import 'dart:math' as math;
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skinsync_admin/models/requests/protocol_request.dart';

import '../models/notification_entry.dart';
import '../models/requests/basic_info_request.dart';
import '../models/responses/category_detail_response.dart';
import '../models/treatment_data_models.dart';
import '../repositories/category_repository.dart';
import '../repositories/treatment_repository.dart';
import '../services/locator.dart';
import '../services/media_service.dart';
import '../utils/dummy_data.dart';
import '../utils/exception.dart';
import 'base_state_model.dart';
import 'base_view_model.dart';
import 'category_view_model.dart';

final treatmentViewModelProvider =
    NotifierProvider<TreatmentViewModel, TreatmentState>(TreatmentViewModel._);

class TreatmentViewModel extends BaseViewModel<TreatmentState> {
  TreatmentViewModel._() : super(TreatmentState());

  static final List<TreatmentModel> _localTreatments = List.from(
    TreatmentData.dummyTreatments,
  );

  // ignore: unused_field
  final TreatmentRepository _treatmentRepository =
      locator<TreatmentRepository>();
  final CategoryRepository _categoryRepository = locator<CategoryRepository>();

  // Step 1 Controllers
  final globalSkuController = TextEditingController();
  final internalNameController = TextEditingController();
  final displayNameController = TextEditingController();
  final fullDescriptionController = TextEditingController();
  final shortDescriptionController = TextEditingController();
  final basePriceController = TextEditingController();
  final Map<String, TextEditingController> unitPriceControllers = {};

  TextEditingController getControllerForUnit(String unit) {
    return unitPriceControllers.putIfAbsent(
      unit,
      () => TextEditingController(text: '0'),
    );
  }

  final durationHoursController = TextEditingController();
  final durationMinutesController = TextEditingController();

  // Step - Scheduling Controllers
  final treatmentDurationController = TextEditingController();
  final prepTimeController = TextEditingController();
  final cleanupTimeController = TextEditingController();
  final minimumBookingNoticeController = TextEditingController();
  final maximumDaysInAdvanceController = TextEditingController();

  // Step - Treatment Instructions Controllers
  final preTreatmentInstructionsController = TextEditingController();
  final postTreatmentInstructionsController = TextEditingController();

  // Step - Patient Communications Controllers
  final preNotificationTitleController = TextEditingController();
  final preNotificationDescriptionController = TextEditingController();
  final postNotificationTitleController = TextEditingController();
  final postNotificationDescriptionController = TextEditingController();

  // Step - Follow-Up Controllers
  final totalFollowUpsController = TextEditingController();
  final totalSessionsController = TextEditingController();
  final followUpDurationValueController = TextEditingController();
  final followUpNotesController = TextEditingController();

  // Step - Post Treatment Photos Controllers
  final postTreatmentPhotoCountController = TextEditingController(text: '0');

  // Step 3 Controllers (Protocols)
  final protocolNameController = TextEditingController();

  // Step 2 Controllers
  final categoryIdController = TextEditingController();
  final categoryNameController = TextEditingController();
  final categoryPathController = TextEditingController();

  // Filter Controllers
  final searchController = TextEditingController();
  final filterCategoryController = TextEditingController();
  final filterSubcategoryController = TextEditingController();
  final filterAreaController = TextEditingController();
  final filterSubAreaController = TextEditingController();
  final filterStatusController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    globalSkuController.dispose();
    internalNameController.dispose();
    displayNameController.dispose();
    fullDescriptionController.dispose();
    shortDescriptionController.dispose();
    basePriceController.dispose();
    durationHoursController.dispose();
    durationMinutesController.dispose();
    treatmentDurationController.dispose();
    prepTimeController.dispose();
    cleanupTimeController.dispose();
    minimumBookingNoticeController.dispose();
    maximumDaysInAdvanceController.dispose();
    preTreatmentInstructionsController.dispose();
    postTreatmentInstructionsController.dispose();
    preNotificationTitleController.dispose();
    preNotificationDescriptionController.dispose();
    postNotificationTitleController.dispose();
    postNotificationDescriptionController.dispose();
    totalFollowUpsController.dispose();
    totalSessionsController.dispose();
    followUpDurationValueController.dispose();
    followUpNotesController.dispose();
    postTreatmentPhotoCountController.dispose();
    protocolNameController.dispose();
    categoryIdController.dispose();
    categoryNameController.dispose();
    categoryPathController.dispose();

    searchController.dispose();
    filterCategoryController.dispose();
    filterSubcategoryController.dispose();
    filterAreaController.dispose();
    filterSubAreaController.dispose();
    filterStatusController.dispose();

    for (final area in state.areas) {
      area.dispose();
    }
    for (final entry in state.productUsageEntries) {
      entry.dispose();
    }
    for (final controller in unitPriceControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> initialize() async {
    await getTreatments();
  }

  Future<bool> getTreatments({int page = 1}) async {
    return await runSafely<bool?>(showLoading: false, () async {
          state = state.copyWith(loading: true, currentPage: page);
          await Future.delayed(const Duration(milliseconds: 500));
          state = state.copyWith(
            treatments: List.from(_localTreatments),
            filteredTreatments: _getFilteredList(_localTreatments),
            loading: false,
            totalPages: 1,
            totalResults: _localTreatments.length,
          );
          return true;
        }) ??
        false;
  }

  Future<bool?> callProtocol({
    required int stepNumber,
    required Uint8List bytes,
  }) async {
    final mediaService = MediaService();
    const String pdfName = 'clinicForm.pdf';

    return await runSafely(
      onLoadingChange: (loading) => state = state.copyWith(loading: loading),
      () async {
        final uploadedFile = await mediaService.uploadFile(
          'treatment/pdf',

          PlatformFile(name: pdfName, size: bytes.length, bytes: bytes),
        );
        if (uploadedFile != null) {
          final response = await _treatmentRepository.protocol(
            request: ProtocolRequest(
              stepNumber: stepNumber,
              clinicalProtocolPdf: ClinicalProtocolPdf(
                name: pdfName,
                url: uploadedFile,
              ),
            ),
            draftID: state.draftTreatmentID ?? 0,
          );

          return response.isSuccess;
        }
        throw const UnknownException('Failed to upload');
      },
    );
  }

  void resetForm() {
    globalSkuController.clear();
    internalNameController.clear();
    displayNameController.clear();
    fullDescriptionController.clear();
    shortDescriptionController.clear();
    basePriceController.clear();
    durationHoursController.clear();
    durationMinutesController.clear();
    treatmentDurationController.clear();
    prepTimeController.clear();
    cleanupTimeController.clear();
    minimumBookingNoticeController.clear();
    maximumDaysInAdvanceController.clear();
    preTreatmentInstructionsController.clear();
    postTreatmentInstructionsController.clear();
    preNotificationTitleController.clear();
    preNotificationDescriptionController.clear();
    postNotificationTitleController.clear();
    postNotificationDescriptionController.clear();
    totalFollowUpsController.clear();
    totalSessionsController.clear();
    followUpDurationValueController.clear();
    followUpNotesController.clear();
    postTreatmentPhotoCountController.text = '0';
    protocolNameController.clear();
    categoryIdController.clear();
    categoryNameController.clear();
    categoryPathController.clear();
    unitPriceControllers.clear();

    for (final entry in state.sessions) {
      entry.dispose();
    }
    for (final entry in state.productUsageEntries) {
      entry.dispose();
    }

    for (final area in state.areas) {
      area.dispose();
    }

    state = state.copyWith(
      currentStep: 0,
      treatmentImage: null,
      treatmentIcon: null,
      preTreatmentAttachments: [],
      postTreatmentAttachments: [],
      existingPreAttachments: [],
      existingPostAttachments: [],
      preTreatmentConsentForm: null,
      existingConsentForm: null,
      preNotificationSource: 'category',
      postNotificationSource: 'category',
      preNotificationEntries: [],
      postNotificationEntries: [],
      downtimeLevel: 'None',
      providerRolesSource: 'category',
      selectedRoles: [],
      areas: [AreaViewModelEntry()],
      sessions: [SessionViewModelEntry(sessionNumber: 1)],
      sessionSource: 'category',
      totalSessions: 1,
      productUsageEntries: [],
      requirePostTreatmentPhotos: false,
      requiredPostTreatmentPhotoCount: 0,
      selectedTreatment: null,
      useInAiSimulator: false,
      enableByDefault: false,
      selectedProtocolIds: [],
      status: 'active',
      isFollowUpRequired: false,
    );
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

  void updateProtocolNotes(
    String protocolName,
    List<TreatmentProtocolNoteItem> notes,
  ) {
    final List<TreatmentProtocolNote> currentNotes = List.from(
      state.selectedProtocolNotes,
    );
    final index = currentNotes.indexWhere(
      (n) => n.protocolName == protocolName,
    );

    if (index != -1) {
      currentNotes[index] = TreatmentProtocolNote(
        protocolName: protocolName,
        notes: notes,
      );
    } else {
      currentNotes.add(
        TreatmentProtocolNote(protocolName: protocolName, notes: notes),
      );
    }
    state = state.copyWith(selectedProtocolNotes: currentNotes);
  }

  void updateStandaloneNotes(List<TreatmentProtocolNoteItem> notes) {
    state = state.copyWith(standaloneNotes: notes);
  }

  void setStatus(String status) {
    state = state.copyWith(status: status);
  }

  void updateFollowUpCount(String val) {
    // Deprecated
  }

  void updateFollowUpEntry(
    int index, {
    String? type,
    String? durationUnit,
    String? intervalUnit,
  }) {
    // Deprecated
  }

  void selectTreatment(TreatmentModel treatment) {
    state = state.copyWith(selectedTreatment: treatment);

    // Populate controllers for editing
    globalSkuController.text = treatment.globalSku ?? '';
    internalNameController.text = treatment.name ?? '';
    displayNameController.text = treatment.patientDisplayName ?? '';
    fullDescriptionController.text = treatment.description ?? '';
    shortDescriptionController.text = treatment.shortDescription ?? '';
    basePriceController.text = treatment.basePrice?.toString() ?? '';
    unitPriceControllers.clear();
    if (treatment.unitPrices != null) {
      treatment.unitPrices!.forEach((unit, price) {
        unitPriceControllers[unit] = TextEditingController(
          text: price.toString(),
        );
      });
    }
    durationHoursController.text =
        treatment.baseDurationHours?.toString() ?? '';
    durationMinutesController.text =
        treatment.baseDurationMinutes?.toString() ?? '';

    final totalDurationInMinutes =
        (treatment.baseDurationHours ?? 0) * 60 +
        (treatment.baseDurationMinutes ?? 0);
    treatmentDurationController.text = totalDurationInMinutes > 0
        ? totalDurationInMinutes.toString()
        : '';
    prepTimeController.text = treatment.prepTime.toString();
    cleanupTimeController.text = treatment.cleanupTime.toString();
    minimumBookingNoticeController.text = treatment.minimumBookingNotice
        .toString();
    maximumDaysInAdvanceController.text = treatment.maximumDaysInAdvance
        .toString();
    preTreatmentInstructionsController.text =
        treatment.preTreatmentInstructions ?? '';
    postTreatmentInstructionsController.text =
        treatment.postTreatmentInstructions ?? '';

    preNotificationTitleController.text =
        treatment.preTreatmentNotificationTitle ?? '';
    preNotificationDescriptionController.text =
        treatment.preTreatmentNotificationDescription ?? '';
    postNotificationTitleController.text =
        treatment.postTreatmentNotificationTitle ?? '';
    postNotificationDescriptionController.text =
        treatment.postTreatmentNotificationDescription ?? '';

    // Dispose old notification entries
    for (final entry in state.preNotificationEntries) {
      entry.dispose();
    }
    for (final entry in state.postNotificationEntries) {
      entry.dispose();
    }

    final List<NotificationEntry> newPreNotifications = treatment
        .preNotifications
        .map(
          (config) => NotificationEntry(
            titleController: TextEditingController(text: config.title),
            messageController: TextEditingController(text: config.message),
            timingValueController: TextEditingController(
              text: config.timing?.toString(),
            ),
            timingUnit: config.timingUnit ?? 'hours',
            type: config.type ?? 'reminder',
          ),
        )
        .toList();

    final List<NotificationEntry> newPostNotifications = treatment
        .postNotifications
        .map(
          (config) => NotificationEntry(
            titleController: TextEditingController(text: config.title),
            messageController: TextEditingController(text: config.message),
            timingValueController: TextEditingController(
              text: config.timing?.toString(),
            ),
            timingUnit: config.timingUnit ?? 'hours',
            type: config.type ?? 'care',
          ),
        )
        .toList();

    // Sessions and Follow Ups
    for (final entry in state.sessions) {
      entry.dispose();
    }
    final List<SessionViewModelEntry> newSessions = [];
    if (treatment.sessions != null && treatment.sessions!.isNotEmpty) {
      for (final s in treatment.sessions!) {
        final sessionEntry = SessionViewModelEntry(
          sessionNumber: s.sessionNumber,
          totalFollowUpsController: TextEditingController(
            text: s.followUps.length.toString(),
          ),
          followUps: s.followUps
              .map(
                (fu) => FollowUpEntry(
                  type: fu.type,
                  durationUnit: fu.durationUnit,
                  durationValueController: TextEditingController(
                    text: fu.durationValue?.toString() ?? '',
                  ),
                  notesController: TextEditingController(text: fu.notes ?? ''),
                  intervalValueController: TextEditingController(
                    text: fu.intervalValue?.toString() ?? '',
                  ),
                  intervalUnit: fu.intervalUnit ?? 'days',
                  isImageRequired: fu.isImageRequired,
                ),
              )
              .toList(),
        );
        newSessions.add(sessionEntry);
      }
    } else {
      newSessions.add(SessionViewModelEntry(sessionNumber: 1));
    }

    // Product Usages
    for (final entry in state.productUsageEntries) {
      entry.dispose();
    }
    final List<ProductUsageEntry> newProductUsageEntries = [];
    if (treatment.productUsages != null) {
      for (final usage in treatment.productUsages!) {
        newProductUsageEntries.add(
          ProductUsageEntry(
            productId: usage.productId,
            productName: usage.productName,
            unit: usage.unit,
            usageType: usage.usageType,
            deductionTiming: usage.deductionTiming,
            allowSubstitution: usage.allowSubstitution,
            minQuantityController: TextEditingController(
              text: usage.minQuantity?.toString() ?? '0',
            ),
            maxQuantityController: TextEditingController(
              text: usage.maxQuantity?.toString() ?? '0',
            ),
            notesController: TextEditingController(text: usage.notes ?? ''),
            perUnitDurationController: TextEditingController(
              text: usage.perUnitDuration?.toString() ?? '0.0',
            ),
            initialSubAreaConsumptions: usage.subAreaConsumptions,
          ),
        );
      }
    }

    categoryIdController.text = treatment.categoryId ?? '';
    categoryNameController.text = treatment.categoryName ?? '';
    categoryPathController.text = treatment.categoryPath ?? '';
    postTreatmentPhotoCountController.text = treatment
        .requiredPostTreatmentPhotoCount
        .toString();

    // Clear and re-populate areas
    for (final area in state.areas) {
      area.dispose();
    }

    final List<AreaViewModelEntry> newAreas = [];
    if (treatment.sideAreas != null && treatment.sideAreas!.isNotEmpty) {
      for (final area in treatment.sideAreas!) {
        final entry = AreaViewModelEntry();
        entry.areaController.text = area.name ?? '';
        if (area.subAreas != null) {
          entry.subAreas = area.subAreas!
              .map(
                (s) => SubAreaConfig(
                  name: s.name ?? '',
                  basePrice: s.basePrice?.toString(),
                  unitPrices: s.unitPrices,
                ),
              )
              .toList();
        }
        newAreas.add(entry);
      }
    } else {
      newAreas.add(AreaViewModelEntry());
    }

    state = state.copyWith(
      areas: newAreas,
      status: treatment.status,
      treatmentImage: null,
      treatmentIcon: null,
      selectedProtocolIds: treatment.protocolIds ?? [],
      selectedProtocolNotes: treatment.protocolNotes ?? [],
      standaloneNotes: treatment.standaloneNotes ?? [],
      preTreatmentAttachments: [],
      postTreatmentAttachments: [],
      existingPreAttachments: treatment.preTreatmentAttachments ?? [],
      existingPostAttachments: treatment.postTreatmentAttachments ?? [],
      preTreatmentConsentForm: null,
      existingConsentForm: treatment.preTreatmentConsentForm,
      preNotificationSource: treatment.preNotificationSource,
      postNotificationSource: treatment.postNotificationSource,
      preNotificationEntries: newPreNotifications,
      postNotificationEntries: newPostNotifications,
      downtimeLevel: treatment.downtimeLevel,
      providerRolesSource: treatment.providerRolesSource,
      selectedRoles: treatment.allowedRoles,
      sessionSource: treatment.sessionSource,
      totalSessions: treatment.totalSessions,
      sessions: newSessions,
      productUsageEntries: newProductUsageEntries,
      requirePostTreatmentPhotos: treatment.requirePostTreatmentPhotos,
      requiredPostTreatmentPhotoCount:
          treatment.requiredPostTreatmentPhotoCount,
      isFollowUpRequired: treatment.isFollowUpRequired,
      useInAiSimulator: treatment.useInAiSimulator,
      enableByDefault: treatment.enableByDefault,
      preNotificationOffset: treatment.preTreatmentNotificationOffset,
      postNotificationOffset: treatment.postTreatmentNotificationOffset,
      prepTime: treatment.prepTime,
      cleanupTime: treatment.cleanupTime,
      allowClinicOverride: treatment.allowClinicOverride,
      allowProviderOverride: treatment.allowProviderOverride,
      onlineBookable: treatment.onlineBookable,
      manualApprovalRequired: treatment.manualApprovalRequired,
      minimumBookingNotice: treatment.minimumBookingNotice,
      maximumDaysInAdvance: treatment.maximumDaysInAdvance,
    );
  }

  void setPreNotificationSource(String source, {CategoryDetailDto? category}) {
    state = state.copyWith(preNotificationSource: source);
    final detail = category ?? state.selectedCategoryDetail;
    if (source == 'category' && detail != null) {
      state = state.copyWith(
        preNotificationEntries:
            detail.preNotifications
                ?.map(
                  (config) => NotificationEntry(
                    titleController: TextEditingController(text: config.title),
                    messageController: TextEditingController(
                      text: config.message,
                    ),
                    timingValueController: TextEditingController(
                      text: config.timing.toString(),
                    ),
                    timingUnit:
                        unitValues.reverse[config.timingUnit] ?? 'hours',
                    type: typeValues.reverse[config.type] ?? 'reminder',
                  ),
                )
                .toList() ??
            [],
      );
    }
  }

  void setPostNotificationSource(String source, {CategoryDetailDto? category}) {
    state = state.copyWith(postNotificationSource: source);
    final detail = category ?? state.selectedCategoryDetail;
    if (source == 'category' && detail != null) {
      state = state.copyWith(
        postNotificationEntries:
            detail.postNotifications
                ?.map(
                  (config) => NotificationEntry(
                    titleController: TextEditingController(text: config.title),
                    messageController: TextEditingController(
                      text: config.message,
                    ),
                    timingValueController: TextEditingController(
                      text: config.timing.toString(),
                    ),
                    timingUnit:
                        unitValues.reverse[config.timingUnit] ?? 'hours',
                    type: typeValues.reverse[config.type] ?? 'care',
                  ),
                )
                .toList() ??
            [],
      );
    }
  }

  void setDowntimeLevel(String level) =>
      state = state.copyWith(downtimeLevel: level);
  void setProviderRolesSource(String source) =>
      state = state.copyWith(providerRolesSource: source);

  void setSessionSource(String source, {CategoryDetailDto? category}) {
    state = state.copyWith(sessionSource: source);
    final detail = category ?? state.selectedCategoryDetail;
    if (source == 'category' && detail != null) {
      for (final entry in state.sessions) {
        entry.dispose();
      }
      final List<SessionViewModelEntry> newSessions = [];
      final defaultSessions = detail.defaultSessions;
      if (defaultSessions != null && defaultSessions.isNotEmpty) {
        for (final s in defaultSessions) {
          newSessions.add(
            SessionViewModelEntry(
              sessionNumber: s.sessionNumber,
              totalFollowUpsController: TextEditingController(
                text: s.followUps.length.toString(),
              ),
              followUps: s.followUps
                  .map(
                    (fu) => FollowUpEntry(
                      type: fu.type ?? '',
                      durationUnit:
                          unitValues.reverse[fu.durationUnit] ?? 'minutes',
                      durationValueController: TextEditingController(
                        text: (fu.durationValue ?? 0).toString(),
                      ),
                      notesController: TextEditingController(
                        text: fu.notes ?? '',
                      ),
                      intervalValueController: TextEditingController(
                        text: (fu.intervalValue ?? 0).toString(),
                      ),
                      intervalUnit: fu.intervalUnit ?? '',
                      isImageRequired: fu.isImageRequired ?? false,
                    ),
                  )
                  .toList(),
            ),
          );
        }
      } else {
        final int sessionCount = detail.totalSessions ?? 0;
        for (int i = 0; i < sessionCount; i++) {
          newSessions.add(
            SessionViewModelEntry(
              sessionNumber: i + 1,
              totalFollowUpsController: TextEditingController(text: '0'),
              followUps: [],
            ),
          );
        }
      }
      state = state.copyWith(
        totalSessions: newSessions.length,
        sessions: newSessions,
      );
    }
  }

  void toggleAllowClinicOverride(bool? val) =>
      state = state.copyWith(allowClinicOverride: val ?? false);
  void toggleAllowProviderOverride(bool? val) =>
      state = state.copyWith(allowProviderOverride: val ?? false);
  void toggleOnlineBookable(bool? val) =>
      state = state.copyWith(onlineBookable: val ?? false);
  void toggleManualApprovalRequired(bool? val) =>
      state = state.copyWith(manualApprovalRequired: val ?? false);

  void setTotalSessions(String val) {
    final count = int.tryParse(val) ?? 1;
    if (count < 1) return;

    final List<SessionViewModelEntry> updated = List.from(state.sessions);

    if (count > updated.length) {
      for (int i = updated.length; i < count; i++) {
        updated.add(SessionViewModelEntry(sessionNumber: i + 1));
      }
    } else if (count < updated.length) {
      for (int i = count; i < updated.length; i++) {
        updated[i].dispose();
      }
      updated.removeRange(count, updated.length);
    }

    state = state.copyWith(totalSessions: count, sessions: updated);
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

  void toggleRole(String role) {
    final List<String> current = List.from(state.selectedRoles);
    if (current.contains(role)) {
      current.remove(role);
    } else {
      current.add(role);
    }
    state = state.copyWith(selectedRoles: current);
  }

  Future<bool?> createBasicInfo({
    required int stepNumber,
    // required String globalSku,
    // required String patientDisplayName,
    // required String shortDescription,
    // required String description,
  }) async {
    return await runSafely<bool>(() async {
      if (state.treatmentIcon == null || state.treatmentImage == null) {
        throw const UnknownException('Please Select Image & Icon');
      }
      final String? imageUrl = await MediaService().uploadImage(
        'treatment/image/',
        state.treatmentImage!,
      );
      if (imageUrl == null) {
        throw const UnknownException('Failed to upload image');
      }
      final String? iconUrl = await MediaService().uploadImage(
        'treatment/icon/',
        state.treatmentIcon!,
      );
      if (iconUrl == null) {
        throw const UnknownException('Failed to upload Icon');
      }

      final response = await _treatmentRepository.createBasicInfo(
        BasicInfoRequest(
          stepNumber: stepNumber,
          selectedCategoryIds: state.selectedCategoryPath,
          patientDisplayName: displayNameController.text,
          image: imageUrl,
          shortDescription: shortDescriptionController.text,
          description: fullDescriptionController.text,
          globalSku: globalSkuController.text,
          icon: iconUrl,
        ),
      );
      if (response.isSuccess) {
        state = state.copyWith(draftTreatmentID: response.data?.id);
      }
      return true;
    });
  }

  void setRoles(List<String> roles) =>
      state = state.copyWith(selectedRoles: roles);

  void setStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  Future<void> pickImage(bool isIcon) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (isIcon) {
        state = state.copyWith(treatmentIcon: image);
      } else {
        state = state.copyWith(treatmentImage: image);
      }
    }
  }

  List<int> _findPathToCategory(
    List<CategoryModel> items,
    int id,
    List<int> currentPath,
  ) {
    for (final item in items) {
      if (item.id == id) return [...currentPath, item.id];
      if (item.subCategories.isNotEmpty) {
        final path = _findPathToCategory(item.subCategories, id, [
          ...currentPath,
          item.id,
        ]);
        if (path.isNotEmpty) return path;
      }
    }
    return [];
  }

  Future<void> onCategorySelected(CategoryModel category, String path) async {
    categoryIdController.text = category.id.toString();
    categoryNameController.text = category.name;
    categoryPathController.text = path;

    // Build the ID path to category recursively
    final allCategories = ref.read(categoryViewModelProvider).categories;
    final pathIds = _findPathToCategory(allCategories, category.id, []);

    // Clear previously loaded detail and reset defaults if category changes
    state = state.copyWith(
      selectedCategoryDetail: null,
      selectedCategoryPath: pathIds,
    );
  }

  Future<bool> fetchAndPopulateCategoryDefaults(int categoryId) async {
    return await runSafely<bool>(showLoading: true, () async {
          final detail = await _categoryRepository.getCategoryDetail(
            categoryId,
          );
          state = state.copyWith(selectedCategoryDetail: detail);

          // Auto-populate defaults if sources are set to 'category'

          // 1. Sessions & Follow Ups
          if (state.sessionSource == 'category') {
            _syncSessionsWithCategory(detail);
          }

          // 2. Notifications
          if (state.preNotificationSource == 'category') {
            _syncNotificationsWithCategory(detail, isPre: true);
          }
          if (state.postNotificationSource == 'category') {
            _syncNotificationsWithCategory(detail, isPre: false);
          }

          // 3. Provider Roles
          if (state.providerRolesSource == 'category') {
            final roles =
                detail.defaultRoles
                    ?.map((r) => defaultRoleValues.reverse[r] ?? '')
                    .toList() ??
                [];
            state = state.copyWith(selectedRoles: roles);
          }

          // 4. Downtime - The UI logic uses selectedCategoryDetail.downtimePresets
          // No explicit state update needed here as it's reactive in the UI

          return true;
        }) ??
        false;
  }

  void _syncSessionsWithCategory(CategoryDetailDto detail) {
    for (final entry in state.sessions) {
      entry.dispose();
    }
    final List<SessionViewModelEntry> newSessions = [];
    if (detail.defaultSessions?.isNotEmpty == true) {
      for (final s in detail.defaultSessions!) {
        newSessions.add(
          SessionViewModelEntry(
            sessionNumber: s.sessionNumber,
            totalFollowUpsController: TextEditingController(
              text: s.followUps.length.toString(),
            ),
            followUps: s.followUps
                .map(
                  (fu) => FollowUpEntry(
                    type: fu.type ?? '',
                    durationUnit:
                        unitValues.reverse[fu.durationUnit] ?? 'minutes',
                    durationValueController: TextEditingController(
                      text: (fu.durationValue ?? 0).toString(),
                    ),
                    notesController: TextEditingController(
                      text: fu.notes ?? '',
                    ),
                    intervalValueController: TextEditingController(
                      text: (fu.intervalValue ?? 0).toString(),
                    ),
                    intervalUnit: fu.intervalUnit ?? '',
                    isImageRequired: fu.isImageRequired ?? false,
                  ),
                )
                .toList(),
          ),
        );
      }
    } else {
      final int sessionCount = detail.totalSessions ?? 0;
      for (int i = 0; i < sessionCount; i++) {
        newSessions.add(
          SessionViewModelEntry(
            sessionNumber: i + 1,
            totalFollowUpsController: TextEditingController(text: '0'),
            followUps: [],
          ),
        );
      }
    }
    state = state.copyWith(
      totalSessions: newSessions.length,
      sessions: newSessions,
    );
  }

  void _syncNotificationsWithCategory(
    CategoryDetailDto detail, {
    required bool isPre,
  }) {
    final notifications = isPre
        ? detail.preNotifications
        : detail.postNotifications;
    final entries =
        notifications
            ?.map(
              (config) => NotificationEntry(
                titleController: TextEditingController(text: config.title),
                messageController: TextEditingController(text: config.message),
                timingValueController: TextEditingController(
                  text: config.timing.toString(),
                ),
                timingUnit: unitValues.reverse[config.timingUnit] ?? 'hours',
                type:
                    typeValues.reverse[config.type] ??
                    (isPre ? 'reminder' : 'care'),
              ),
            )
            .toList() ??
        [];

    if (isPre) {
      state = state.copyWith(preNotificationEntries: entries);
    } else {
      state = state.copyWith(postNotificationEntries: entries);
    }
  }

  void selectCategoryAtLevel(
    int level,
    CategoryModel category,
    List<CategoryModel> allCategories,
  ) {
    List<int> currentPath = List.from(state.selectedCategoryPath);

    if (level < currentPath.length) {
      currentPath = currentPath.sublist(0, level);
    }

    currentPath.add(category.id);

    String fullPath = '';
    for (int i = 0; i < currentPath.length; i++) {
      final node = _findCategoryById(allCategories, currentPath[i]);
      if (node != null) {
        fullPath += (i == 0 ? '' : ' > ') + node.name;
      }
    }

    categoryIdController.text = category.id.toString();
    categoryNameController.text = category.name;
    categoryPathController.text = fullPath;

    state = state.copyWith(selectedCategoryPath: currentPath);
    onCategorySelected(category, fullPath);
  }

  CategoryModel? findCategoryById(List<CategoryModel> items, String id) {
    final intId = int.tryParse(id);
    if (intId == null) return null;
    for (final item in items) {
      if (item.id == intId) return item;
      if (item.subCategories.isNotEmpty) {
        final found = findCategoryById(item.subCategories, id);
        if (found != null) return found;
      }
    }
    return null;
  }

  CategoryModel? _findCategoryById(List<CategoryModel> items, int id) {
    for (final item in items) {
      if (item.id == id) return item;
      if (item.subCategories.isNotEmpty) {
        final found = _findCategoryById(item.subCategories, id);
        if (found != null) return found;
      }
    }
    return null;
  }

  void onAreaSelected(int index, String val) {
    state.areas[index].subAreaController.clear();
    final updatedAreas = [...state.areas];
    for (final sub in updatedAreas[index].subAreas) {
      sub.dispose();
    }
    updatedAreas[index].subAreas = [];
    state = state.copyWith(areas: updatedAreas);
  }

  void addArea() {
    state = state.copyWith(areas: [...state.areas, AreaViewModelEntry()]);
  }

  void removeArea(int index) {
    final updatedAreas = [...state.areas];
    updatedAreas[index].dispose();
    updatedAreas.removeAt(index);
    state = state.copyWith(areas: updatedAreas);
  }

  void addSubArea(int areaIndex, String val) {
    if (val.isNotEmpty &&
        !state.areas[areaIndex].subAreas.any((s) => s.name == val)) {
      final updatedAreas = [...state.areas];
      updatedAreas[areaIndex].subAreas = [
        ...updatedAreas[areaIndex].subAreas,
        SubAreaConfig(name: val),
      ];
      updatedAreas[areaIndex].subAreaController.clear();
      state = state.copyWith(areas: updatedAreas);
    }
  }

  void removeSubArea(int areaIndex, String subAreaName) {
    final updatedAreas = [...state.areas];
    final subAreaToRemove = updatedAreas[areaIndex].subAreas.firstWhere(
      (s) => s.name == subAreaName,
    );
    subAreaToRemove.dispose();
    updatedAreas[areaIndex].subAreas = updatedAreas[areaIndex].subAreas
        .where((s) => s.name != subAreaName)
        .toList();
    state = state.copyWith(areas: updatedAreas);
  }

  void addPreNotificationEntry() {
    state = state.copyWith(
      preNotificationEntries: [
        ...state.preNotificationEntries,
        NotificationEntry(
          titleController: TextEditingController(),
          messageController: TextEditingController(),
          timingValueController: TextEditingController(),
          timingUnit: 'hours',
          type: 'reminder',
        ),
      ],
    );
  }

  void removePreNotificationEntry(int index) {
    final list = List<NotificationEntry>.from(state.preNotificationEntries);
    final removed = list.removeAt(index);
    removed.dispose();
    state = state.copyWith(preNotificationEntries: list);
  }

  void addPostNotificationEntry() {
    state = state.copyWith(
      postNotificationEntries: [
        ...state.postNotificationEntries,
        NotificationEntry(
          titleController: TextEditingController(),
          messageController: TextEditingController(),
          timingValueController: TextEditingController(),
          timingUnit: 'hours',
          type: 'care',
        ),
      ],
    );
  }

  void removePostNotificationEntry(int index) {
    final list = List<NotificationEntry>.from(state.postNotificationEntries);
    final removed = list.removeAt(index);
    removed.dispose();
    state = state.copyWith(postNotificationEntries: list);
  }

  // Step 4 Actions
  void toggleAiSimulator(bool? value) {
    state = state.copyWith(useInAiSimulator: value ?? false);
  }

  void toggleRequirePostTreatmentPhotos(bool? value) {
    state = state.copyWith(requirePostTreatmentPhotos: value ?? false);
    if (!(value ?? false)) {
      postTreatmentPhotoCountController.text = '0';
      state = state.copyWith(requiredPostTreatmentPhotoCount: 0);
    }
  }

  void updateRequiredPostTreatmentPhotoCount(String value) {
    final count = int.tryParse(value) ?? 0;
    state = state.copyWith(requiredPostTreatmentPhotoCount: count);
  }

  void toggleEnableByDefault(bool? value) {
    state = state.copyWith(enableByDefault: value ?? false);
  }

  void addProductUsage(int productId, String productName, String unit) {
    if (state.productUsageEntries.any((e) => e.productId == productId)) return;

    final newEntry = ProductUsageEntry(
      productId: productId,
      productName: productName,
      unit: unit,
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
  }) {
    final updatedEntries = [...state.productUsageEntries];
    updatedEntries[index] = updatedEntries[index].copyWith(
      usageType: usageType,
      deductionTiming: deductionTiming,
      allowSubstitution: allowSubstitution,
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

  void setPreNotificationOffset(int? offset) {
    state = state.copyWith(preNotificationOffset: offset);
  }

  void setPostNotificationOffset(int? offset) {
    state = state.copyWith(postNotificationOffset: offset);
  }

  Future<void> pickAttachments(bool isPreTreatment) async {
    final FilePickerResult? result = await FilePicker.pickFiles(
      allowMultiple: true,
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
      ],
    );

    if (result != null) {
      if (isPreTreatment) {
        state = state.copyWith(
          preTreatmentAttachments: [
            ...state.preTreatmentAttachments,
            ...result.files,
          ],
        );
      } else {
        state = state.copyWith(
          postTreatmentAttachments: [
            ...state.postTreatmentAttachments,
            ...result.files,
          ],
        );
      }
    }
  }

  Future<void> pickConsentForm() async {
    final FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      state = state.copyWith(preTreatmentConsentForm: result.files.first);
    }
  }

  void removeConsentForm() {
    state = state.copyWith(
      preTreatmentConsentForm: null,
      existingConsentForm: null,
    );
  }

  void setConsentType(String type) {
    state = state.copyWith(consentType: type);
  }

  void removeAttachment(bool isPreTreatment, int index) {
    if (isPreTreatment) {
      final updated = List<PlatformFile>.from(state.preTreatmentAttachments)
        ..removeAt(index);
      state = state.copyWith(preTreatmentAttachments: updated);
    } else {
      final updated = List<PlatformFile>.from(state.postTreatmentAttachments)
        ..removeAt(index);
      state = state.copyWith(postTreatmentAttachments: updated);
    }
  }

  void removeExistingAttachment(bool isPreTreatment, int index) {
    if (isPreTreatment) {
      final updated = List<Attachment>.from(state.existingPreAttachments)
        ..removeAt(index);
      state = state.copyWith(existingPreAttachments: updated);
    } else {
      final updated = List<Attachment>.from(state.existingPostAttachments)
        ..removeAt(index);
      state = state.copyWith(existingPostAttachments: updated);
    }
  }

  // Follow-Up Actions
  void toggleFollowUpRequired(bool? value) {
    state = state.copyWith(isFollowUpRequired: value ?? false);
    if (state.isFollowUpRequired &&
        state.sessions.isNotEmpty &&
        state.sessions[0].followUps.isEmpty) {
      updateSessionFollowUpCount(0, '1');
    }
  }

  // Filter Logic
  void _applyFilters() {
    final query = searchController.text.toLowerCase();
    final categoryPath = filterCategoryController.text.toLowerCase();
    final area = filterAreaController.text.toLowerCase();
    final status = filterStatusController.text.toLowerCase();

    state = state.copyWith(
      filteredTreatments: state.treatments.where((t) {
        final matchesQuery =
            query.isEmpty ||
            (t.name?.toLowerCase().contains(query) ?? false) ||
            (t.description?.toLowerCase().contains(query) ?? false);

        final matchesCategory =
            categoryPath.isEmpty ||
            (t.categoryPath?.toLowerCase().contains(categoryPath) ?? false);

        final matchesArea =
            area.isEmpty ||
            (t.sideAreas?.any((a) => a.name?.toLowerCase() == area) ?? false);

        final matchesStatus =
            status.isEmpty ||
            (status == 'active' && t.status == 'active') ||
            (status == 'deactive' && t.status == 'deactive') ||
            (status == 'draft' && t.status == 'draft');

        return matchesQuery && matchesCategory && matchesArea && matchesStatus;
      }).toList(),
    );
  }

  void onSearchChanged(String val) {
    _applyFilters();
  }

  void onFilterCategorySelected(String val) {
    filterSubcategoryController.clear();
    _applyFilters();
  }

  void onFilterAreaSelected(String val) {
    filterSubAreaController.clear();
    _applyFilters();
  }

  void onFilterChanged() {
    _applyFilters();
  }

  void clearFilters() {
    searchController.clear();
    filterCategoryController.clear();
    filterSubcategoryController.clear();
    filterAreaController.clear();
    filterSubAreaController.clear();
    filterStatusController.clear();
    _applyFilters();
  }

  void toggleTreatmentStatus(int treatmentId) {
    final index = _localTreatments.indexWhere((t) => t.id == treatmentId);
    if (index != -1) {
      final t = _localTreatments[index];
      _localTreatments[index] = t.copyWith(
        status: t.status == 'active' ? 'deactive' : 'active',
      );
    }

    state = state.copyWith(
      treatments: List.from(_localTreatments),
      filteredTreatments: _getFilteredList(_localTreatments),
    );
  }

  void deleteTreatment(int treatmentId) {
    _localTreatments.removeWhere((t) => t.id == treatmentId);
    state = state.copyWith(
      treatments: List.from(_localTreatments),
      filteredTreatments: _getFilteredList(_localTreatments),
    );
  }

  List<TreatmentModel> _getFilteredList(List<TreatmentModel> source) {
    final query = searchController.text.toLowerCase();
    final categoryPath = filterCategoryController.text.toLowerCase();
    final area = filterAreaController.text.toLowerCase();
    final status = filterStatusController.text.toLowerCase();

    return source.where((t) {
      final matchesQuery =
          query.isEmpty ||
          (t.name?.toLowerCase().contains(query) ?? false) ||
          (t.description?.toLowerCase().contains(query) ?? false);

      final matchesCategory =
          categoryPath.isEmpty ||
          (t.categoryPath?.toLowerCase().contains(categoryPath) ?? false);

      final matchesArea =
          area.isEmpty ||
          (t.sideAreas?.any((a) => a.name?.toLowerCase() == area) ?? false);

      final matchesStatus =
          status.isEmpty ||
          (status == 'active' && t.status == 'active') ||
          (status == 'deactive' && t.status == 'deactive') ||
          (status == 'draft' && t.status == 'draft');

      return matchesQuery && matchesCategory && matchesArea && matchesStatus;
    }).toList();
  }

  Future<void> submitTreatment(
    BuildContext context, {
    List<CategoryModel> categories = const [],
    bool isEdit = false,
  }) async {
    if (isEdit) {
      return updateTreatment(context, categories: categories);
    }
    return await runSafely<void>(showLoading: true, () async {
      final skuError = validateGlobalSku(globalSkuController.text.trim());
      if (skuError != null) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(skuError)));
        }
        return;
      }

      CategoryDetailDto? selectedCategory = state.selectedCategoryDetail;
      if (selectedCategory == null && categoryIdController.text.isNotEmpty) {
        final categoryId = int.tryParse(categoryIdController.text);
        if (categoryId != null) {
          try {
            selectedCategory = await _categoryRepository.getCategoryDetail(
              categoryId,
            );
          } catch (_) {}
        }
      }

      List<SessionConfig> effectiveSessions = [];

      List<NotificationConfig> effectivePreNotifications = [];
      if (state.preNotificationSource == 'category') {
        if (selectedCategory != null) {
          effectivePreNotifications =
              selectedCategory.preNotifications
                  ?.map(
                    (n) => NotificationConfig(
                      title: n.title,
                      message: n.message,
                      timing: n.timing,
                      timingUnit: unitValues.reverse[n.timingUnit] ?? 'hours',
                      type: typeValues.reverse[n.type] ?? 'reminder',
                    ),
                  )
                  .toList() ??
              [];
        }
      } else {
        effectivePreNotifications = state.preNotificationEntries
            .map((e) => e.toConfig())
            .toList();
      }

      List<NotificationConfig> effectivePostNotifications = [];
      if (state.postNotificationSource == 'category') {
        if (selectedCategory != null) {
          effectivePostNotifications =
              selectedCategory.postNotifications
                  ?.map(
                    (n) => NotificationConfig(
                      title: n.title,
                      message: n.message,
                      timing: n.timing,
                      timingUnit: unitValues.reverse[n.timingUnit] ?? 'hours',
                      type: typeValues.reverse[n.type] ?? 'care',
                    ),
                  )
                  .toList() ??
              [];
        }
      } else {
        effectivePostNotifications = state.postNotificationEntries
            .map((e) => e.toConfig())
            .toList();
      }

      if (state.sessionSource == 'category') {
        final defaultSessions = selectedCategory?.defaultSessions;
        if (selectedCategory != null &&
            defaultSessions != null &&
            defaultSessions.isNotEmpty) {
          effectiveSessions = defaultSessions
              .map(
                (s) => SessionConfig(
                  sessionNumber: s.sessionNumber,
                  followUps: s.followUps
                      .map(
                        (f) => FollowUpConfig(
                          type: f.type ?? '',
                          durationValue: f.durationValue ?? 0,
                          durationUnit:
                              unitValues.reverse[f.durationUnit] ?? 'minutes',
                          notes: f.notes ?? '',
                          intervalValue: f.intervalValue ?? 0,
                          intervalUnit: f.intervalUnit ?? '',
                          isImageRequired: f.isImageRequired ?? false,
                        ),
                      )
                      .toList(),
                ),
              )
              .toList();
        } else {
          final int sessionCount = selectedCategory?.totalSessions ?? 1;
          for (int i = 0; i < sessionCount; i++) {
            effectiveSessions.add(
              SessionConfig(sessionNumber: i + 1, followUps: []),
            );
          }
        }
      } else {
        effectiveSessions = state.sessions
            .map(
              (s) => SessionConfig(
                sessionNumber: s.sessionNumber,
                followUps: s.followUps
                    .map(
                      (fu) => FollowUpConfig(
                        type: fu.type,
                        durationValue: int.tryParse(
                          fu.durationValueController.text,
                        ),
                        durationUnit: fu.durationUnit,
                        notes: fu.notesController.text,
                        intervalValue: int.tryParse(
                          fu.intervalValueController.text,
                        ),
                        intervalUnit: fu.intervalUnit,
                        isImageRequired: fu.isImageRequired,
                      ),
                    )
                    .toList(),
              ),
            )
            .toList();
      }

      // ignore: unused_local_variable
      final treatment = TreatmentModel(
        globalSku: globalSkuController.text.trim(),
        name: internalNameController.text,
        patientDisplayName: displayNameController.text,
        description: fullDescriptionController.text,
        shortDescription: shortDescriptionController.text,
        basePrice: double.tryParse(basePriceController.text),
        unitPrices: (() {
          final Map<String, double> up = {};
          unitPriceControllers.forEach((unit, controller) {
            final val = double.tryParse(controller.text);
            if (val != null) {
              up[unit] = val;
            }
          });
          return up.isNotEmpty ? up : null;
        })(),
        baseDurationHours:
            (int.tryParse(treatmentDurationController.text) ?? 0) ~/ 60,
        baseDurationMinutes:
            (int.tryParse(treatmentDurationController.text) ?? 0) % 60,
        prepTime: int.tryParse(prepTimeController.text) ?? 0,
        cleanupTime: int.tryParse(cleanupTimeController.text) ?? 0,
        allowClinicOverride: state.allowClinicOverride,
        allowProviderOverride: state.allowProviderOverride,
        onlineBookable: state.onlineBookable,
        manualApprovalRequired: state.manualApprovalRequired,
        minimumBookingNotice:
            int.tryParse(minimumBookingNoticeController.text) ?? 24,
        maximumDaysInAdvance:
            int.tryParse(maximumDaysInAdvanceController.text) ?? 90,
        categoryId: categoryIdController.text,
        categoryName: categoryNameController.text,
        categoryPath: categoryPathController.text,
        status: state.status,
        useInAiSimulator: state.useInAiSimulator,
        protocolIds: state.selectedProtocolIds,
        protocolNotes: state.selectedProtocolNotes,
        standaloneNotes: state.standaloneNotes,
        preTreatmentInstructions: preTreatmentInstructionsController.text,
        postTreatmentInstructions: postTreatmentInstructionsController.text,
        preNotificationSource: state.preNotificationSource,
        postNotificationSource: state.postNotificationSource,
        preTreatmentNotificationTitle: preNotificationTitleController.text,
        preTreatmentNotificationDescription:
            preNotificationDescriptionController.text,
        preTreatmentNotificationOffset: state.preNotificationOffset,
        postTreatmentNotificationTitle: postNotificationTitleController.text,
        postTreatmentNotificationDescription:
            postNotificationDescriptionController.text,
        postTreatmentNotificationOffset: state.postNotificationOffset,
        preNotifications: effectivePreNotifications,
        postNotifications: effectivePostNotifications,
        sessionSource: state.sessionSource,
        totalSessions: state.totalSessions,
        sessions: effectiveSessions,
        downtimeLevel: state.downtimeLevel,
        providerRolesSource: state.providerRolesSource,
        allowedRoles: state.selectedRoles,
        preTreatmentAttachments: [
          ...state.existingPreAttachments,
          ...state.preTreatmentAttachments.map(
            (f) => Attachment(
              url: f.path ?? '',
              type: _getFileType(f),
              name: f.name,
            ),
          ),
        ],
        postTreatmentAttachments: [
          ...state.existingPostAttachments,
          ...state.postTreatmentAttachments.map(
            (f) => Attachment(
              url: f.path ?? '',
              type: _getFileType(f),
              name: f.name,
            ),
          ),
        ],
        preTreatmentConsentForm: state.consentType == 'custom'
            ? (state.preTreatmentConsentForm != null
                  ? Attachment(
                      url: state.preTreatmentConsentForm!.path ?? '',
                      type: 'pdf',
                      name: state.preTreatmentConsentForm!.name,
                    )
                  : state.existingConsentForm)
            : null,
        requirePostTreatmentPhotos: state.requirePostTreatmentPhotos,
        requiredPostTreatmentPhotoCount: state.requiredPostTreatmentPhotoCount,
        isFollowUpRequired: state.isFollowUpRequired,
        productUsages: state.productUsageEntries.map((e) {
          final List<SubAreaConsumption> subAreaConsumptions = [];
          e.subAreaControllers.forEach((subName, controllers) {
            final minVal =
                double.tryParse(controllers.minController.text) ?? 0.0;
            final maxVal =
                double.tryParse(controllers.maxController.text) ?? 0.0;
            subAreaConsumptions.add(
              SubAreaConsumption(
                subAreaName: subName,
                minQuantity: minVal,
                maxQuantity: maxVal,
              ),
            );
          });
          return ProductUsageModel(
            productId: e.productId,
            productName: e.productName,
            usageType: e.usageType,
            minQuantity: double.tryParse(e.minQuantityController.text),
            maxQuantity: double.tryParse(e.maxQuantityController.text),
            deductionTiming: e.deductionTiming,
            allowSubstitution: e.allowSubstitution,
            notes: e.notesController.text,
            unit: e.unit,
            perUnitDuration: double.tryParse(e.perUnitDurationController.text),
            subAreaConsumptions: subAreaConsumptions,
          );
        }).toList(),
        sideAreas: state.areas
            .map(
              (a) => SideAreaModel(
                name: a.areaController.text,
                subAreas: a.subAreas.map((s) {
                  final Map<String, double> unitPrices = {};
                  s.unitPriceControllers.forEach((unit, controller) {
                    final val = double.tryParse(controller.text);
                    if (val != null) {
                      unitPrices[unit] = val;
                    }
                  });
                  return SubAreaModel(
                    name: s.name,
                    basePrice: double.tryParse(s.basePriceController.text),
                    unitPrices: unitPrices,
                    children: s.children.map((c) {
                      final Map<String, double> childUnitPrices = {};
                      c.unitPriceControllers.forEach((unit, controller) {
                        final val = double.tryParse(controller.text);
                        if (val != null) {
                          childUnitPrices[unit] = val;
                        }
                      });
                      return SubAreaModel(
                        name: c.name,
                        basePrice: double.tryParse(c.basePriceController.text),
                        unitPrices: childUnitPrices,
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
            )
            .toList(),
      );

      // Perform API call using treatment.toRequest()
      // await _treatmentRepository.createTreatment(treatment.toRequest());

      final newId = _localTreatments.isEmpty
          ? 1
          : (_localTreatments
                    .map((t) => t.id ?? 0)
                    .reduce((a, b) => a > b ? a : b) +
                1);
      final treatmentWithId = treatment.copyWith(id: newId);
      _localTreatments.add(treatmentWithId);

      await Future.delayed(const Duration(seconds: 1));
      resetForm();
      await getTreatments();
    });
  }

  String _getFileType(PlatformFile file) {
    final ext = file.extension?.toLowerCase();
    if (ext == 'pdf') return 'pdf';
    if (['jpg', 'jpeg', 'png', 'webp'].contains(ext)) return 'image';
    if (['mp4', 'mov', 'avi', 'mkv'].contains(ext)) return 'video';
    return 'other';
  }

  Future<void> updateTreatment(
    BuildContext context, {
    List<CategoryModel> categories = const [],
  }) async {
    return await runSafely<void>(showLoading: true, () async {
      final skuError = validateGlobalSku(
        globalSkuController.text.trim(),
        currentTreatmentId: state.selectedTreatment?.id,
      );
      if (skuError != null) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(skuError)));
        }
        return;
      }

      CategoryDetailDto? selectedCategory = state.selectedCategoryDetail;
      if (selectedCategory == null && categoryIdController.text.isNotEmpty) {
        final categoryId = int.tryParse(categoryIdController.text);
        if (categoryId != null) {
          try {
            selectedCategory = await _categoryRepository.getCategoryDetail(
              categoryId,
            );
          } catch (_) {}
        }
      }

      List<SessionConfig> effectiveSessions = [];

      List<NotificationConfig> effectivePreNotifications = [];
      if (state.preNotificationSource == 'category') {
        if (selectedCategory != null) {
          effectivePreNotifications =
              selectedCategory.preNotifications
                  ?.map(
                    (n) => NotificationConfig(
                      title: n.title,
                      message: n.message,
                      timing: n.timing,
                      timingUnit: unitValues.reverse[n.timingUnit] ?? 'hours',
                      type: typeValues.reverse[n.type] ?? 'reminder',
                    ),
                  )
                  .toList() ??
              [];
        }
      } else {
        effectivePreNotifications = state.preNotificationEntries
            .map((e) => e.toConfig())
            .toList();
      }

      List<NotificationConfig> effectivePostNotifications = [];
      if (state.postNotificationSource == 'category') {
        if (selectedCategory != null) {
          effectivePostNotifications =
              selectedCategory.postNotifications
                  ?.map(
                    (n) => NotificationConfig(
                      title: n.title,
                      message: n.message,
                      timing: n.timing,
                      timingUnit: unitValues.reverse[n.timingUnit] ?? 'hours',
                      type: typeValues.reverse[n.type] ?? 'care',
                    ),
                  )
                  .toList() ??
              [];
        }
      } else {
        effectivePostNotifications = state.postNotificationEntries
            .map((e) => e.toConfig())
            .toList();
      }

      if (state.sessionSource == 'category') {
        if (selectedCategory != null &&
            selectedCategory.defaultSessions != null &&
            selectedCategory.defaultSessions!.isNotEmpty) {
          effectiveSessions =
              selectedCategory.defaultSessions!
                  ?.map(
                    (s) => SessionConfig(
                      sessionNumber: s.sessionNumber,
                      followUps: s.followUps
                          .map(
                            (f) => FollowUpConfig(
                              type: f.type ?? '',
                              durationValue: f.durationValue ?? 0,
                              durationUnit:
                                  unitValues.reverse[f.durationUnit] ??
                                  'minutes',
                              notes: f.notes ?? '',
                              intervalValue: f.intervalValue ?? 0,
                              intervalUnit: f.intervalUnit ?? '',
                              isImageRequired: f.isImageRequired ?? false,
                            ),
                          )
                          .toList(),
                    ),
                  )
                  .toList() ??
              [];
        } else {
          final int sessionCount = selectedCategory?.totalSessions ?? 1;
          for (int i = 0; i < sessionCount; i++) {
            effectiveSessions.add(
              SessionConfig(sessionNumber: i + 1, followUps: []),
            );
          }
        }
      } else {
        effectiveSessions = state.sessions
            .map(
              (s) => SessionConfig(
                sessionNumber: s.sessionNumber,
                followUps: s.followUps
                    .map(
                      (fu) => FollowUpConfig(
                        type: fu.type,
                        durationValue: int.tryParse(
                          fu.durationValueController.text,
                        ),
                        durationUnit: fu.durationUnit,
                        notes: fu.notesController.text,
                        intervalValue: int.tryParse(
                          fu.intervalValueController.text,
                        ),
                        intervalUnit: fu.intervalUnit,
                        isImageRequired: fu.isImageRequired,
                      ),
                    )
                    .toList(),
              ),
            )
            .toList();
      }

      final treatment = TreatmentModel(
        id: state.selectedTreatment?.id,
        globalSku: globalSkuController.text.trim(),
        name: internalNameController.text,
        patientDisplayName: displayNameController.text,
        description: fullDescriptionController.text,
        shortDescription: shortDescriptionController.text,
        basePrice: double.tryParse(basePriceController.text),
        unitPrices: (() {
          final Map<String, double> up = {};
          unitPriceControllers.forEach((unit, controller) {
            final val = double.tryParse(controller.text);
            if (val != null) {
              up[unit] = val;
            }
          });
          return up.isNotEmpty ? up : null;
        })(),
        baseDurationHours:
            (int.tryParse(treatmentDurationController.text) ?? 0) ~/ 60,
        baseDurationMinutes:
            (int.tryParse(treatmentDurationController.text) ?? 0) % 60,
        prepTime: int.tryParse(prepTimeController.text) ?? 0,
        cleanupTime: int.tryParse(cleanupTimeController.text) ?? 0,
        allowClinicOverride: state.allowClinicOverride,
        allowProviderOverride: state.allowProviderOverride,
        onlineBookable: state.onlineBookable,
        manualApprovalRequired: state.manualApprovalRequired,
        minimumBookingNotice:
            int.tryParse(minimumBookingNoticeController.text) ?? 24,
        maximumDaysInAdvance:
            int.tryParse(maximumDaysInAdvanceController.text) ?? 90,
        categoryId: categoryIdController.text,
        categoryName: categoryNameController.text,
        categoryPath: categoryPathController.text,
        status: state.status,
        useInAiSimulator: state.useInAiSimulator,
        protocolIds: state.selectedProtocolIds,
        protocolNotes: state.selectedProtocolNotes,
        standaloneNotes: state.standaloneNotes,
        preTreatmentInstructions: preTreatmentInstructionsController.text,
        postTreatmentInstructions: postTreatmentInstructionsController.text,
        preNotificationSource: state.preNotificationSource,
        postNotificationSource: state.postNotificationSource,
        preTreatmentNotificationTitle: preNotificationTitleController.text,
        preTreatmentNotificationDescription:
            preNotificationDescriptionController.text,
        preTreatmentNotificationOffset: state.preNotificationOffset,
        postTreatmentNotificationTitle: postNotificationTitleController.text,
        postTreatmentNotificationDescription:
            postNotificationDescriptionController.text,
        postTreatmentNotificationOffset: state.postNotificationOffset,
        preNotifications: effectivePreNotifications,
        postNotifications: effectivePostNotifications,
        sessionSource: state.sessionSource,
        totalSessions: state.totalSessions,
        sessions: effectiveSessions,
        downtimeLevel: state.downtimeLevel,
        providerRolesSource: state.providerRolesSource,
        allowedRoles: state.selectedRoles,
        preTreatmentAttachments: [
          ...state.existingPreAttachments,
          ...state.preTreatmentAttachments.map(
            (f) => Attachment(
              url: f.path ?? '',
              type: _getFileType(f),
              name: f.name,
            ),
          ),
        ],
        postTreatmentAttachments: [
          ...state.existingPostAttachments,
          ...state.postTreatmentAttachments.map(
            (f) => Attachment(
              url: f.path ?? '',
              type: _getFileType(f),
              name: f.name,
            ),
          ),
        ],
        preTreatmentConsentForm: state.consentType == 'custom'
            ? (state.preTreatmentConsentForm != null
                  ? Attachment(
                      url: state.preTreatmentConsentForm!.path ?? '',
                      type: 'pdf',
                      name: state.preTreatmentConsentForm!.name,
                    )
                  : state.existingConsentForm)
            : null,
        requirePostTreatmentPhotos: state.requirePostTreatmentPhotos,
        requiredPostTreatmentPhotoCount: state.requiredPostTreatmentPhotoCount,
        isFollowUpRequired: state.isFollowUpRequired,
        productUsages: state.productUsageEntries.map((e) {
          final List<SubAreaConsumption> subAreaConsumptions = [];
          e.subAreaControllers.forEach((subName, controllers) {
            final minVal =
                double.tryParse(controllers.minController.text) ?? 0.0;
            final maxVal =
                double.tryParse(controllers.maxController.text) ?? 0.0;
            subAreaConsumptions.add(
              SubAreaConsumption(
                subAreaName: subName,
                minQuantity: minVal,
                maxQuantity: maxVal,
              ),
            );
          });
          return ProductUsageModel(
            productId: e.productId,
            productName: e.productName,
            usageType: e.usageType,
            minQuantity: double.tryParse(e.minQuantityController.text),
            maxQuantity: double.tryParse(e.maxQuantityController.text),
            deductionTiming: e.deductionTiming,
            allowSubstitution: e.allowSubstitution,
            notes: e.notesController.text,
            unit: e.unit,
            perUnitDuration: double.tryParse(e.perUnitDurationController.text),
            subAreaConsumptions: subAreaConsumptions,
          );
        }).toList(),
        sideAreas: state.areas
            .map(
              (a) => SideAreaModel(
                name: a.areaController.text,
                subAreas: a.subAreas.map((s) {
                  final Map<String, double> unitPrices = {};
                  s.unitPriceControllers.forEach((unit, controller) {
                    final val = double.tryParse(controller.text);
                    if (val != null) {
                      unitPrices[unit] = val;
                    }
                  });
                  return SubAreaModel(
                    name: s.name,
                    basePrice: double.tryParse(s.basePriceController.text),
                    unitPrices: unitPrices,
                    children: s.children.map((c) {
                      final Map<String, double> childUnitPrices = {};
                      c.unitPriceControllers.forEach((unit, controller) {
                        final val = double.tryParse(controller.text);
                        if (val != null) {
                          childUnitPrices[unit] = val;
                        }
                      });
                      return SubAreaModel(
                        name: c.name,
                        basePrice: double.tryParse(c.basePriceController.text),
                        unitPrices: childUnitPrices,
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
            )
            .toList(),
      );

      final idx = _localTreatments.indexWhere(
        (t) => t.id == state.selectedTreatment!.id,
      );
      if (idx != -1) {
        _localTreatments[idx] = treatment;
      }

      state = state.copyWith(
        treatments: List.from(_localTreatments),
        filteredTreatments: _getFilteredList(_localTreatments),
      );

      await Future.delayed(const Duration(seconds: 1));
      await getTreatments();
    });
  }

  String? validateGlobalSku(String? sku, {int? currentTreatmentId}) {
    if (sku == null || sku.isEmpty) {
      return 'Global SKU is required';
    }
    if (sku.contains(' ')) {
      return 'No spaces allowed';
    }
    final regex = RegExp(r'^TRT-[A-Z0-9]{4}-[A-Z0-9]{4}$');
    if (!regex.hasMatch(sku)) {
      return 'Invalid format. Must be TRT-XXXX-XXXX.';
    }
    final isUnique = !state.treatments.any(
      (t) => t.globalSku == sku && t.id != currentTreatmentId,
    );
    if (!isUnique) {
      return 'SKU already exists.';
    }
    return null;
  }

  void generateSku() {
    final rand = math.Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    String generated;
    final currentId = state.selectedTreatment?.id;
    do {
      final seg1 = String.fromCharCodes(
        Iterable.generate(
          4,
          (_) => chars.codeUnitAt(rand.nextInt(chars.length)),
        ),
      );
      final seg2 = String.fromCharCodes(
        Iterable.generate(
          4,
          (_) => chars.codeUnitAt(rand.nextInt(chars.length)),
        ),
      );
      generated = 'TRT-$seg1-$seg2';
    } while (state.treatments.any(
      (t) => t.globalSku == generated && t.id != currentId,
    ));
    globalSkuController.text = generated;
  }

  void updateTreatmentState({
    List<AreaViewModelEntry>? areas,
    bool? requirePostTreatmentPhotos,
    int? requiredPostTreatmentPhotoCount,
    String? status,
    String? gender,
    // Add other fields as needed
  }) {
    state = state.copyWith(
      areas: areas,
      requirePostTreatmentPhotos: requirePostTreatmentPhotos,
      requiredPostTreatmentPhotoCount: requiredPostTreatmentPhotoCount,
      status: status,
    );
  }

  void updateAreas(List<AreaViewModelEntry> areas) {
    state = state.copyWith(areas: areas);
  }
}

class SessionViewModelEntry {
  final int sessionNumber;
  final TextEditingController totalFollowUpsController;
  List<FollowUpEntry> followUps;

  SessionViewModelEntry({
    required this.sessionNumber,
    TextEditingController? totalFollowUpsController,
    this.followUps = const [],
  }) : totalFollowUpsController =
           totalFollowUpsController ?? TextEditingController();

  void dispose() {
    totalFollowUpsController.dispose();
    for (final fu in followUps) {
      fu.dispose();
    }
  }
}

class TreatmentState extends BaseStateModel {
  final List<TreatmentModel> treatments;
  final List<TreatmentModel> filteredTreatments;
  final TreatmentModel? selectedTreatment;
  final int? selectedTreatmentId;

  final int? draftTreatmentID;
  final CategoryDetailDto? selectedCategoryDetail;
  final int currentStep;
  final XFile? treatmentImage;
  final XFile? treatmentIcon;
  final List<AreaViewModelEntry> areas;
  final List<int> selectedCategoryPath;
  final List<String> selectedProtocolIds;
  final List<TreatmentProtocolNote> selectedProtocolNotes;
  final List<TreatmentProtocolNoteItem> standaloneNotes;
  final String status; // draft | active | deactive
  final String gender; // both | male | female

  final int? preNotificationOffset;
  final int? postNotificationOffset;

  final List<PlatformFile> preTreatmentAttachments;
  final List<PlatformFile> postTreatmentAttachments;

  final List<Attachment> existingPreAttachments;
  final List<Attachment> existingPostAttachments;

  final PlatformFile? preTreatmentConsentForm;
  final Attachment? existingConsentForm;
  final String consentType; // category | custom
  final String preNotificationSource; // category | custom
  final String postNotificationSource; // category | custom
  final String downtimeLevel; // None | Low | Moderate | High
  final String providerRolesSource; // category | custom
  final List<String> selectedRoles;
  final List<SessionViewModelEntry> sessions;
  final String sessionSource; // category | custom
  final int totalSessions;
  final List<ProductUsageEntry> productUsageEntries;
  final List<NotificationEntry> preNotificationEntries;
  final List<NotificationEntry> postNotificationEntries;

  // Post Treatment Photos
  final bool requirePostTreatmentPhotos;
  final int requiredPostTreatmentPhotoCount;

  // Follow-Up fields
  final bool isFollowUpRequired;

  // Logic fields
  final bool useInAiSimulator;
  final bool enableByDefault;

  // Scheduling fields
  final int prepTime;
  final int cleanupTime;
  final bool allowClinicOverride;
  final bool allowProviderOverride;
  final bool onlineBookable;
  final bool manualApprovalRequired;
  final int minimumBookingNotice;
  final int maximumDaysInAdvance;

  TreatmentState({
    super.loading,
    super.currentPage,
    super.totalPages,
    super.totalResults,
    this.treatments = const [],
    this.filteredTreatments = const [],
    this.selectedTreatment,
    this.selectedTreatmentId,
    this.selectedCategoryDetail,
    this.currentStep = 0,
    this.treatmentImage,
    this.treatmentIcon,
    this.selectedCategoryPath = const [],
    this.selectedProtocolIds = const [],
    this.selectedProtocolNotes = const [],
    this.standaloneNotes = const [],
    this.status = 'active',
    this.gender = 'both',
    this.draftTreatmentID,
    this.preNotificationOffset,
    this.postNotificationOffset,
    this.preTreatmentAttachments = const [],
    this.postTreatmentAttachments = const [],
    this.existingPreAttachments = const [],
    this.existingPostAttachments = const [],
    this.preTreatmentConsentForm,
    this.existingConsentForm,
    this.consentType = 'category',
    this.preNotificationSource = 'category',
    this.postNotificationSource = 'category',
    this.downtimeLevel = 'None',
    this.providerRolesSource = 'category',
    this.selectedRoles = const [],
    this.sessions = const [],
    this.sessionSource = 'category',
    this.totalSessions = 1,
    this.productUsageEntries = const [],
    this.preNotificationEntries = const [],
    this.postNotificationEntries = const [],
    this.requirePostTreatmentPhotos = false,
    this.requiredPostTreatmentPhotoCount = 0,
    this.isFollowUpRequired = false,
    this.useInAiSimulator = false,
    this.enableByDefault = false,
    this.prepTime = 0,
    this.cleanupTime = 0,
    this.allowClinicOverride = false,
    this.allowProviderOverride = false,
    this.onlineBookable = true,
    this.manualApprovalRequired = false,
    this.minimumBookingNotice = 24,
    this.maximumDaysInAdvance = 90,
    List<AreaViewModelEntry>? areas,
  }) : areas = areas ?? [AreaViewModelEntry()];

  TreatmentState copyWith({
    bool? loading,
    int? currentPage,
    int? totalPages,
    int? totalResults,
    List<TreatmentModel>? treatments,
    List<TreatmentModel>? filteredTreatments,
    TreatmentModel? selectedTreatment,
    int? selectedTreatmentId,
    int? currentStep,
    XFile? treatmentImage,
    XFile? treatmentIcon,
    int? draftTreatmentID,
    List<AreaViewModelEntry>? areas,
    List<int>? selectedCategoryPath,
    List<String>? selectedProtocolIds,
    List<TreatmentProtocolNote>? selectedProtocolNotes,
    List<TreatmentProtocolNoteItem>? standaloneNotes,
    String? status,
    String? gender,
    int? preNotificationOffset,
    int? postNotificationOffset,
    List<NotificationEntry>? preNotificationEntries,
    List<NotificationEntry>? postNotificationEntries,
    List<PlatformFile>? preTreatmentAttachments,
    List<PlatformFile>? postTreatmentAttachments,
    List<Attachment>? existingPreAttachments,
    List<Attachment>? existingPostAttachments,
    PlatformFile? preTreatmentConsentForm,
    Attachment? existingConsentForm,
    String? consentType,
    String? preNotificationSource,
    String? postNotificationSource,
    String? downtimeLevel,
    String? providerRolesSource,
    List<String>? selectedRoles,
    List<SessionViewModelEntry>? sessions,
    String? sessionSource,
    int? totalSessions,
    List<ProductUsageEntry>? productUsageEntries,
    bool? requirePostTreatmentPhotos,
    int? requiredPostTreatmentPhotoCount,
    bool? isFollowUpRequired,
    bool? useInAiSimulator,
    bool? enableByDefault,
    int? prepTime,
    int? cleanupTime,
    bool? allowClinicOverride,
    bool? allowProviderOverride,
    bool? onlineBookable,
    bool? manualApprovalRequired,
    int? minimumBookingNotice,
    int? maximumDaysInAdvance,
    CategoryDetailDto? selectedCategoryDetail,
  }) {
    return TreatmentState(
      selectedCategoryDetail:
          selectedCategoryDetail ?? this.selectedCategoryDetail,
      loading: loading ?? this.loading,
      draftTreatmentID: draftTreatmentID ?? this.draftTreatmentID,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalResults: totalResults ?? this.totalResults,
      treatments: treatments ?? this.treatments,
      filteredTreatments: filteredTreatments ?? this.filteredTreatments,
      selectedTreatment: selectedTreatment ?? this.selectedTreatment,
      selectedTreatmentId: selectedTreatmentId ?? this.selectedTreatmentId,
      currentStep: currentStep ?? this.currentStep,
      treatmentImage: treatmentImage ?? this.treatmentImage,
      treatmentIcon: treatmentIcon ?? this.treatmentIcon,
      areas: areas ?? this.areas,
      selectedCategoryPath: selectedCategoryPath ?? this.selectedCategoryPath,
      selectedProtocolIds: selectedProtocolIds ?? this.selectedProtocolIds,
      selectedProtocolNotes:
          selectedProtocolNotes ?? this.selectedProtocolNotes,
      standaloneNotes: standaloneNotes ?? this.standaloneNotes,
      status: status ?? this.status,
      gender: gender ?? this.gender,
      preNotificationOffset:
          preNotificationOffset ?? this.preNotificationOffset,
      postNotificationOffset:
          postNotificationOffset ?? this.postNotificationOffset,
      preNotificationEntries:
          preNotificationEntries ?? this.preNotificationEntries,
      postNotificationEntries:
          postNotificationEntries ?? this.postNotificationEntries,
      preTreatmentAttachments:
          preTreatmentAttachments ?? this.preTreatmentAttachments,
      postTreatmentAttachments:
          postTreatmentAttachments ?? this.postTreatmentAttachments,
      existingPreAttachments:
          existingPreAttachments ?? this.existingPreAttachments,
      existingPostAttachments:
          existingPostAttachments ?? this.existingPostAttachments,
      preTreatmentConsentForm:
          preTreatmentConsentForm ?? this.preTreatmentConsentForm,
      existingConsentForm: existingConsentForm ?? this.existingConsentForm,
      consentType: consentType ?? this.consentType,
      preNotificationSource:
          preNotificationSource ?? this.preNotificationSource,
      postNotificationSource:
          postNotificationSource ?? this.postNotificationSource,
      downtimeLevel: downtimeLevel ?? this.downtimeLevel,
      providerRolesSource: providerRolesSource ?? this.providerRolesSource,
      selectedRoles: selectedRoles ?? this.selectedRoles,
      sessions: sessions ?? this.sessions,
      sessionSource: sessionSource ?? this.sessionSource,
      totalSessions: totalSessions ?? this.totalSessions,
      productUsageEntries: productUsageEntries ?? this.productUsageEntries,
      requirePostTreatmentPhotos:
          requirePostTreatmentPhotos ?? this.requirePostTreatmentPhotos,
      requiredPostTreatmentPhotoCount:
          requiredPostTreatmentPhotoCount ??
          this.requiredPostTreatmentPhotoCount,
      isFollowUpRequired: isFollowUpRequired ?? this.isFollowUpRequired,
      useInAiSimulator: useInAiSimulator ?? this.useInAiSimulator,
      enableByDefault: enableByDefault ?? this.enableByDefault,
      prepTime: prepTime ?? this.prepTime,
      cleanupTime: cleanupTime ?? this.cleanupTime,
      allowClinicOverride: allowClinicOverride ?? this.allowClinicOverride,
      allowProviderOverride:
          allowProviderOverride ?? this.allowProviderOverride,
      onlineBookable: onlineBookable ?? this.onlineBookable,
      manualApprovalRequired:
          manualApprovalRequired ?? this.manualApprovalRequired,
      minimumBookingNotice: minimumBookingNotice ?? this.minimumBookingNotice,
      maximumDaysInAdvance: maximumDaysInAdvance ?? this.maximumDaysInAdvance,
    );
  }
}

class AreaViewModelEntry {
  final areaController = TextEditingController();
  final subAreaController = TextEditingController();
  List<SubAreaConfig> subAreas = [];

  void dispose() {
    areaController.dispose();
    subAreaController.dispose();
    for (final sub in subAreas) {
      sub.dispose();
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

class SubAreaConsumptionControllers {
  final minController = TextEditingController(text: '1');
  final maxController = TextEditingController(text: '1');

  SubAreaConsumptionControllers({String? min, String? max}) {
    if (min != null) minController.text = min;
    if (max != null) maxController.text = max;
  }

  void dispose() {
    minController.dispose();
    maxController.dispose();
  }
}

class ProductUsageEntry {
  final int productId;
  final String productName;
  final String unit;
  String usageType;
  String deductionTiming;
  bool allowSubstitution;
  final TextEditingController minQuantityController;
  final TextEditingController maxQuantityController;
  final TextEditingController notesController;
  final TextEditingController perUnitDurationController;
  final Map<String, SubAreaConsumptionControllers> subAreaControllers = {};

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
    List<SubAreaConsumption>? initialSubAreaConsumptions,
  }) : minQuantityController =
           minQuantityController ?? TextEditingController(text: '1'),
       maxQuantityController =
           maxQuantityController ?? TextEditingController(text: '1'),
       notesController = notesController ?? TextEditingController(),
       perUnitDurationController =
           perUnitDurationController ?? TextEditingController(text: '0.0') {
    if (initialSubAreaConsumptions != null) {
      for (final sac in initialSubAreaConsumptions) {
        subAreaControllers[sac.subAreaName] = SubAreaConsumptionControllers(
          min: sac.minQuantity.toString(),
          max: sac.maxQuantity.toString(),
        );
      }
    }
  }

  SubAreaConsumptionControllers getControllersForSubArea(String subAreaName) {
    return subAreaControllers.putIfAbsent(
      subAreaName,
      SubAreaConsumptionControllers.new,
    );
  }

  ProductUsageEntry copyWith({
    String? usageType,
    String? deductionTiming,
    bool? allowSubstitution,
  }) {
    final entry = ProductUsageEntry(
      productId: productId,
      productName: productName,
      unit: unit,
      usageType: usageType ?? this.usageType,
      deductionTiming: deductionTiming ?? this.deductionTiming,
      allowSubstitution: allowSubstitution ?? this.allowSubstitution,
      minQuantityController: minQuantityController,
      maxQuantityController: maxQuantityController,
      notesController: notesController,
      perUnitDurationController: perUnitDurationController,
    );
    subAreaControllers.forEach((key, val) {
      entry.subAreaControllers[key] = SubAreaConsumptionControllers(
        min: val.minController.text,
        max: val.maxController.text,
      );
    });
    return entry;
  }

  void dispose() {
    minQuantityController.dispose();
    maxQuantityController.dispose();
    notesController.dispose();
    perUnitDurationController.dispose();
    for (final controller in subAreaControllers.values) {
      controller.dispose();
    }
  }
}

class SubAreaChildConfig {
  final String name;
  final basePriceController = TextEditingController(text: '0');
  final Map<String, TextEditingController> unitPriceControllers = {};

  SubAreaChildConfig({
    required this.name,
    String? basePrice,
    Map<String, double>? unitPrices,
  }) {
    if (basePrice != null) basePriceController.text = basePrice;
    if (unitPrices != null) {
      unitPrices.forEach((unit, price) {
        unitPriceControllers[unit] = TextEditingController(
          text: price.toString(),
        );
      });
    }
  }

  TextEditingController getControllerForUnit(String unit) {
    return unitPriceControllers.putIfAbsent(
      unit,
      () => TextEditingController(text: '0'),
    );
  }

  void dispose() {
    basePriceController.dispose();
    for (final controller in unitPriceControllers.values) {
      controller.dispose();
    }
  }
}

class SubAreaConfig {
  final String name;
  final basePriceController = TextEditingController(text: '0');
  final Map<String, TextEditingController> unitPriceControllers = {};
  List<SubAreaChildConfig> children = [];

  SubAreaConfig({
    required this.name,
    String? basePrice,
    Map<String, double>? unitPrices,
    List<SubAreaChildConfig>? children,
  }) {
    if (basePrice != null) basePriceController.text = basePrice;
    if (unitPrices != null) {
      unitPrices.forEach((unit, price) {
        unitPriceControllers[unit] = TextEditingController(
          text: price.toString(),
        );
      });
    }
    if (children != null) {
      this.children = children;
    }
  }

  TextEditingController getControllerForUnit(String unit) {
    return unitPriceControllers.putIfAbsent(
      unit,
      () => TextEditingController(text: '0'),
    );
  }

  void dispose() {
    basePriceController.dispose();
    for (final controller in unitPriceControllers.values) {
      controller.dispose();
    }
    for (final child in children) {
      child.dispose();
    }
  }
}
