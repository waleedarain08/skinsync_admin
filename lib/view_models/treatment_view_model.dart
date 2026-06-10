import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../models/treatment_data_models.dart';
import '../models/treatment_model.dart';
import '../models/common_models.dart';
import '../models/notification_entry.dart';
import '../repositories/treatment_repository.dart';
import '../services/locator.dart';
import '../utils/dummy_data.dart';
import 'base_state_model.dart';
import 'base_view_model.dart';

final treatmentViewModelProvider = NotifierProvider<TreatmentViewModel, TreatmentState>(
  () => TreatmentViewModel._(),
);

class TreatmentViewModel extends BaseViewModel<TreatmentState> {
  TreatmentViewModel._() : super(TreatmentState());

  // ignore: unused_field
  final TreatmentRepository _treatmentRepository = locator<TreatmentRepository>();

  // Step 1 Controllers
  final internalNameController = TextEditingController();
  final displayNameController = TextEditingController();
  final fullDescriptionController = TextEditingController();
  final shortDescriptionController = TextEditingController();
  final basePriceController = TextEditingController();
  final Map<String, TextEditingController> unitPriceControllers = {};

  TextEditingController getControllerForUnit(String unit) {
    return unitPriceControllers.putIfAbsent(unit, () => TextEditingController(text: '0'));
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

    for (var area in state.areas) {
      area.dispose();
    }
    for (var entry in state.productUsageEntries) {
      entry.dispose();
    }
    for (var controller in unitPriceControllers.values) {
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
          // Using dummy data for now
          await Future.delayed(const Duration(milliseconds: 500));
          state = state.copyWith(
            treatments: TreatmentData.dummyTreatments, 
            filteredTreatments: TreatmentData.dummyTreatments,
            loading: false,
            totalPages: 5,
            totalResults: 50,
          );
          return true;
        }) ??
        false;
  }

  void resetForm() {
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
    protocolNameController.clear();
    categoryIdController.clear();
    categoryNameController.clear();
    categoryPathController.clear();
    unitPriceControllers.clear();
    
    for (var entry in state.sessions) {
      entry.dispose();
    }
    for (var entry in state.productUsageEntries) {
      entry.dispose();
    }

    for (var area in state.areas) {
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
      selectedTreatment: null,
      useInAiSimulator: false,
      enableByDefault: false,
      selectedProtocolIds: [],
      status: 'active',
      isFollowUpRequired: false,
    );
  }

  void toggleProtocolSelection(String protocolId) {
    final List<String> currentSelected = List.from(state.selectedProtocolIds);
    if (currentSelected.contains(protocolId)) {
      currentSelected.remove(protocolId);
    } else {
      currentSelected.add(protocolId);
    }
    state = state.copyWith(selectedProtocolIds: currentSelected);
  }

  void setStatus(String status) {
    state = state.copyWith(status: status);
  }

  void updateFollowUpCount(String val) {
    // Deprecated
  }

  void updateFollowUpEntry(int index, {String? type, String? durationUnit, String? intervalUnit}) {
    // Deprecated
  }

  void selectTreatment(TreatmentModel treatment) {
    state = state.copyWith(selectedTreatment: treatment);
    
    // Populate controllers for editing
    internalNameController.text = treatment.name ?? '';
    displayNameController.text = treatment.patientDisplayName ?? '';
    fullDescriptionController.text = treatment.description ?? '';
    shortDescriptionController.text = treatment.shortDescription ?? '';
    basePriceController.text = treatment.basePrice?.toString() ?? '';
    unitPriceControllers.clear();
    if (treatment.unitPrices != null) {
      treatment.unitPrices!.forEach((unit, price) {
        unitPriceControllers[unit] = TextEditingController(text: price.toString());
      });
    }
    durationHoursController.text = treatment.baseDurationHours?.toString() ?? '';
    durationMinutesController.text = treatment.baseDurationMinutes?.toString() ?? '';
    
    final totalDurationInMinutes = (treatment.baseDurationHours ?? 0) * 60 + (treatment.baseDurationMinutes ?? 0);
    treatmentDurationController.text = totalDurationInMinutes > 0 ? totalDurationInMinutes.toString() : '';
    prepTimeController.text = treatment.prepTime.toString();
    cleanupTimeController.text = treatment.cleanupTime.toString();
    minimumBookingNoticeController.text = treatment.minimumBookingNotice.toString();
    maximumDaysInAdvanceController.text = treatment.maximumDaysInAdvance.toString();
    preTreatmentInstructionsController.text = treatment.preTreatmentInstructions ?? '';
    postTreatmentInstructionsController.text = treatment.postTreatmentInstructions ?? '';
    
    preNotificationTitleController.text = treatment.preTreatmentNotificationTitle ?? '';
    preNotificationDescriptionController.text = treatment.preTreatmentNotificationDescription ?? '';
    postNotificationTitleController.text = treatment.postTreatmentNotificationTitle ?? '';
    postNotificationDescriptionController.text = treatment.postTreatmentNotificationDescription ?? '';

    // Dispose old notification entries
    for (var entry in state.preNotificationEntries) {
      entry.dispose();
    }
    for (var entry in state.postNotificationEntries) {
      entry.dispose();
    }

    final List<NotificationEntry> newPreNotifications = treatment.preNotifications.map((config) => NotificationEntry(
      titleController: TextEditingController(text: config.title),
      messageController: TextEditingController(text: config.message),
      timingValueController: TextEditingController(text: config.timing?.toString()),
      timingUnit: config.timingUnit ?? 'hours',
      type: config.type ?? 'reminder',
    )).toList();

    final List<NotificationEntry> newPostNotifications = treatment.postNotifications.map((config) => NotificationEntry(
      titleController: TextEditingController(text: config.title),
      messageController: TextEditingController(text: config.message),
      timingValueController: TextEditingController(text: config.timing?.toString()),
      timingUnit: config.timingUnit ?? 'hours',
      type: config.type ?? 'care',
    )).toList();

    // Sessions and Follow Ups
    for (var entry in state.sessions) {
      entry.dispose();
    }
    final List<SessionViewModelEntry> newSessions = [];
    if (treatment.sessions != null && treatment.sessions!.isNotEmpty) {
      for (var s in treatment.sessions!) {
        final sessionEntry = SessionViewModelEntry(
          sessionNumber: s.sessionNumber,
          totalFollowUpsController: TextEditingController(text: s.followUps.length.toString()),
          followUps: s.followUps.map((fu) => FollowUpEntry(
            type: fu.type,
            durationUnit: fu.durationUnit,
            durationValueController: TextEditingController(text: fu.durationValue?.toString() ?? ''),
            notesController: TextEditingController(text: fu.notes ?? ''),
            intervalValueController: TextEditingController(text: fu.intervalValue?.toString() ?? ''),
            intervalUnit: fu.intervalUnit ?? 'days',
            isImageRequired: fu.isImageRequired,
          )).toList(),
        );
        newSessions.add(sessionEntry);
      }
    } else {
      newSessions.add(SessionViewModelEntry(sessionNumber: 1));
    }

    // Product Usages
    for (var entry in state.productUsageEntries) {
      entry.dispose();
    }
    final List<ProductUsageEntry> newProductUsageEntries = [];
    if (treatment.productUsages != null) {
      for (var usage in treatment.productUsages!) {
        newProductUsageEntries.add(ProductUsageEntry(
          productId: usage.productId,
          productName: usage.productName,
          unit: usage.unit,
          usageType: usage.usageType,
          deductionTiming: usage.deductionTiming,
          allowSubstitution: usage.allowSubstitution,
          minQuantityController: TextEditingController(text: usage.minQuantity?.toString() ?? '0'),
          maxQuantityController: TextEditingController(text: usage.maxQuantity?.toString() ?? '0'),
          notesController: TextEditingController(text: usage.notes ?? ''),
          initialSubAreaConsumptions: usage.subAreaConsumptions,
        ));
      }
    }

    categoryIdController.text = treatment.categoryId ?? '';
    categoryNameController.text = treatment.categoryName ?? '';
    categoryPathController.text = treatment.categoryPath ?? '';
    
    // Clear and re-populate areas
    for (var area in state.areas) {
      area.dispose();
    }
    
    final List<AreaViewModelEntry> newAreas = [];
    if (treatment.sideAreas != null && treatment.sideAreas!.isNotEmpty) {
      for (var area in treatment.sideAreas!) {
        final entry = AreaViewModelEntry();
        entry.areaController.text = area.name ?? '';
        if (area.subAreas != null) {
          entry.subAreas = area.subAreas!.map((s) => SubAreaConfig(
            name: s.name ?? '',
            basePrice: s.basePrice?.toString(),
            unitPrices: s.unitPrices,
          )).toList();
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

  void setPreNotificationSource(String source, {CategoryItem? category}) {
    state = state.copyWith(preNotificationSource: source);
    if (source == 'category' && category != null) {
      state = state.copyWith(
        preNotificationEntries: (category.preNotifications).map((config) => NotificationEntry(
          titleController: TextEditingController(text: config.title),
          messageController: TextEditingController(text: config.message),
          timingValueController: TextEditingController(text: config.timing?.toString()),
          timingUnit: config.timingUnit ?? 'hours',
          type: config.type ?? 'reminder',
        )).toList(),
      );
    }
  }

  void setPostNotificationSource(String source, {CategoryItem? category}) {
    state = state.copyWith(postNotificationSource: source);
    if (source == 'category' && category != null) {
      state = state.copyWith(
        postNotificationEntries: (category.postNotifications).map((config) => NotificationEntry(
          titleController: TextEditingController(text: config.title),
          messageController: TextEditingController(text: config.message),
          timingValueController: TextEditingController(text: config.timing?.toString()),
          timingUnit: config.timingUnit ?? 'hours',
          type: config.type ?? 'care',
        )).toList(),
      );
    }
  }
  void setDowntimeLevel(String level) => state = state.copyWith(downtimeLevel: level);
  void setProviderRolesSource(String source) => state = state.copyWith(providerRolesSource: source);
  
  void setSessionSource(String source, {CategoryItem? category}) {
    state = state.copyWith(sessionSource: source);
    if (source == 'category' && category != null) {
      for (var entry in state.sessions) {
        entry.dispose();
      }
      final List<SessionViewModelEntry> newSessions = [];
      if (category.defaultSessions != null && category.defaultSessions!.isNotEmpty) {
        for (var s in category.defaultSessions!) {
          newSessions.add(SessionViewModelEntry(
            sessionNumber: s.sessionNumber,
            totalFollowUpsController: TextEditingController(text: s.followUps.length.toString()),
            followUps: s.followUps.map((fu) => FollowUpEntry(
              type: fu.type,
              durationUnit: fu.durationUnit,
              durationValueController: TextEditingController(text: fu.durationValue?.toString() ?? ''),
              notesController: TextEditingController(text: fu.notes ?? ''),
              intervalValueController: TextEditingController(text: fu.intervalValue?.toString() ?? ''),
              intervalUnit: fu.intervalUnit ?? 'days',
              isImageRequired: fu.isImageRequired,
            )).toList(),
          ));
        }
      } else {
        final int sessionCount = category.totalSessions;
        for (int i = 0; i < sessionCount; i++) {
          newSessions.add(SessionViewModelEntry(
            sessionNumber: i + 1,
            totalFollowUpsController: TextEditingController(text: (category.defaultFollowUps?.length ?? 0).toString()),
            followUps: (category.defaultFollowUps ?? []).map((fu) => FollowUpEntry(
              type: fu.type,
              durationUnit: fu.durationUnit,
              durationValueController: TextEditingController(text: fu.durationValue?.toString() ?? ''),
              notesController: TextEditingController(text: fu.notes ?? ''),
              intervalValueController: TextEditingController(text: fu.intervalValue?.toString() ?? ''),
              intervalUnit: fu.intervalUnit ?? 'days',
              isImageRequired: fu.isImageRequired,
            )).toList(),
          ));
        }
      }
      state = state.copyWith(
        totalSessions: newSessions.length,
        sessions: newSessions,
      );
    }
  }

  void toggleAllowClinicOverride(bool? val) => state = state.copyWith(allowClinicOverride: val ?? false);
  void toggleAllowProviderOverride(bool? val) => state = state.copyWith(allowProviderOverride: val ?? false);
  void toggleOnlineBookable(bool? val) => state = state.copyWith(onlineBookable: val ?? false);
  void toggleManualApprovalRequired(bool? val) => state = state.copyWith(manualApprovalRequired: val ?? false);

  void setTotalSessions(String val, {List<CategoryItem> categories = const []}) {
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

  void updateSessionFollowUpEntry(int sessionIndex, int fuIndex, {
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

  void setRoles(List<String> roles) => state = state.copyWith(selectedRoles: roles);

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

  void onCategorySelected(CategoryItem category, String path) {
    categoryIdController.text = category.id;
    categoryNameController.text = category.name;
    categoryPathController.text = path;
    
    if (state.sessionSource == 'category') {
      for (var entry in state.sessions) {
        entry.dispose();
      }
      final List<SessionViewModelEntry> newSessions = [];
      if (category.defaultSessions != null && category.defaultSessions!.isNotEmpty) {
        for (var s in category.defaultSessions!) {
          newSessions.add(SessionViewModelEntry(
            sessionNumber: s.sessionNumber,
            totalFollowUpsController: TextEditingController(text: s.followUps.length.toString()),
            followUps: s.followUps.map((fu) => FollowUpEntry(
              type: fu.type,
              durationUnit: fu.durationUnit,
              durationValueController: TextEditingController(text: fu.durationValue?.toString() ?? ''),
              notesController: TextEditingController(text: fu.notes ?? ''),
              intervalValueController: TextEditingController(text: fu.intervalValue?.toString() ?? ''),
              intervalUnit: fu.intervalUnit ?? 'days',
              isImageRequired: fu.isImageRequired,
            )).toList(),
          ));
        }
      } else {
        final int sessionCount = category.totalSessions;
        for (int i = 0; i < sessionCount; i++) {
          newSessions.add(SessionViewModelEntry(
            sessionNumber: i + 1,
            totalFollowUpsController: TextEditingController(text: (category.defaultFollowUps?.length ?? 0).toString()),
            followUps: (category.defaultFollowUps ?? []).map((fu) => FollowUpEntry(
              type: fu.type,
              durationUnit: fu.durationUnit,
              durationValueController: TextEditingController(text: fu.durationValue?.toString() ?? ''),
              notesController: TextEditingController(text: fu.notes ?? ''),
              intervalValueController: TextEditingController(text: fu.intervalValue?.toString() ?? ''),
              intervalUnit: fu.intervalUnit ?? 'days',
              isImageRequired: fu.isImageRequired,
            )).toList(),
          ));
        }
      }
      state = state.copyWith(
        totalSessions: newSessions.length,
        sessions: newSessions,
      );
    } else {
      state = state.copyWith();
    }

    // Sync Notifications
    if (state.preNotificationSource == 'category') {
      state = state.copyWith(
        preNotificationEntries: (category.preNotifications).map((config) => NotificationEntry(
          titleController: TextEditingController(text: config.title),
          messageController: TextEditingController(text: config.message),
          timingValueController: TextEditingController(text: config.timing?.toString()),
          timingUnit: config.timingUnit ?? 'hours',
          type: config.type ?? 'reminder',
        )).toList(),
      );
    }
    
    if (state.postNotificationSource == 'category') {
      state = state.copyWith(
        postNotificationEntries: (category.postNotifications).map((config) => NotificationEntry(
          titleController: TextEditingController(text: config.title),
          messageController: TextEditingController(text: config.message),
          timingValueController: TextEditingController(text: config.timing?.toString()),
          timingUnit: config.timingUnit ?? 'hours',
          type: config.type ?? 'care',
        )).toList(),
      );
    }
  }

  void selectCategoryAtLevel(int level, CategoryItem category, List<CategoryItem> allCategories) {
    List<String> currentPath = List.from(state.selectedCategoryPath);
    
    if (level < currentPath.length) {
      currentPath = currentPath.sublist(0, level);
    }
    
    currentPath.add(category.id);
    
    String fullPath = "";
    for (int i = 0; i < currentPath.length; i++) {
      final node = _findCategoryById(allCategories, currentPath[i]);
      if (node != null) {
        fullPath += (i == 0 ? "" : " > ") + node.name;
      }
    }

    categoryIdController.text = category.id;
    categoryNameController.text = category.name;
    categoryPathController.text = fullPath;

    state = state.copyWith(selectedCategoryPath: currentPath);
    onCategorySelected(category, fullPath);
  }

  CategoryItem? findCategoryById(List<CategoryItem> items, String id) {
    for (var item in items) {
      if (item.id == id) return item;
      if (item.children.isNotEmpty) {
        final found = findCategoryById(item.children, id);
        if (found != null) return found;
      }
    }
    return null;
  }

  CategoryItem? _findCategoryById(List<CategoryItem> items, String id) {
    for (var item in items) {
      if (item.id == id) return item;
      if (item.children.isNotEmpty) {
        final found = _findCategoryById(item.children, id);
        if (found != null) return found;
      }
    }
    return null;
  }

  void onAreaSelected(int index, String val) {
    state.areas[index].subAreaController.clear();
    final updatedAreas = [...state.areas];
    for (var sub in updatedAreas[index].subAreas) {
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
    if (val.isNotEmpty && !state.areas[areaIndex].subAreas.any((s) => s.name == val)) {
      final updatedAreas = [...state.areas];
      updatedAreas[areaIndex].subAreas = [...updatedAreas[areaIndex].subAreas, SubAreaConfig(name: val)];
      updatedAreas[areaIndex].subAreaController.clear();
      state = state.copyWith(areas: updatedAreas);
    }
  }

  void removeSubArea(int areaIndex, String subAreaName) {
    final updatedAreas = [...state.areas];
    final subAreaToRemove = updatedAreas[areaIndex].subAreas.firstWhere((s) => s.name == subAreaName);
    subAreaToRemove.dispose();
    updatedAreas[areaIndex].subAreas = 
        updatedAreas[areaIndex].subAreas.where((s) => s.name != subAreaName).toList();
    state = state.copyWith(areas: updatedAreas);
  }

  void addPreNotificationEntry() {
    state = state.copyWith(preNotificationEntries: [
      ...state.preNotificationEntries,
      NotificationEntry(
        titleController: TextEditingController(),
        messageController: TextEditingController(),
        timingValueController: TextEditingController(),
        timingUnit: 'hours',
        type: 'reminder',
      ),
    ]);
  }

  void removePreNotificationEntry(int index) {
    final list = List<NotificationEntry>.from(state.preNotificationEntries);
    final removed = list.removeAt(index);
    removed.dispose();
    state = state.copyWith(preNotificationEntries: list);
  }

  void addPostNotificationEntry() {
    state = state.copyWith(postNotificationEntries: [
      ...state.postNotificationEntries,
      NotificationEntry(
        titleController: TextEditingController(),
        messageController: TextEditingController(),
        timingValueController: TextEditingController(),
        timingUnit: 'hours',
        type: 'care',
      ),
    ]);
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
    
    state = state.copyWith(productUsageEntries: [...state.productUsageEntries, newEntry]);
  }

  void updateProductUsageEntry(int index, {String? usageType, String? deductionTiming, bool? allowSubstitution}) {
    final updatedEntries = [...state.productUsageEntries];
    updatedEntries[index] = updatedEntries[index].copyWith(
      usageType: usageType,
      deductionTiming: deductionTiming,
      allowSubstitution: allowSubstitution,
    );
    state = state.copyWith(productUsageEntries: updatedEntries);
  }

  void removeProductUsage(int productId) {
    final entry = state.productUsageEntries.firstWhere((e) => e.productId == productId);
    entry.dispose();
    state = state.copyWith(
      productUsageEntries: state.productUsageEntries.where((e) => e.productId != productId).toList(),
    );
  }

  void setPreNotificationOffset(int? offset) {
    state = state.copyWith(preNotificationOffset: offset);
  }

  void setPostNotificationOffset(int? offset) {
    state = state.copyWith(postNotificationOffset: offset);
  }

  Future<void> pickAttachments(bool isPreTreatment) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'webp', 'mp4', 'mov', 'avi'],
    );

    if (result != null) {
      if (isPreTreatment) {
        state = state.copyWith(preTreatmentAttachments: [...state.preTreatmentAttachments, ...result.files]);
      } else {
        state = state.copyWith(postTreatmentAttachments: [...state.postTreatmentAttachments, ...result.files]);
      }
    }
  }

  Future<void> pickConsentForm() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      state = state.copyWith(preTreatmentConsentForm: result.files.first);
    }
  }

  void removeConsentForm() {
    state = state.copyWith(preTreatmentConsentForm: null, existingConsentForm: null);
  }

  void setConsentType(String type) {
    state = state.copyWith(consentType: type);
  }

  void removeAttachment(bool isPreTreatment, int index) {
    if (isPreTreatment) {
      final updated = List<PlatformFile>.from(state.preTreatmentAttachments)..removeAt(index);
      state = state.copyWith(preTreatmentAttachments: updated);
    } else {
      final updated = List<PlatformFile>.from(state.postTreatmentAttachments)..removeAt(index);
      state = state.copyWith(postTreatmentAttachments: updated);
    }
  }

  void removeExistingAttachment(bool isPreTreatment, int index) {
    if (isPreTreatment) {
      final updated = List<Attachment>.from(state.existingPreAttachments)..removeAt(index);
      state = state.copyWith(existingPreAttachments: updated);
    } else {
      final updated = List<Attachment>.from(state.existingPostAttachments)..removeAt(index);
      state = state.copyWith(existingPostAttachments: updated);
    }
  }

  // Follow-Up Actions
  void toggleFollowUpRequired(bool? value) {
    state = state.copyWith(isFollowUpRequired: value ?? false);
    if (state.isFollowUpRequired && state.sessions.isNotEmpty && state.sessions[0].followUps.isEmpty) {
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
        final matchesQuery = query.isEmpty || 
            (t.name?.toLowerCase().contains(query) ?? false) ||
            (t.description?.toLowerCase().contains(query) ?? false);
            
        final matchesCategory = categoryPath.isEmpty || 
            (t.categoryPath?.toLowerCase().contains(categoryPath) ?? false);

        final matchesArea = area.isEmpty || 
            (t.sideAreas?.any((a) => a.name?.toLowerCase() == area) ?? false);

        final matchesStatus = status.isEmpty || 
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
    final updatedList = state.treatments.map((t) {
      if (t.id == treatmentId) {
        return t.copyWith(status: t.status == 'active' ? 'deactive' : 'active');
      }
      return t;
    }).toList();
    
    state = state.copyWith(
      treatments: updatedList,
      filteredTreatments: _getFilteredList(updatedList),
    );
  }

  void deleteTreatment(int treatmentId) {
    final updatedList = state.treatments.where((t) => t.id != treatmentId).toList();
    state = state.copyWith(
      treatments: updatedList,
      filteredTreatments: _getFilteredList(updatedList),
    );
  }

  List<TreatmentModel> _getFilteredList(List<TreatmentModel> source) {
    final query = searchController.text.toLowerCase();
    final categoryPath = filterCategoryController.text.toLowerCase();
    final area = filterAreaController.text.toLowerCase();
    final status = filterStatusController.text.toLowerCase();

    return source.where((t) {
      final matchesQuery = query.isEmpty ||
          (t.name?.toLowerCase().contains(query) ?? false) ||
          (t.description?.toLowerCase().contains(query) ?? false);

      final matchesCategory = categoryPath.isEmpty || (t.categoryPath?.toLowerCase().contains(categoryPath) ?? false);

      final matchesArea = area.isEmpty || (t.sideAreas?.any((a) => a.name?.toLowerCase() == area) ?? false);

      final matchesStatus = status.isEmpty ||
          (status == 'active' && t.status == 'active') ||
          (status == 'deactive' && t.status == 'deactive') ||
          (status == 'draft' && t.status == 'draft');

      return matchesQuery && matchesCategory && matchesArea && matchesStatus;
    }).toList();
  }

  Future<void> submitTreatment(BuildContext context, {List<CategoryItem> categories = const []}) async {
    return await runSafely<void>(showLoading: true, () async {
      List<SessionConfig> effectiveSessions = [];
      
      List<NotificationConfig> effectivePreNotifications = [];
      if (state.preNotificationSource == 'category') {
        final selectedCategory = findCategoryById(categories, categoryIdController.text);
        if (selectedCategory != null) {
          effectivePreNotifications = selectedCategory.preNotifications;
        }
      } else {
        effectivePreNotifications = state.preNotificationEntries.map((e) => e.toConfig()).toList();
      }

      List<NotificationConfig> effectivePostNotifications = [];
      if (state.postNotificationSource == 'category') {
        final selectedCategory = findCategoryById(categories, categoryIdController.text);
        if (selectedCategory != null) {
          effectivePostNotifications = selectedCategory.postNotifications;
        }
      } else {
        effectivePostNotifications = state.postNotificationEntries.map((e) => e.toConfig()).toList();
      }
      
      if (state.sessionSource == 'category') {
        final selectedCategory = findCategoryById(categories, categoryIdController.text);
        if (selectedCategory != null && selectedCategory.defaultSessions != null && selectedCategory.defaultSessions!.isNotEmpty) {
          effectiveSessions = selectedCategory.defaultSessions!.map((s) => SessionConfig(
            sessionNumber: s.sessionNumber,
            followUps: s.followUps.map((f) => FollowUpConfig(
              type: f.type,
              durationValue: f.durationValue,
              durationUnit: f.durationUnit,
              notes: f.notes,
              intervalValue: f.intervalValue,
              intervalUnit: f.intervalUnit,
              isImageRequired: f.isImageRequired,
            )).toList(),
          )).toList();
        } else {
          final int sessionCount = selectedCategory?.totalSessions ?? 1;
          for (int i = 0; i < sessionCount; i++) {
            effectiveSessions.add(SessionConfig(
              sessionNumber: i + 1,
              followUps: (selectedCategory?.defaultFollowUps ?? []).map((f) => FollowUpConfig(
                type: f.type,
                durationValue: f.durationValue,
                durationUnit: f.durationUnit,
                notes: f.notes,
                intervalValue: f.intervalValue,
                intervalUnit: f.intervalUnit,
                isImageRequired: f.isImageRequired,
              )).toList(),
            ));
          }
        }
      } else {
        effectiveSessions = state.sessions.map((s) => SessionConfig(
          sessionNumber: s.sessionNumber,
          followUps: s.followUps.map((fu) => FollowUpConfig(
            type: fu.type,
            durationValue: int.tryParse(fu.durationValueController.text),
            durationUnit: fu.durationUnit,
            notes: fu.notesController.text,
            intervalValue: int.tryParse(fu.intervalValueController.text),
            intervalUnit: fu.intervalUnit,
            isImageRequired: fu.isImageRequired,
          )).toList(),
        )).toList();
      }

      // ignore: unused_local_variable
      final treatment = TreatmentModel(
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
        baseDurationHours: (int.tryParse(treatmentDurationController.text) ?? 0) ~/ 60,
        baseDurationMinutes: (int.tryParse(treatmentDurationController.text) ?? 0) % 60,
        prepTime: int.tryParse(prepTimeController.text) ?? 0,
        cleanupTime: int.tryParse(cleanupTimeController.text) ?? 0,
        allowClinicOverride: state.allowClinicOverride,
        allowProviderOverride: state.allowProviderOverride,
        onlineBookable: state.onlineBookable,
        manualApprovalRequired: state.manualApprovalRequired,
        minimumBookingNotice: int.tryParse(minimumBookingNoticeController.text) ?? 24,
        maximumDaysInAdvance: int.tryParse(maximumDaysInAdvanceController.text) ?? 90,
        categoryId: categoryIdController.text,
        categoryName: categoryNameController.text,
        categoryPath: categoryPathController.text,
        status: state.status,
        useInAiSimulator: state.useInAiSimulator,
        protocolIds: state.selectedProtocolIds,
        preTreatmentInstructions: preTreatmentInstructionsController.text,
        postTreatmentInstructions: postTreatmentInstructionsController.text,
        preNotificationSource: state.preNotificationSource,
        postNotificationSource: state.postNotificationSource,
        preTreatmentNotificationTitle: preNotificationTitleController.text,
        preTreatmentNotificationDescription: preNotificationDescriptionController.text,
        preTreatmentNotificationOffset: state.preNotificationOffset,
        postTreatmentNotificationTitle: postNotificationTitleController.text,
        postTreatmentNotificationDescription: postNotificationDescriptionController.text,
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
          ...state.preTreatmentAttachments.map((f) => Attachment(url: f.path ?? '', type: _getFileType(f), name: f.name)),
        ],
        postTreatmentAttachments: [
          ...state.existingPostAttachments,
          ...state.postTreatmentAttachments.map((f) => Attachment(url: f.path ?? '', type: _getFileType(f), name: f.name)),
        ],
        preTreatmentConsentForm: state.consentType == 'custom' 
            ? (state.preTreatmentConsentForm != null 
                ? Attachment(url: state.preTreatmentConsentForm!.path ?? '', type: 'pdf', name: state.preTreatmentConsentForm!.name)
                : state.existingConsentForm)
            : null,
        isFollowUpRequired: state.isFollowUpRequired,
        productUsages: state.productUsageEntries.map((e) {
          final List<SubAreaConsumption> subAreaConsumptions = [];
          e.subAreaControllers.forEach((subName, controllers) {
            final minVal = double.tryParse(controllers.minController.text) ?? 0.0;
            final maxVal = double.tryParse(controllers.maxController.text) ?? 0.0;
            subAreaConsumptions.add(SubAreaConsumption(
              subAreaName: subName,
              minQuantity: minVal,
              maxQuantity: maxVal,
            ));
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
            subAreaConsumptions: subAreaConsumptions,
          );
        }).toList(),
        sideAreas: state.areas.map((a) => SideAreaModel(
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
            );
          }).toList(),
        )).toList(),
      );

      // Perform API call using treatment.toRequest()
      // await _treatmentRepository.createTreatment(treatment.toRequest());

      await Future.delayed(const Duration(seconds: 1));
      resetForm();
    });
  }

  String _getFileType(PlatformFile file) {
    final ext = file.extension?.toLowerCase();
    if (ext == 'pdf') return 'pdf';
    if (['jpg', 'jpeg', 'png', 'webp'].contains(ext)) return 'image';
    if (['mp4', 'mov', 'avi', 'mkv'].contains(ext)) return 'video';
    return 'other';
  }

  Future<void> updateTreatment(BuildContext context, {List<CategoryItem> categories = const []}) async {
    return await runSafely<void>(showLoading: true, () async {
      List<SessionConfig> effectiveSessions = [];

      List<NotificationConfig> effectivePreNotifications = [];
      if (state.preNotificationSource == 'category') {
        final selectedCategory = findCategoryById(categories, categoryIdController.text);
        if (selectedCategory != null) {
          effectivePreNotifications = selectedCategory.preNotifications;
        }
      } else {
        effectivePreNotifications = state.preNotificationEntries.map((e) => e.toConfig()).toList();
      }

      List<NotificationConfig> effectivePostNotifications = [];
      if (state.postNotificationSource == 'category') {
        final selectedCategory = findCategoryById(categories, categoryIdController.text);
        if (selectedCategory != null) {
          effectivePostNotifications = selectedCategory.postNotifications;
        }
      } else {
        effectivePostNotifications = state.postNotificationEntries.map((e) => e.toConfig()).toList();
      }
      
      if (state.sessionSource == 'category') {
        final selectedCategory = findCategoryById(categories, categoryIdController.text);
        if (selectedCategory != null && selectedCategory.defaultSessions != null && selectedCategory.defaultSessions!.isNotEmpty) {
          effectiveSessions = selectedCategory.defaultSessions!.map((s) => SessionConfig(
            sessionNumber: s.sessionNumber,
            followUps: s.followUps.map((f) => FollowUpConfig(
              type: f.type,
              durationValue: f.durationValue,
              durationUnit: f.durationUnit,
              notes: f.notes,
              intervalValue: f.intervalValue,
              intervalUnit: f.intervalUnit,
              isImageRequired: f.isImageRequired,
            )).toList(),
          )).toList();
        } else {
          final int sessionCount = selectedCategory?.totalSessions ?? 1;
          for (int i = 0; i < sessionCount; i++) {
            effectiveSessions.add(SessionConfig(
              sessionNumber: i + 1,
              followUps: (selectedCategory?.defaultFollowUps ?? []).map((f) => FollowUpConfig(
                type: f.type,
                durationValue: f.durationValue,
                durationUnit: f.durationUnit,
                notes: f.notes,
                intervalValue: f.intervalValue,
                intervalUnit: f.intervalUnit,
                isImageRequired: f.isImageRequired,
              )).toList(),
            ));
          }
        }
      } else {
        effectiveSessions = state.sessions.map((s) => SessionConfig(
          sessionNumber: s.sessionNumber,
          followUps: s.followUps.map((fu) => FollowUpConfig(
            type: fu.type,
            durationValue: int.tryParse(fu.durationValueController.text),
            durationUnit: fu.durationUnit,
            notes: fu.notesController.text,
            intervalValue: int.tryParse(fu.intervalValueController.text),
            intervalUnit: fu.intervalUnit,
            isImageRequired: fu.isImageRequired,
          )).toList(),
        )).toList();
      }

      // Logic for updating the treatment
      // await _treatmentRepository.updateTreatment(state.selectedTreatmentId!, treatment.toRequest());

      await Future.delayed(const Duration(seconds: 1));
      await getTreatments();
    });
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
  }) : totalFollowUpsController = totalFollowUpsController ?? TextEditingController();

  void dispose() {
    totalFollowUpsController.dispose();
    for (var fu in followUps) {
      fu.dispose();
    }
  }
}

