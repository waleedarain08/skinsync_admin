import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../models/treatment_data_models.dart';
import '../models/treatment_model.dart';
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

  // Step 4 Controllers
  final materialNameController = TextEditingController();
  final maxMaterialQuantityController = TextEditingController(text: '0');

  // Filter Controllers
  final searchController = TextEditingController();
  final filterCategoryController = TextEditingController();
  final filterSubcategoryController = TextEditingController();
  final filterAreaController = TextEditingController();
  final filterSubAreaController = TextEditingController();
  final filterMaterialController = TextEditingController();
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
    materialNameController.dispose();
    maxMaterialQuantityController.dispose();
    
    searchController.dispose();
    filterCategoryController.dispose();
    filterSubcategoryController.dispose();
    filterAreaController.dispose();
    filterSubAreaController.dispose();
    filterMaterialController.dispose();
    filterStatusController.dispose();

    for (var area in state.areas) {
      area.dispose();
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
    materialNameController.clear();
    maxMaterialQuantityController.text = '0';
    
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
      areas: [AreaViewModelEntry()],
      selectedTreatment: null,
      useInAiSimulator: false,
      selectedProtocolIds: [],
      isFollowUpRequired: false,
      followUpType: null,
      followUpDurationUnit: 'minutes',
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

    totalFollowUpsController.text = treatment.totalFollowUps?.toString() ?? '';
    followUpDurationValueController.text = treatment.followUpDurationValue?.toString() ?? '';
    followUpNotesController.text = treatment.followUpNotes ?? '';

    categoryIdController.text = treatment.categoryId ?? '';
    categoryNameController.text = treatment.categoryName ?? '';
    categoryPathController.text = treatment.categoryPath ?? '';
    materialNameController.text = treatment.materialName ?? '';
    maxMaterialQuantityController.text = treatment.maxMaterialQuantity.toString();
    
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
            maxQty: s.maxMaterialQuantity?.toString(),
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
      treatmentImage: null, 
      treatmentIcon: null,
      useInAiSimulator: treatment.useInAiSimulator,
      selectedProtocolIds: treatment.protocolIds ?? [],
      preTreatmentAttachments: [], 
      postTreatmentAttachments: [],
      existingPreAttachments: treatment.preTreatmentAttachments ?? [],
      existingPostAttachments: treatment.postTreatmentAttachments ?? [],
      isFollowUpRequired: treatment.isFollowUpRequired,
      followUpType: treatment.followUpType,
      followUpDurationUnit: treatment.followUpDurationUnit ?? 'minutes',
      preNotificationOffset: treatment.preTreatmentNotificationOffset,
      postNotificationOffset: treatment.postTreatmentNotificationOffset,
    );
  }

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
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'mp4', 'mov', 'avi'],
    );

    if (result != null) {
      if (isPreTreatment) {
        state = state.copyWith(preTreatmentAttachments: [...state.preTreatmentAttachments, ...result.files]);
      } else {
        state = state.copyWith(postTreatmentAttachments: [...state.postTreatmentAttachments, ...result.files]);
      }
    }
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
  }

  void setFollowUpType(String? type) {
    state = state.copyWith(followUpType: type);
  }

  void setFollowUpDurationUnit(String? unit) {
    state = state.copyWith(followUpDurationUnit: unit);
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
            (status == 'active' && t.isActive) ||
            (status == 'inactive' && !t.isActive);

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
    filterMaterialController.clear();
    filterStatusController.clear();
    _applyFilters();
  }

  void toggleTreatmentStatus(int treatmentId) {
    final updatedList = state.treatments.map((t) {
      if (t.id == treatmentId) {
        return t.copyWith(isActive: !t.isActive);
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
          (status == 'active' && t.isActive) ||
          (status == 'inactive' && !t.isActive);

      return matchesQuery && matchesCategory && matchesArea && matchesStatus;
    }).toList();
  }

  Future<void> submitTreatment(BuildContext context) async {
    return await runSafely<void>(showLoading: true, () async {
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
        materialName: materialNameController.text,
        maxMaterialQuantity: int.tryParse(maxMaterialQuantityController.text) ?? 0,
        useInAiSimulator: state.useInAiSimulator,
        protocolIds: state.selectedProtocolIds,
        preTreatmentInstructions: preTreatmentInstructionsController.text,
        postTreatmentInstructions: postTreatmentInstructionsController.text,
        preTreatmentNotificationTitle: preNotificationTitleController.text,
        preTreatmentNotificationDescription: preNotificationDescriptionController.text,
        preTreatmentNotificationOffset: state.preNotificationOffset,
        postTreatmentNotificationTitle: postNotificationTitleController.text,
        postTreatmentNotificationDescription: postNotificationDescriptionController.text,
        postTreatmentNotificationOffset: state.postNotificationOffset,
        preTreatmentAttachments: [
          ...state.existingPreAttachments,
          ...state.preTreatmentAttachments.map((f) => Attachment(url: f.path ?? '', type: _getFileType(f), name: f.name)),
        ],
        postTreatmentAttachments: [
          ...state.existingPostAttachments,
          ...state.postTreatmentAttachments.map((f) => Attachment(url: f.path ?? '', type: _getFileType(f), name: f.name)),
        ],
        isFollowUpRequired: state.isFollowUpRequired,
        totalFollowUps: int.tryParse(totalFollowUpsController.text),
        followUpType: state.followUpType,
        followUpDurationValue: int.tryParse(followUpDurationValueController.text),
        followUpDurationUnit: state.followUpDurationUnit,
        followUpNotes: followUpNotesController.text,
        sideAreas: state.areas.map((a) => SideAreaModel(
          name: a.areaController.text,
          subAreas: a.subAreas.map((s) => SubAreaModel(
            name: s.name,
            maxMaterialQuantity: int.tryParse(s.maxQuantityController.text),
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

  Future<void> updateTreatment(BuildContext context) async {
    return await runSafely<void>(showLoading: true, () async {
      // Logic for updating the treatment
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
  
  final int? preNotificationOffset;
  final int? postNotificationOffset;

  final List<PlatformFile> preTreatmentAttachments;
  final List<PlatformFile> postTreatmentAttachments;

  final List<Attachment> existingPreAttachments;
  final List<Attachment> existingPostAttachments;

  // Follow-Up fields
  final bool isFollowUpRequired;
  final String? followUpType;
  final String? followUpDurationUnit;

  // Step 4 fields
  final bool useInAiSimulator;

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
    this.preNotificationOffset,
    this.postNotificationOffset,
    this.preTreatmentAttachments = const [],
    this.postTreatmentAttachments = const [],
    this.existingPreAttachments = const [],
    this.existingPostAttachments = const [],
    this.isFollowUpRequired = false,
    this.followUpType,
    this.followUpDurationUnit = 'minutes',
    this.useInAiSimulator = false,
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
    int? preNotificationOffset,
    int? postNotificationOffset,
    List<PlatformFile>? preTreatmentAttachments,
    List<PlatformFile>? postTreatmentAttachments,
    List<Attachment>? existingPreAttachments,
    List<Attachment>? existingPostAttachments,
    bool? isFollowUpRequired,
    String? followUpType,
    String? followUpDurationUnit,
    bool? useInAiSimulator,
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
      preNotificationOffset: preNotificationOffset ?? this.preNotificationOffset,
      postNotificationOffset: postNotificationOffset ?? this.postNotificationOffset,
      preTreatmentAttachments: preTreatmentAttachments ?? this.preTreatmentAttachments,
      postTreatmentAttachments: postTreatmentAttachments ?? this.postTreatmentAttachments,
      existingPreAttachments: existingPreAttachments ?? this.existingPreAttachments,
      existingPostAttachments: existingPostAttachments ?? this.existingPostAttachments,
      isFollowUpRequired: isFollowUpRequired ?? this.isFollowUpRequired,
      followUpType: followUpType ?? this.followUpType,
      followUpDurationUnit: followUpDurationUnit ?? this.followUpDurationUnit,
      useInAiSimulator: useInAiSimulator ?? this.useInAiSimulator,
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

class SubAreaConfig {
  final String name;
  final maxQuantityController = TextEditingController(text: '0');
  final basePriceController = TextEditingController(text: '0');

  SubAreaConfig({required this.name, String? maxQty, String? basePrice}) {
    if (maxQty != null) maxQuantityController.text = maxQty;
    if (basePrice != null) basePriceController.text = basePrice;
  }

  void dispose() {
    maxQuantityController.dispose();
    basePriceController.dispose();
  }
}
