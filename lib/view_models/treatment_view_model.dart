import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../models/treatment_model.dart';
import '../repositories/treatment_repository.dart';
import '../services/locator.dart';
import '../utils/dummy_data.dart';
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

  // Step 2 Controllers
  final categoryController = TextEditingController();
  final subcategoryController = TextEditingController();

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
    categoryController.dispose();
    subcategoryController.dispose();
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

  Future<bool> getTreatments() async {
    return await runSafely<bool?>(showLoading: false, () async {
          state = state.copyWith(loading: true);
          // Using dummy data for now
          await Future.delayed(const Duration(milliseconds: 500));
          state = state.copyWith(
            treatments: TreatmentData.dummyTreatments, 
            filteredTreatments: TreatmentData.dummyTreatments,
            loading: false,
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
    categoryController.clear();
    subcategoryController.clear();
    materialNameController.clear();
    maxMaterialQuantityController.text = '0';
    
    for (var area in state.areas) {
      area.dispose();
    }

    state = state.copyWith(
      currentStep: 0,
      treatmentImage: null,
      treatmentIcon: null,
      areas: [AreaViewModelEntry()],
      selectedTreatment: null,
      useInAiSimulator: false,
    );
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
    categoryController.text = treatment.category ?? '';
    subcategoryController.text = treatment.subcategory ?? '';
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

  void onCategorySelected(String val) {
    subcategoryController.clear();
    state = state.copyWith(); 
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

  // Filter Logic
  void _applyFilters() {
    final query = searchController.text.toLowerCase();
    final category = filterCategoryController.text.toLowerCase();
    final subcategory = filterSubcategoryController.text.toLowerCase();
    final area = filterAreaController.text.toLowerCase();
    final status = filterStatusController.text.toLowerCase();
    
    state = state.copyWith(
      filteredTreatments: state.treatments.where((t) {
        final matchesQuery = query.isEmpty || 
            (t.name?.toLowerCase().contains(query) ?? false) ||
            (t.description?.toLowerCase().contains(query) ?? false);
            
        final matchesCategory = category.isEmpty || 
            (t.category?.toLowerCase() == category);

        final matchesSubcategory = subcategory.isEmpty || 
            (t.subcategory?.toLowerCase() == subcategory);

        final matchesArea = area.isEmpty || 
            (t.sideAreas?.any((a) => a.name?.toLowerCase() == area) ?? false);

        final matchesStatus = status.isEmpty || 
            (status == 'active' && t.isActive) ||
            (status == 'inactive' && !t.isActive);

        return matchesQuery && matchesCategory && matchesSubcategory && matchesArea && matchesStatus;
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
    final category = filterCategoryController.text.toLowerCase();
    final subcategory = filterSubcategoryController.text.toLowerCase();
    final area = filterAreaController.text.toLowerCase();
    final status = filterStatusController.text.toLowerCase();

    return source.where((t) {
      final matchesQuery = query.isEmpty ||
          (t.name?.toLowerCase().contains(query) ?? false) ||
          (t.description?.toLowerCase().contains(query) ?? false);

      final matchesCategory = category.isEmpty || (t.category?.toLowerCase() == category);

      final matchesSubcategory = subcategory.isEmpty || (t.subcategory?.toLowerCase() == subcategory);

      final matchesArea = area.isEmpty || (t.sideAreas?.any((a) => a.name?.toLowerCase() == area) ?? false);

      final matchesStatus = status.isEmpty ||
          (status == 'active' && t.isActive) ||
          (status == 'inactive' && !t.isActive);

      return matchesQuery && matchesCategory && matchesSubcategory && matchesArea && matchesStatus;
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
        category: categoryController.text,
        subcategory: subcategoryController.text,
        materialName: materialNameController.text,
        maxMaterialQuantity: int.tryParse(maxMaterialQuantityController.text) ?? 0,
        useInAiSimulator: state.useInAiSimulator,
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

  Future<void> updateTreatment(BuildContext context) async {
    return await runSafely<void>(showLoading: true, () async {
      // Logic for updating the treatment
      await Future.delayed(const Duration(seconds: 1));
      await getTreatments();
    });
  }
}

class TreatmentState {
  final List<TreatmentModel> treatments;
  final List<TreatmentModel> filteredTreatments;
  final TreatmentModel? selectedTreatment;
  final int? selectedTreatmentId;
  final bool loading;
  final int currentStep;
  final XFile? treatmentImage;
  final XFile? treatmentIcon;
  final List<AreaViewModelEntry> areas;
  
  // Step 4 fields
  final bool useInAiSimulator;

  TreatmentState({
    this.treatments = const [],
    this.filteredTreatments = const [],
    this.selectedTreatment,
    this.loading = false,
    this.selectedTreatmentId,
    this.currentStep = 0,
    this.treatmentImage,
    this.treatmentIcon,
    this.useInAiSimulator = false,
    List<AreaViewModelEntry>? areas,
  }) : areas = areas ?? [AreaViewModelEntry()];

  TreatmentState copyWith({
    bool? loading,
    List<TreatmentModel>? treatments,
    List<TreatmentModel>? filteredTreatments,
    TreatmentModel? selectedTreatment,
    int? selectedTreatmentId,
    int? currentStep,
    XFile? treatmentImage,
    XFile? treatmentIcon,
    List<AreaViewModelEntry>? areas,
    bool? useInAiSimulator,
  }) {
    return TreatmentState(
      loading: loading ?? this.loading,
      treatments: treatments ?? this.treatments,
      filteredTreatments: filteredTreatments ?? this.filteredTreatments,
      selectedTreatment: selectedTreatment ?? this.selectedTreatment,
      selectedTreatmentId: selectedTreatmentId ?? this.selectedTreatmentId,
      currentStep: currentStep ?? this.currentStep,
      treatmentImage: treatmentImage ?? this.treatmentImage,
      treatmentIcon: treatmentIcon ?? this.treatmentIcon,
      areas: areas ?? this.areas,
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