class TreatmentState extends BaseStateModel {
  final List<TreatmentModel> treatments;
  final List<TreatmentModel> filteredTreatments;
  final TreatmentModel? selectedTreatment;
  final int? selectedTreatmentId;
  final int currentStep;
  final XFile? treatmentImage;
  final XFile? treatmentIcon;
  final List<AreaViewModelEntry> areas;
  final List<String> selectedCategoryPath;
  final List<String> selectedProtocolIds;
  final String status; // draft | active | deactive
  
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
    this.currentStep = 0,
    this.treatmentImage,
    this.treatmentIcon,
    this.selectedCategoryPath = const [],
    this.selectedProtocolIds = const [],
    this.status = 'active',
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
    List<AreaViewModelEntry>? areas,
    List<String>? selectedCategoryPath,
    List<String>? selectedProtocolIds,
    String? status,
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
  }) {
    return TreatmentState(
      loading: loading ?? this.loading,
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
      status: status ?? this.status,
      preNotificationOffset: preNotificationOffset ?? this.preNotificationOffset,
      postNotificationOffset: postNotificationOffset ?? this.postNotificationOffset,
      preNotificationEntries: preNotificationEntries ?? this.preNotificationEntries,
      postNotificationEntries: postNotificationEntries ?? this.postNotificationEntries,
      preTreatmentAttachments: preTreatmentAttachments ?? this.preTreatmentAttachments,
      postTreatmentAttachments: postTreatmentAttachments ?? this.postTreatmentAttachments,
      existingPreAttachments: existingPreAttachments ?? this.existingPreAttachments,
      existingPostAttachments: existingPostAttachments ?? this.existingPostAttachments,
      preTreatmentConsentForm: preTreatmentConsentForm ?? this.preTreatmentConsentForm,
      existingConsentForm: existingConsentForm ?? this.existingConsentForm,
      consentType: consentType ?? this.consentType,
      preNotificationSource: preNotificationSource ?? this.preNotificationSource,
      postNotificationSource: postNotificationSource ?? this.postNotificationSource,
      downtimeLevel: downtimeLevel ?? this.downtimeLevel,
      providerRolesSource: providerRolesSource ?? this.providerRolesSource,
      selectedRoles: selectedRoles ?? this.selectedRoles,
      sessions: sessions ?? this.sessions,
      sessionSource: sessionSource ?? this.sessionSource,
      totalSessions: totalSessions ?? this.totalSessions,
      productUsageEntries: productUsageEntries ?? this.productUsageEntries,
      isFollowUpRequired: isFollowUpRequired ?? this.isFollowUpRequired,
      useInAiSimulator: useInAiSimulator ?? this.useInAiSimulator,
      enableByDefault: enableByDefault ?? this.enableByDefault,
      prepTime: prepTime ?? this.prepTime,
      cleanupTime: cleanupTime ?? this.cleanupTime,
      allowClinicOverride: allowClinicOverride ?? this.allowClinicOverride,
      allowProviderOverride: allowProviderOverride ?? this.allowProviderOverride,
      onlineBookable: onlineBookable ?? this.onlineBookable,
      manualApprovalRequired: manualApprovalRequired ?? this.manualApprovalRequired,
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
    for (var sub in subAreas) {
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
  }) : durationValueController = durationValueController ?? TextEditingController(),
       notesController = notesController ?? TextEditingController(),
       intervalValueController = intervalValueController ?? TextEditingController();

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
  final minController = TextEditingController(text: '0');
  final maxController = TextEditingController(text: '0');

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
    List<SubAreaConsumption>? initialSubAreaConsumptions,
  }) : minQuantityController = minQuantityController ?? TextEditingController(text: '0'),
       maxQuantityController = maxQuantityController ?? TextEditingController(text: '0'),
       notesController = notesController ?? TextEditingController() {
    if (initialSubAreaConsumptions != null) {
      for (var sac in initialSubAreaConsumptions) {
        subAreaControllers[sac.subAreaName] = SubAreaConsumptionControllers(
          min: sac.minQuantity.toString(),
          max: sac.maxQuantity.toString(),
        );
      }
    }
  }

  SubAreaConsumptionControllers getControllersForSubArea(String subAreaName) {
    return subAreaControllers.putIfAbsent(subAreaName, () => SubAreaConsumptionControllers());
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
    for (var controller in subAreaControllers.values) {
      controller.dispose();
    }
  }
}

class SubAreaConfig {
  final String name;
  final basePriceController = TextEditingController(text: '0');
  final Map<String, TextEditingController> unitPriceControllers = {};

  SubAreaConfig({required this.name, String? basePrice, Map<String, double>? unitPrices}) {
    if (basePrice != null) basePriceController.text = basePrice;
    if (unitPrices != null) {
      unitPrices.forEach((unit, price) {
        unitPriceControllers[unit] = TextEditingController(text: price.toString());
      });
    }
  }

  TextEditingController getControllerForUnit(String unit) {
    return unitPriceControllers.putIfAbsent(unit, () => TextEditingController(text: '0'));
  }

  void dispose() {
    basePriceController.dispose();
    for (var controller in unitPriceControllers.values) {
      controller.dispose();
    }
  }
}
