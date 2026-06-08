import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../models/treatment_data_models.dart';
import '../models/treatment_model.dart';
import '../models/common_models.dart';
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
  final durationHoursController = TextEditingController();
  final durationMinutesController = TextEditingController();

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
    preTreatmentInstructionsController.dispose();
    postTreatmentInstructionsController.dispose();
    preNotificationTitleController.dispose();
    preNotificationDescriptionController.dispose();
    postNotificationTitleController.dispose();
    postNotificationDescriptionController.dispose();
    totalFollowUpsController.dispose();
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
    preTreatmentInstructionsController.clear();
    postTreatmentInstructionsController.clear();
    preNotificationTitleController.clear();
    preNotificationDescriptionController.clear();
    postNotificationTitleController.clear();
    postNotificationDescriptionController.clear();
    totalFollowUpsController.clear();
    followUpDurationValueController.clear();
    followUpNotesController.clear();
    protocolNameController.clear();
    categoryIdController.clear();
    categoryNameController.clear();
    categoryPathController.clear();
    
    for (var entry in state.followUpEntries) {
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
      downtimeLevel: 'None',
      providerRolesSource: 'category',
      selectedRoles: [],
      areas: [AreaViewModelEntry()],
      followUpEntries: [],
      followUpSource: 'category',
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
    final count = int.tryParse(val) ?? 0;
    final currentEntries = [...state.followUpEntries];
    
    if (count > currentEntries.length) {
      // Add new entries
      for (int i = currentEntries.length; i < count; i++) {
        currentEntries.add(FollowUpEntry());
      }
    } else if (count < currentEntries.length) {
      // Remove extra entries
      for (int i = currentEntries.length - 1; i >= count; i--) {
        currentEntries[i].dispose();
        currentEntries.removeAt(i);
      }
    }
    state = state.copyWith(followUpEntries: currentEntries);
  }

  void updateFollowUpEntry(int index, {String? type, String? durationUnit, String? intervalUnit}) {
    final updatedEntries = [...state.followUpEntries];
    updatedEntries[index] = updatedEntries[index].copyWith(
      type: type,
      durationUnit: durationUnit,
      intervalUnit: intervalUnit,
    );
    state = state.copyWith(followUpEntries: updatedEntries);
  }

  void selectTreatment(TreatmentModel treatment) {
    state = state.copyWith(selectedTreatment: treatment);
    
    // Populate controllers for editing
    internalNameController.text = treatment.name ?? '';
    displayNameController.text = treatment.patientDisplayName ?? '';
    fullDescriptionController.text = treatment.description ?? '';
    shortDescriptionController.text = treatment.shortDescription ?? '';
    basePriceController.text = treatment.basePrice?.toString() ?? '';
    durationHoursController.text = treatment.baseDurationHours?.toString() ?? '';
    durationMinutesController.text = treatment.baseDurationMinutes?.toString() ?? '';
    preTreatmentInstructionsController.text = treatment.preTreatmentInstructions ?? '';
    postTreatmentInstructionsController.text = treatment.postTreatmentInstructions ?? '';
    
    preNotificationTitleController.text = treatment.preTreatmentNotificationTitle ?? '';
    preNotificationDescriptionController.text = treatment.preTreatmentNotificationDescription ?? '';
    postNotificationTitleController.text = treatment.postTreatmentNotificationTitle ?? '';
    postNotificationDescriptionController.text = treatment.postTreatmentNotificationDescription ?? '';

    // Follow Up Entries
    for (var entry in state.followUpEntries) {
      entry.dispose();
    }
    final List<FollowUpEntry> newFollowUpEntries = [];
    if (treatment.followUps != null) {
      for (var config in treatment.followUps!) {
        newFollowUpEntries.add(FollowUpEntry(
          type: config.type,
          durationUnit: config.durationUnit,
          durationValueController: TextEditingController(text: config.durationValue?.toString() ?? ''),
          notesController: TextEditingController(text: config.notes ?? ''),
          intervalValueController: TextEditingController(text: config.intervalValue?.toString() ?? ''),
          intervalUnit: config.intervalUnit ?? 'days',
        ));
      }
    }
    totalFollowUpsController.text = newFollowUpEntries.length.toString();

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
      downtimeLevel: treatment.downtimeLevel,
      providerRolesSource: treatment.providerRolesSource,
      selectedRoles: treatment.allowedRoles,
      followUpEntries: newFollowUpEntries,
      followUpSource: 'custom', 
      productUsageEntries: newProductUsageEntries,
      isFollowUpRequired: treatment.isFollowUpRequired,
      useInAiSimulator: treatment.useInAiSimulator,
      enableByDefault: treatment.enableByDefault,
      preNotificationOffset: treatment.preTreatmentNotificationOffset,
      postNotificationOffset: treatment.postTreatmentNotificationOffset,
    );
  }

  void setPreNotificationSource(String source) => state = state.copyWith(preNotificationSource: source);
  void setPostNotificationSource(String source) => state = state.copyWith(postNotificationSource: source);
  void setDowntimeLevel(String level) => state = state.copyWith(downtimeLevel: level);
  void setProviderRolesSource(String source) => state = state.copyWith(providerRolesSource: source);

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
    
    state = state.copyWith(); 
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

  void setFollowUpSource(String source) {
    state = state.copyWith(followUpSource: source);
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
    if (state.isFollowUpRequired && state.followUpEntries.isEmpty) {
      updateFollowUpCount('1');
      totalFollowUpsController.text = '1';
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
      List<FollowUpConfig> effectiveFollowUps = [];
      
      if (state.isFollowUpRequired) {
        if (state.followUpSource == 'custom') {
          effectiveFollowUps = state.followUpEntries.map((e) => FollowUpConfig(
            type: e.type,
            durationValue: int.tryParse(e.durationValueController.text),
            durationUnit: e.durationUnit,
            notes: e.notesController.text,
            intervalValue: int.tryParse(e.intervalValueController.text),
            intervalUnit: e.intervalUnit,
          )).toList();
        } else {
          // Resolve from category
          final selectedCategory = findCategoryById(categories, categoryIdController.text);
          effectiveFollowUps = selectedCategory?.defaultFollowUps ?? [];
        }
      }

      // ignore: unused_local_variable
      final treatment = TreatmentModel(
        name: internalNameController.text,
        patientDisplayName: displayNameController.text,
        description: fullDescriptionController.text,
        shortDescription: shortDescriptionController.text,
        basePrice: double.tryParse(basePriceController.text),
        baseDurationHours: int.tryParse(durationHoursController.text),
        baseDurationMinutes: int.tryParse(durationMinutesController.text),
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
        followUps: effectiveFollowUps,
        productUsages: state.productUsageEntries.map((e) => ProductUsageModel(
          productId: e.productId,
          productName: e.productName,
          usageType: e.usageType,
          minQuantity: double.tryParse(e.minQuantityController.text),
          maxQuantity: double.tryParse(e.maxQuantityController.text),
          deductionTiming: e.deductionTiming,
          allowSubstitution: e.allowSubstitution,
          notes: e.notesController.text,
          unit: e.unit,
        )).toList(),
        sideAreas: state.areas.map((a) => SideAreaModel(
          name: a.areaController.text,
          subAreas: a.subAreas.map((s) => SubAreaModel(
            name: s.name,
            basePrice: double.tryParse(s.basePriceController.text),
          )).toList(),
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
      // Logic for updating the treatment
      // (Similar to submitTreatment resolving effective followUps)
      await Future.delayed(const Duration(seconds: 1));
      await getTreatments();
    });
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
  final List<FollowUpEntry> followUpEntries;
  final String followUpSource; // category | custom
  final List<ProductUsageEntry> productUsageEntries;

  // Follow-Up fields
  final bool isFollowUpRequired;

  // Logic fields
  final bool useInAiSimulator;
  final bool enableByDefault;

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
    this.followUpEntries = const [],
    this.followUpSource = 'category',
    this.productUsageEntries = const [],
    this.isFollowUpRequired = false,
    this.useInAiSimulator = false,
    this.enableByDefault = false,
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
    List<FollowUpEntry>? followUpEntries,
    String? followUpSource,
    List<ProductUsageEntry>? productUsageEntries,
    bool? isFollowUpRequired,
    bool? useInAiSimulator,
    bool? enableByDefault,
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
      followUpEntries: followUpEntries ?? this.followUpEntries,
      followUpSource: followUpSource ?? this.followUpSource,
      productUsageEntries: productUsageEntries ?? this.productUsageEntries,
      isFollowUpRequired: isFollowUpRequired ?? this.isFollowUpRequired,
      useInAiSimulator: useInAiSimulator ?? this.useInAiSimulator,
      enableByDefault: enableByDefault ?? this.enableByDefault,
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

  FollowUpEntry({
    this.type = 'virtual',
    this.durationUnit = 'minutes',
    TextEditingController? durationValueController,
    TextEditingController? notesController,
    TextEditingController? intervalValueController,
    this.intervalUnit = 'days',
  }) : durationValueController = durationValueController ?? TextEditingController(),
       notesController = notesController ?? TextEditingController(),
       intervalValueController = intervalValueController ?? TextEditingController();

  FollowUpEntry copyWith({
    String? type,
    String? durationUnit,
    String? intervalUnit,
  }) {
    return FollowUpEntry(
      type: type ?? this.type,
      durationUnit: durationUnit ?? this.durationUnit,
      durationValueController: durationValueController,
      notesController: notesController,
      intervalValueController: intervalValueController,
      intervalUnit: intervalUnit ?? this.intervalUnit,
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
  String deductionTiming;
  bool allowSubstitution;
  final TextEditingController minQuantityController;
  final TextEditingController maxQuantityController;
  final TextEditingController notesController;

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
  }) : minQuantityController = minQuantityController ?? TextEditingController(text: '0'),
       maxQuantityController = maxQuantityController ?? TextEditingController(text: '0'),
       notesController = notesController ?? TextEditingController();

  ProductUsageEntry copyWith({
    String? usageType,
    String? deductionTiming,
    bool? allowSubstitution,
  }) {
    return ProductUsageEntry(
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
  }

  void dispose() {
    minQuantityController.dispose();
    maxQuantityController.dispose();
    notesController.dispose();
  }
}

class SubAreaConfig {
  final String name;
  final basePriceController = TextEditingController(text: '0');

  SubAreaConfig({required this.name, String? basePrice}) {
    if (basePrice != null) basePriceController.text = basePrice;
  }

  void dispose() {
    basePriceController.dispose();
  }
}
