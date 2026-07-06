// ignore_for_file: avoid_positional_boolean_parameters
import 'dart:developer';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/notification_entry.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/product_usage_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/protocol_request.dart';
import 'package:skinsync_admin/models/responses/session_list_response.dart';
import 'package:skinsync_admin/models/treatment_data_models.dart';
import 'package:skinsync_admin/repositories/product_repository.dart';
import 'package:skinsync_admin/repositories/session_repository.dart';
import 'package:skinsync_admin/repositories/treatment_repository.dart';
import 'package:skinsync_admin/services/locator.dart';
import 'package:skinsync_admin/services/media_service.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/utils/exception.dart';
import 'base_state_model.dart';
import 'base_view_model.dart';

final sessionViewModelProvider =
    NotifierProvider<SessionViewModel, SessionState>(SessionViewModel._);

class SessionState extends BaseStateModel {
  final List<SessionViewModelEntry> sessions;
  final int? activeSessionIndex;

  SessionState({
    super.loading,
    super.currentPage,
    super.totalPages,
    super.totalResults,
    this.sessions = const [],
    this.activeSessionIndex,
  });

  SessionState copyWith({
    bool? loading,
    int? currentPage,
    int? totalPages,
    int? totalResults,
    List<SessionViewModelEntry>? sessions,
    int? activeSessionIndex,
    bool clearActiveSessionIndex = false,
  }) {
    return SessionState(
      loading: loading ?? this.loading,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalResults: totalResults ?? this.totalResults,
      sessions: sessions ?? this.sessions,
      activeSessionIndex: clearActiveSessionIndex ? null : (activeSessionIndex ?? this.activeSessionIndex),
    );
  }
}

class SessionViewModel extends BaseViewModel<SessionState> {
  SessionViewModel._() : super(SessionState());

  final SessionRepository _sessionRepository = locator<SessionRepository>();

  // Text Controllers for Session Creation Scratchpad
  final basePriceController = TextEditingController(text: '0');
  final Map<String, TextEditingController> unitPriceControllers = {};

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
          addCustomSession(title, sessionNumber);
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

  void removeCustomSession(int index) {
    if (index >= 0 && index < state.sessions.length) {
      final updated = List<SessionViewModelEntry>.from(state.sessions);
      final removed = updated.removeAt(index);
      removed.dispose();
      state = state.copyWith(sessions: updated);
    }
  }

  void setActiveSessionIndex(int? index) {
    state = state.copyWith(activeSessionIndex: index);
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
    if (state.activeSessionIndex != null) {
      final List<SessionViewModelEntry> updatedSessions = List.from(state.sessions);
      if (state.activeSessionIndex! < updatedSessions.length) {
        final activeEntry = updatedSessions[state.activeSessionIndex!];

        updatedSessions[state.activeSessionIndex!] = SessionViewModelEntry(
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
  }

  void resetSessions() {
    for (final session in state.sessions) {
      session.dispose();
    }
    state = state.copyWith(
      sessions: const [],
      clearActiveSessionIndex: true,
    );
  }

  // Products and Inventory Original Implementations mutating TreatmentState
  Future<void> fetchProductsByTreatmentCategory() async {
    final treatmentViewModel = ref.read(treatmentViewModelProvider.notifier);
    final treatmentState = ref.read(treatmentViewModelProvider);
    if (treatmentState.selectedCategoryPath.isEmpty) {
      treatmentViewModel.state = treatmentViewModel.state.copyWith(
        products: [],
        isLoadingProducts: false,
      );
      return;
    }

    treatmentViewModel.state = treatmentViewModel.state.copyWith(isLoadingProducts: true);

    try {
      final response = await locator<TreatmentRepository>().getProductsByTreatment(
        treatmentState.selectedCategoryPath,
      );
      if (response.isSuccess) {
        treatmentViewModel.state = treatmentViewModel.state.copyWith(
          products: response.data ?? [],
          isLoadingProducts: false,
        );
      } else {
        treatmentViewModel.state = treatmentViewModel.state.copyWith(
          isLoadingProducts: false,
        );
      }
    } catch (e) {
      treatmentViewModel.state = treatmentViewModel.state.copyWith(isLoadingProducts: false);
    }
  }

  Future<void> addProductUsage(
    int productId,
    String productName,
    String unit,
  ) async {
    final treatmentViewModel = ref.read(treatmentViewModelProvider.notifier);
    final treatmentState = ref.read(treatmentViewModelProvider);

    if (treatmentState.productUsageEntries.any((e) => e.productId == productId)) return;

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
    );

    treatmentViewModel.state = treatmentViewModel.state.copyWith(
      productUsageEntries: [...treatmentState.productUsageEntries, newEntry],
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
    final treatmentViewModel = ref.read(treatmentViewModelProvider.notifier);
    final treatmentState = ref.read(treatmentViewModelProvider);

    final updatedEntries = [...treatmentState.productUsageEntries];
    updatedEntries[index] = updatedEntries[index].copyWith(
      usageType: usageTypeVal ?? usageType,
      deductionTiming: deductionTiming,
      allowSubstitution: allowSubstitution,
    );
    treatmentViewModel.state = treatmentViewModel.state.copyWith(productUsageEntries: updatedEntries);
  }

  void updateProductPerUnitDuration(int index, String durationVal) {
    final treatmentViewModel = ref.read(treatmentViewModelProvider.notifier);
    final treatmentState = ref.read(treatmentViewModelProvider);
    treatmentViewModel.state = treatmentViewModel.state.copyWith(productUsageEntries: [...treatmentState.productUsageEntries]);
  }

  void removeProductUsage(int productId) {
    final treatmentViewModel = ref.read(treatmentViewModelProvider.notifier);
    final treatmentState = ref.read(treatmentViewModelProvider);

    final entry = treatmentState.productUsageEntries.firstWhere(
      (e) => e.productId == productId,
    );
    entry.dispose();
    treatmentViewModel.state = treatmentViewModel.state.copyWith(
      productUsageEntries: treatmentState.productUsageEntries
          .where((e) => e.productId != productId)
          .toList(),
    );
  }

  Future<bool?> callProductUsage() async {
    final treatmentState = ref.read(treatmentViewModelProvider);
    final request = ProductUsagesRequest(
      productUsages: treatmentState.productUsageEntries.map((e) {
        final subAreaConsumptions = e.subAreaControllers.entries
            .map(
              (entry) => SubAreaConsumptionModel(
                subAreaId: entry.value.subAreaId,
                subAreaName: entry.key,
                minQuantity: int.tryParse(entry.value.minController.text),
                maxQuantity: int.tryParse(entry.value.maxController.text),
              ),
            )
            .toList();

        return ProductUsage(
          productId: e.productId,
          deductionTiming: e.deductionTiming,
          allowSubstitution: e.allowSubstitution,
          notes: e.notesController.text,
          subAreaConsumptions: subAreaConsumptions.isEmpty
              ? null
              : subAreaConsumptions,
        );
      }).toList(),
    );

    return await runSafely<bool>(() async {
      await locator<TreatmentRepository>().productUsage(
        request: request,
        draftTreatmentID: treatmentState.selectedTreatment?.id ?? treatmentState.draftTreatmentID ?? 0,
      );
      return true;
    });
  }

  double getProductMinQuantity(ProductUsageEntry entry) {
    final treatmentState = ref.read(treatmentViewModelProvider);
    final allSubAreas = treatmentState.areas.expand((a) => a.subAreas).toList();
    if (allSubAreas.isNotEmpty) {
      double total = 0.0;
      for (final subArea in allSubAreas) {
        final controllers = entry.getControllersForSubArea(
          subArea.name,
          subAreaId: subArea.id,
        );
        final val = double.tryParse(controllers.minController.text) ?? 0.0;
        total += val;
      }
      return total;
    } else {
      return double.tryParse(entry.minQuantityController.text) ?? 0.0;
    }
  }

  double calculateProductUsageDuration() {
    final treatmentState = ref.read(treatmentViewModelProvider);
    double total = 0.0;
    for (final entry in treatmentState.productUsageEntries) {
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
    final treatmentState = ref.read(treatmentViewModelProvider);
    final treatmentId = treatmentState.selectedTreatment?.id ?? treatmentState.draftTreatmentID ?? 0;

    return await runSafely(
      onLoadingChange: (loading) => state = state.copyWith(loading: loading),
      () async {
        final uploadedFile = await mediaService.uploadFile(
          'treatment/pdf',
          PlatformFile(name: pdfName, size: bytes.length, bytes: bytes),
        );
        if (uploadedFile != null) {
          final response = await locator<TreatmentRepository>().protocol(
            request: ProtocolRequest(
              stepNumber: stepNumber,
              clinicalProtocolPdf: ClinicalProtocolPdf(
                name: pdfName,
                url: uploadedFile,
              ),
            ),
            draftTreatmentID: treatmentId,
          );

          return response.isSuccess;
        }
        throw const UnknownException('Failed to upload');
      },
    );
  }

  // Smart Delegated Methods for Session Creation/Editing Steps
  void toggleProtocolSelection(
    String protocolId, {
    String? protocolName,
    List<ProtocolItem>? masterProtocols,
  }) {
    final treatmentViewModel = ref.read(treatmentViewModelProvider.notifier);
    final treatmentState = ref.read(treatmentViewModelProvider);
    final List<String> currentSelected = List.from(treatmentState.selectedProtocolIds);
    final List<TreatmentProtocolNote> currentNotes = List.from(
      treatmentState.selectedProtocolNotes,
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
    treatmentViewModel.state = treatmentViewModel.state.copyWith(
      selectedProtocolIds: currentSelected,
      selectedProtocolNotes: currentNotes,
    );
  }

  void updateProtocolNotes(String protocolId, String notes) {
    final treatmentViewModel = ref.read(treatmentViewModelProvider.notifier);
    treatmentViewModel.state = treatmentViewModel.state.copyWith();
  }

  void updateStandaloneNotes(List<TreatmentProtocolNoteItem> notes) {
    final treatmentViewModel = ref.read(treatmentViewModelProvider.notifier);
    treatmentViewModel.state = treatmentViewModel.state.copyWith(standaloneNotes: notes);
  }

  void setPreNotificationSource(String source, {dynamic category}) {
    final treatmentViewModel = ref.read(treatmentViewModelProvider.notifier);
    treatmentViewModel.state = treatmentViewModel.state.copyWith(preNotificationSource: source);
  }

  void setPostNotificationSource(String source, {dynamic category}) {
    final treatmentViewModel = ref.read(treatmentViewModelProvider.notifier);
    treatmentViewModel.state = treatmentViewModel.state.copyWith(postNotificationSource: source);
  }

  void setDowntimeLevel(String level) {
    final treatmentViewModel = ref.read(treatmentViewModelProvider.notifier);
    treatmentViewModel.state = treatmentViewModel.state.copyWith(downtimeLevel: level);
  }

  void setProviderRolesSource(String source) {
    final treatmentViewModel = ref.read(treatmentViewModelProvider.notifier);
    treatmentViewModel.state = treatmentViewModel.state.copyWith(providerRolesSource: source);
  }

  void updateFixedDuration(String val) {
    final treatmentViewModel = ref.read(treatmentViewModelProvider.notifier);
    treatmentViewModel.state = treatmentViewModel.state.copyWith();
  }

  void addPreNotificationEntry() {
    final treatmentViewModel = ref.read(treatmentViewModelProvider.notifier);
    final treatmentState = ref.read(treatmentViewModelProvider);
    final newEntry = NotificationEntry(
      titleController: TextEditingController(),
      messageController: TextEditingController(),
      timingValueController: TextEditingController(),
      timingUnit: 'days',
      type: 'reminder',
    );
    treatmentViewModel.state = treatmentViewModel.state.copyWith(
      preNotificationEntries: [...treatmentState.preNotificationEntries, newEntry],
    );
  }

  void removePreNotificationEntry(int index) {
    final treatmentViewModel = ref.read(treatmentViewModelProvider.notifier);
    final treatmentState = ref.read(treatmentViewModelProvider);
    final updated = [...treatmentState.preNotificationEntries];
    updated[index].dispose();
    updated.removeAt(index);
    treatmentViewModel.state = treatmentViewModel.state.copyWith(preNotificationEntries: updated);
  }

  void addPostNotificationEntry() {
    final treatmentViewModel = ref.read(treatmentViewModelProvider.notifier);
    final treatmentState = ref.read(treatmentViewModelProvider);
    final newEntry = NotificationEntry(
      titleController: TextEditingController(),
      messageController: TextEditingController(),
      timingValueController: TextEditingController(),
      timingUnit: 'days',
      type: 'reminder',
    );
    treatmentViewModel.state = treatmentViewModel.state.copyWith(
      postNotificationEntries: [...treatmentState.postNotificationEntries, newEntry],
    );
  }

  void removePostNotificationEntry(int index) {
    final treatmentViewModel = ref.read(treatmentViewModelProvider.notifier);
    final treatmentState = ref.read(treatmentViewModelProvider);
    final updated = [...treatmentState.postNotificationEntries];
    updated[index].dispose();
    treatmentViewModel.state = treatmentViewModel.state.copyWith(
      postNotificationEntries: updated.where((e) => e != updated[index]).toList(),
    );
  }

  void updateRequiredPostTreatmentPhotoCount(String value) {
    final treatmentViewModel = ref.read(treatmentViewModelProvider.notifier);
    final count = int.tryParse(value) ?? 0;
    treatmentViewModel.state = treatmentViewModel.state.copyWith(requiredPostTreatmentPhotoCount: count);
  }

  void setConsentType(String type) {
    final treatmentViewModel = ref.read(treatmentViewModelProvider.notifier);
    treatmentViewModel.state = treatmentViewModel.state.copyWith(consentType: type);
  }

  void removeExistingAttachment(bool isPreTreatment, int index) {
    final treatmentViewModel = ref.read(treatmentViewModelProvider.notifier);
    final treatmentState = ref.read(treatmentViewModelProvider);
    if (isPreTreatment) {
      final updated = List<Attachment>.from(treatmentState.existingPreAttachments);
      updated.removeAt(index);
      treatmentViewModel.state = treatmentViewModel.state.copyWith(existingPreAttachments: updated);
    } else {
      final updated = List<Attachment>.from(treatmentState.existingPostAttachments);
      updated.removeAt(index);
      treatmentViewModel.state = treatmentViewModel.state.copyWith(existingPostAttachments: updated);
    }
  }

  void pickAttachments(bool isPreTreatment) {
    // Media attachments picking logic
  }

  TextEditingController getControllerForUnit(String unit) {
    return unitPriceControllers.putIfAbsent(
      unit,
      () => TextEditingController(text: '0'),
    );
  }

  void toggleRole(String role) {
    final treatmentViewModel = ref.read(treatmentViewModelProvider.notifier);
    final treatmentState = ref.read(treatmentViewModelProvider);
    final List<String> current = List.from(treatmentState.selectedRoles);
    if (current.contains(role)) {
      current.remove(role);
    } else {
      current.add(role);
    }
    treatmentViewModel.state = treatmentViewModel.state.copyWith(selectedRoles: current);
  }

  void setRoles(List<String> roles) {
    final treatmentViewModel = ref.read(treatmentViewModelProvider.notifier);
    treatmentViewModel.state = treatmentViewModel.state.copyWith(selectedRoles: roles);
  }

  void updateSessionFollowUpCount(int sessionIndex, String val) {
    final treatmentViewModel = ref.read(treatmentViewModelProvider.notifier);
    final treatmentState = ref.read(treatmentViewModelProvider);
    final count = int.tryParse(val) ?? 0;
    final session = treatmentState.sessions[sessionIndex];
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
    treatmentViewModel.state = treatmentViewModel.state.copyWith(sessions: List.from(treatmentState.sessions));
  }

  void updateSessionFollowUpEntry(
    int sessionIndex,
    int fuIndex, {
    String? type,
    String? durationUnit,
    String? intervalUnit,
    bool? isImageRequired,
  }) {
    final treatmentViewModel = ref.read(treatmentViewModelProvider.notifier);
    final treatmentState = ref.read(treatmentViewModelProvider);
    final session = treatmentState.sessions[sessionIndex];
    final fu = session.followUps[fuIndex];
    session.followUps[fuIndex] = fu.copyWith(
      type: type,
      durationUnit: durationUnit,
      intervalUnit: intervalUnit,
      isImageRequired: isImageRequired,
    );
    treatmentViewModel.state = treatmentViewModel.state.copyWith(sessions: List.from(treatmentState.sessions));
  }

  // Getters/methods delegate
  Future<void> pickConsentForm() {
    return ref.read(treatmentViewModelProvider.notifier).pickConsentForm();
  }

  void removeConsentForm() {
    ref.read(treatmentViewModelProvider.notifier).removeConsentForm();
  }

  void toggleRequirePostTreatmentPhotos(bool? value) {
    final treatmentViewModel = ref.read(treatmentViewModelProvider.notifier);
    treatmentViewModel.state = treatmentViewModel.state.copyWith(requirePostTreatmentPhotos: value ?? false);
  }

  void toggleAllowClinicOverride(bool? val) {
    final treatmentViewModel = ref.read(treatmentViewModelProvider.notifier);
    treatmentViewModel.state = treatmentViewModel.state.copyWith(allowClinicOverride: val ?? false);
  }

  void toggleAllowProviderOverride(bool? val) {
    final treatmentViewModel = ref.read(treatmentViewModelProvider.notifier);
    treatmentViewModel.state = treatmentViewModel.state.copyWith(allowProviderOverride: val ?? false);
  }

  void toggleOnlineBookable(bool? val) {
    final treatmentViewModel = ref.read(treatmentViewModelProvider.notifier);
    treatmentViewModel.state = treatmentViewModel.state.copyWith(onlineBookable: val ?? false);
  }

  void toggleManualApprovalRequired(bool? val) {
    final treatmentViewModel = ref.read(treatmentViewModelProvider.notifier);
    treatmentViewModel.state = treatmentViewModel.state.copyWith(manualApprovalRequired: val ?? false);
  }

  void toggleIsFixedDuration(bool? val) {
    final treatmentViewModel = ref.read(treatmentViewModelProvider.notifier);
    treatmentViewModel.state = treatmentViewModel.state.copyWith(isFixedDuration: val ?? false);
  }

  @override
  void dispose() {
    basePriceController.dispose();
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

class SubAreaConsumptionControllers {
  int? subAreaId;
  final minController = TextEditingController(text: '1');
  final maxController = TextEditingController(text: '1');

  SubAreaConsumptionControllers({this.subAreaId, String? min, String? max}) {
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

  final String? packageType;
  final int? boxQuantity;
  final double? clinicCost;
  final double? retailPricePerUnit;

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
    this.packageType,
    this.boxQuantity,
    this.clinicCost,
    this.retailPricePerUnit,
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
          subAreaId: sac.subAreaId,
          min: sac.minQuantity.toString(),
          max: sac.maxQuantity.toString(),
        );
      }
    }
  }

  SubAreaConsumptionControllers getControllersForSubArea(
    String subAreaName, {
    int? subAreaId,
  }) {
    final existing = subAreaControllers[subAreaName];
    if (existing != null) {
      if (subAreaId != null &&
          (existing.subAreaId == null || existing.subAreaId == 0)) {
        existing.subAreaId = subAreaId;
      }
      return existing;
    }

    final controllers = SubAreaConsumptionControllers(subAreaId: subAreaId);
    subAreaControllers[subAreaName] = controllers;
    return controllers;
  }

  ProductUsageEntry copyWith({
    String? usageType,
    String? deductionTiming,
    bool? allowSubstitution,
    String? unit,
  }) {
    final entry = ProductUsageEntry(
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
    );
    subAreaControllers.forEach((key, val) {
      entry.subAreaControllers[key] = SubAreaConsumptionControllers(
        subAreaId: val.subAreaId,
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