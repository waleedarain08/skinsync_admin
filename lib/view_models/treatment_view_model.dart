import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skinsync_admin/models/requests/create_treatment_requests/basic_info_request.dart';
// import 'package:skinsync_admin/models/requests/create_treatment_requests/business_logic_request.dart';
import 'package:skinsync_admin/models/requests/create_treatment_requests/treatment_area_request.dart';
import 'package:skinsync_admin/models/requests/session_status_request.dart';
import 'package:skinsync_admin/models/requests/update_treatment_request.dart';
import 'package:skinsync_admin/models/responses/category_detail_response.dart';
import 'package:skinsync_admin/models/responses/treatment_detail_response.dart';
import 'package:skinsync_admin/models/treatment_data_models.dart';
import 'package:skinsync_admin/repositories/category_repository.dart';
import 'package:skinsync_admin/repositories/treatment_repository.dart';
import 'package:skinsync_admin/services/locator.dart';
import 'package:skinsync_admin/services/media_service.dart';
import 'package:skinsync_admin/utils/enums.dart';
import 'package:skinsync_admin/utils/exception.dart';
import 'package:skinsync_admin/utils/sku_utils.dart';
import 'package:skinsync_admin/view_models/session_view_model.dart';

import '../models/requests/create_treatment_requests/update_basic_info_request.dart';
import '../models/responses/treatment_list_response.dart';
import 'base_state_model.dart';
import 'base_view_model.dart';
import 'category_view_model.dart';
import 'treatment_data_view_model.dart';

final treatmentViewModelProvider =
    NotifierProvider<TreatmentViewModel, TreatmentState>(TreatmentViewModel._);

class TreatmentViewModel extends BaseViewModel<TreatmentState> {
  TreatmentViewModel._() : super(TreatmentState());

  final int _formSessionId = 0;
  int get formSessionId => _formSessionId;

  // static final List<TreatmentListData> _localTreatments = List.from(
  //   TreatmentData.dummyTreatments,
  // );

  final TreatmentRepository _treatmentRepository =
      locator<TreatmentRepository>();
  final CategoryRepository _categoryRepository = locator<CategoryRepository>();

  // Step 1 Controllers (Basic Info)
  final globalSkuController = TextEditingController();
  final internalNameController = TextEditingController();
  final displayNameController = TextEditingController();
  final fullDescriptionController = TextEditingController();
  final shortDescriptionController = TextEditingController();

  // Step 2 Controllers (Category Path)
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
  void init() {
    super.init();
    displayNameController.addListener(_onTextChanged);
    internalNameController.addListener(_onTextChanged);
    categoryNameController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    state = state.copyWith();
  }

  @override
  void dispose() {
    globalSkuController.dispose();
    internalNameController.dispose();
    displayNameController.dispose();
    fullDescriptionController.dispose();
    shortDescriptionController.dispose();
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
    super.dispose();
  }

  Future<void> initialize() async {
    await getTreatments();
  }

  void clearBasicInfoControllers() {
    globalSkuController.clear();
    internalNameController.clear();
    displayNameController.clear();
    fullDescriptionController.clear();
    shortDescriptionController.clear();
    state = state.copyWith(
      clearTreatmentImageUrl: true,
      clearTreatmentIconUrl: true,
      enableByDefault: false,
      useInAiSimulator: false,
    );
  }

  void setBasicInfoControllers(TreatmentDetailDto detail) {
    globalSkuController.text = detail.globalSku ?? '';
    internalNameController.text = detail.patientDisplayName ?? '';
    displayNameController.text = detail.patientDisplayName ?? '';
    fullDescriptionController.text = detail.description ?? '';
    shortDescriptionController.text = detail.shortDescription ?? '';
    state = state.copyWith(
      treatmentImageUrl: detail.image,
      treatmentIconUrl: detail.icon,
      enableByDefault: detail.enableByDefault ?? false,
      useInAiSimulator: detail.useInAiSimulator ?? false,
    );
  }

  Future<bool?> getTreatments({
    int page = 1,
    String search = '',
    int limit = 10,
    int? categoryId,
    TreatmentStatus? status,
    bool showLoading = false,
  }) async {
    return await runSafely<bool?>(showLoading: showLoading, () async {
      state = state.copyWith(loading: true, currentPage: page);
      final response = await _treatmentRepository.getTreatments(
        page: page,
        limit: limit,
        search: search,
        categoryId: categoryId,
        status: status,
      );
      final list = (response.data ?? []).map((dto) {
        return TreatmentListData(
          id: dto.id,
          patientDisplayName: dto.patientDisplayName,
          shortDescription: dto.shortDescription,
          globalSku: dto.globalSku,
          icon: dto.icon,
          image: dto.image,
          status: dto.status ?? 'active',
        );
      }).toList();

      state = state.copyWith(
        treatments: categoryId == null ? list : null,
        filteredTreatments: list,
        createTreatments: categoryId != null ? list : null,
        loading: false,
        currentPage: response.page ?? page,
        totalPages: response.totalPages ?? 1,
        totalResults: list.length,
      );
      return true;
    });
  }

  Future<bool?> fetchTreatmentDetail(int id, {bool loading = true}) async {
    return await runSafely<bool>(showLoading: loading, () async {
      final response = await _treatmentRepository.getTreatmentDetail(id: id);
      if (response.isSuccess && response.data != null) {
        state = state.copyWith(
          selectedTreatmentId: response.data?.id,
          selectedTreatmentDetail: response.data,
        );
        return true;
      }
      return false;
    });
  }

  Future<bool?> changeSessionStatus({
    required SessionStatusRequest request,
  }) async {
    return await runSafely<bool>(() async {
      final response = await _treatmentRepository.changeSessionStatus(
        request: request,
      );
      if (response.isSuccess) {
        final treatmentId = state.selectedTreatmentDetail?.id;
        if (treatmentId != null) {
          await fetchTreatmentDetail(treatmentId, loading: false);
        }
        // NEW: also sync SessionsStep's data source
        final areaId = state.selectedTreatmentAreaIds.isNotEmpty
            ? state.selectedTreatmentAreaIds.last
            : null;
        if (treatmentId != null && areaId != null) {
          await ref
              .read(sessionViewModelProvider.notifier)
              .fetchSessions(treatmentId: treatmentId, areaId: areaId);
        }
      }

      return true;
    });
  }

  Future<bool?> changeTreatmentStatus(
    int treatmentId,
    String status, {
    bool callDetail = false,
  }) async {
    return await runSafely<bool>(
      showLoading: false,
      onLoadingChange: (loading) {
        if (!callDetail) {
          state = state.copyWith(loading: loading);
        }
      },
      () async {
        await _treatmentRepository.updateTreatmentStatus(
          treatmentId: treatmentId,
          status: status,
        );
        if (callDetail == false) {
          await getTreatments(page: state.currentPage);

          if (state.selectedTreatment?.id == treatmentId) {
            final updated = state.treatments.firstWhere(
              (t) => t.id == treatmentId,
              orElse: () => state.selectedTreatment!,
            );
            state = state.copyWith(selectedTreatment: updated);
          }
        } else {
          await fetchTreatmentDetail(treatmentId, loading: false);
        }

        await EasyLoading.showSuccess('Treatment status updated successfully');
        return true;
      },
    );
  }

  void resetForm() {
    globalSkuController.clear();
    internalNameController.clear();
    displayNameController.clear();
    fullDescriptionController.clear();
    shortDescriptionController.clear();
    categoryIdController.clear();
    categoryNameController.clear();
    categoryPathController.clear();

    for (final area in state.areas) {
      area.dispose();
    }

    state = state.copyWith(
      currentStep: 0,
      sessionStep: 3,
      clearTreatmentImage: true,
      clearTreatmentIcon: true,
      clearTreatmentImageUrl: true,
      clearTreatmentIconUrl: true,
      areas: [AreaViewModelEntry()],
      selectedTreatment: null,
      useInAiSimulator: false,
      enableByDefault: false,
      status: 'active',
    );
  }

  void setStatus(String status) {
    state = state.copyWith(status: status);
  }

  void selectTreatment(TreatmentListData treatment) {
    state = state.copyWith(selectedTreatment: treatment);

    globalSkuController.text = treatment.globalSku ?? '';
    internalNameController.text = treatment.patientDisplayName ?? '';
    shortDescriptionController.text = treatment.shortDescription ?? '';

    state = state.copyWith(
      selectedTreatmentId: treatment.id,
      status: treatment.status,
      treatmentImageUrl: treatment.image,
      treatmentIconUrl: treatment.icon,
    );
  }

  Future<bool?> createTreatmentArea() async {
    return await runSafely<bool>(() async {
      await _treatmentRepository.createTreatmentArea(
        TreatmentAreaRequest(selectedAreaIds: state.selectedTreatmentAreaIds),
        state.selectedTreatment!.id!,
      );
      log('Treatment Area Created : ${state.selectedTreatment!.id!}');
      return true;
    });
  }

  Future<bool?> createBasicInfo() async {
    return await runSafely<bool>(() async {
      final imageUrl = state.treatmentImageUrl;
      final iconUrl = state.treatmentIconUrl;

      if (imageUrl == null || iconUrl == null) {
        throw const UnknownException('Please Select Image & Icon');
      }

      final response = await _treatmentRepository.createBasicInfo(
        BasicInfoRequest(
          selectedCategoryIds: state.selectedCategoryPath,
          patientDisplayName: displayNameController.text,
          image: imageUrl,
          shortDescription: shortDescriptionController.text,
          description: fullDescriptionController.text,
          globalSku: globalSkuController.text,
          icon: iconUrl,
          enableByDefault: state.enableByDefault,
          useInAiSimulator: state.useInAiSimulator,
        ),
      );
      if (response.isSuccess) {
        log('Basic Info Created : ${response.data?.id}');
        state = state.copyWith(draftTreatmentID: response.data?.id);
        selectTreatment(
          TreatmentListData(
            id: response.data?.id,
            patientDisplayName: response.data?.patientDisplayName,
            shortDescription: response.data?.shortDescription,
            globalSku: response.data?.globalSku,
            icon: response.data?.icon,
            image: response.data?.image,
            status: response.data?.status ?? 'active',
          ),
        );
        final categoryId = int.tryParse(categoryIdController.text);
        await getTreatments(categoryId: categoryId);
      }
      return true;
    });
  }

  Future<bool?> updateBasicInfo({required int id}) async {
    return await runSafely<bool>(() async {
      final imageUrl = state.treatmentImageUrl;
      final iconUrl = state.treatmentIconUrl;

      if (imageUrl == null || iconUrl == null) {
        throw const UnknownException('Please Select Image & Icon');
      }

      final response = await _treatmentRepository.updateBasicInfo(
        UpdateBasicInfoRequest(
          selectedCategoryIds:
              state.selectedTreatmentDetail?.selectedCategories
                  ?.map((e) => e.id!)
                  .toList() ??
              [],
          patientDisplayName: displayNameController.text,
          image: imageUrl,
          shortDescription: shortDescriptionController.text,
          description: fullDescriptionController.text,
          globalSku: globalSkuController.text,
          icon: iconUrl,
          enableByDefault: state.enableByDefault,
          useInAiSimulator: state.useInAiSimulator,
        ),
        id,
      );
      if (response.isSuccess) {
        await fetchTreatmentDetail(id);
      }
      return true;
    });
  }

  void setStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void setBusinessLogic(TreatmentDetailDto detail) {
    state = state.copyWith(
      enableByDefault: detail.enableByDefault,
      useInAiSimulator: detail.useInAiSimulator,
    );
  }

  // Future<bool?> callBusinessLogic({
  //   bool isUpdate = false,
  //   int? updatetreatmentId,
  // }) async {
  //   return await runSafely(() async {
  //     int? treatmentId;
  //     if (updatetreatmentId == null) {
  //       treatmentId = state.selectedTreatment!.id;
  //       if (treatmentId == null) {
  //         throw const UnknownException('Treatment not found!');
  //       }
  //     }
  //     if (isUpdate && updatetreatmentId == null) {
  //       throw const UnknownException('Treatment not found!');
  //     }
  //     final response = await _treatmentRepository.businessLogic(
  //       draftTreatmentId: isUpdate ? updatetreatmentId! : treatmentId!,
  //       request: BusinessLogicRequest(
  //         enableByDefault: state.enableByDefault,
  //         useInAiSimulator: state.useInAiSimulator,
  //       ),
  //     );
  //     if (response.isSuccess && isUpdate) {
  //       await fetchTreatmentDetail(updatetreatmentId!);
  //     }
  //     return true;
  //   });
  // }

  // ignore: avoid_positional_boolean_parameters
  Future<void> pickImage(bool isIcon) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    await runSafely(() async {
      final path = isIcon ? 'treatment/icon/' : 'treatment/image/';
      final String? url = await MediaService().uploadImage(path, image);
      if (url == null) {
        throw const UnknownException('Failed to upload image');
      }
      if (isIcon) {
        state = state.copyWith(treatmentIconUrl: url);
      } else {
        state = state.copyWith(treatmentImageUrl: url);
      }
    });
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

  Future<void> onCategorySelected(CategoryModel? category, String path) async {
    if (category == null) {
      categoryIdController.clear();
      categoryNameController.clear();
      categoryPathController.clear();
      state = state.copyWith(
        selectedCategoryDetail: null,
        selectedCategoryPath: [],
      );
      return;
    }
    categoryIdController.text = category.id.toString();
    categoryNameController.text = category.name;
    categoryPathController.text = path;

    final allCategories = ref.read(categoryViewModelProvider).categories;
    final pathIds = _findPathToCategory(allCategories, category.id, []);

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
          return true;
        }) ??
        false;
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
        SubAreaConfig(name: val, id: 0),
      ];
      updatedAreas[areaIndex].subAreaController.clear();
      state = state.copyWith(areas: updatedAreas);
    }
  }

  void removeSubArea(int areaIndex, String subAreaName) {
    final updatedAreas = [...state.areas];
    final subAreaToRemove = updatedAreas[areaIndex].subAreas.firstWhere(
      (s) => s.name != subAreaName,
      orElse: () => updatedAreas[areaIndex].subAreas.first,
    );
    subAreaToRemove.dispose();
    updatedAreas[areaIndex].subAreas = updatedAreas[areaIndex].subAreas
        .where((s) => s.name != subAreaName)
        .toList();
    state = state.copyWith(areas: updatedAreas);
  }

  // Step 4 Actions (Logic Step is Reverted here!)
  void toggleAiSimulator(bool? value) {
    state = state.copyWith(useInAiSimulator: value ?? false);
  }

  void toggleEnableByDefault(bool? value) {
    state = state.copyWith(enableByDefault: value ?? false);
  }

  // Filter Logic
  void _applyFilters() {
    final query = searchController.text.toLowerCase();
    final status = filterStatusController.text.toLowerCase();

    state = state.copyWith(
      filteredTreatments: state.treatments.where((t) {
        final matchesQuery =
            query.isEmpty ||
            (t.patientDisplayName?.toLowerCase().contains(query) ?? false) ||
            (t.description?.toLowerCase().contains(query) ?? false);

        final matchesStatus =
            status.isEmpty ||
            (status == 'active' && t.status == 'active') ||
            (status == 'deactive' && t.status == 'deactive') ||
            (status == 'draft' && t.status == 'draft');

        return matchesQuery && matchesStatus;
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

  // void toggleTreatmentStatus(int treatmentId) {
  //   final index = _localTreatments.indexWhere((t) => t.id == treatmentId);
  //   if (index != -1) {}
  //
  //   state = state.copyWith(
  //     treatments: List.from(_localTreatments),
  //     filteredTreatments: _getFilteredList(_localTreatments),
  //   );
  // }

  // void deleteTreatment(int treatmentId) {
  //   _localTreatments.removeWhere((t) => t.id == treatmentId);
  //   state = state.copyWith(
  //     treatments: List.from(_localTreatments),
  //     filteredTreatments: _getFilteredList(_localTreatments),
  //   );
  // }

  List<TreatmentListData> _getFilteredList(List<TreatmentListData> source) {
    final query = searchController.text.toLowerCase();
    final status = filterStatusController.text.toLowerCase();

    return source.where((t) {
      final matchesQuery =
          query.isEmpty ||
          (t.patientDisplayName?.toLowerCase().contains(query) ?? false) ||
          (t.description?.toLowerCase().contains(query) ?? false);

      final matchesStatus =
          status.isEmpty ||
          (status == 'active' && t.status == 'active') ||
          (status == 'deactive' && t.status == 'deactive') ||
          (status == 'draft' && t.status == 'draft');

      return matchesQuery && matchesStatus;
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
      final draftId = state.draftTreatmentID;
      if (draftId != null) {
        await changeTreatmentStatus(draftId, 'Active');
      }
      await Future.delayed(const Duration(seconds: 1));
      resetForm();
      await getTreatments();
    });
  }

  Future<void> updateTreatment(
    BuildContext context, {
    List<CategoryModel> categories = const [],
  }) async {
    final treatmentId = state.selectedTreatment?.id;
    if (treatmentId == null) {
      EasyLoading.showError('No treatment selected for update');
      return;
    }

    return await runSafely<void>(showLoading: true, () async {
      final request = UpdateTreatmentRequest();

      await _treatmentRepository.updateTreatment(
        treatmentId: treatmentId,
        request: request,
      );

      await getTreatments(page: state.currentPage);
      EasyLoading.showSuccess('Treatment template updated successfully');
    });
  }

  String? validateGlobalSku(String? sku, {int? currentTreatmentId}) {
    final existingSkus = state.treatments
        .map((t) => t.globalSku ?? '')
        .where((sku) => sku.isNotEmpty)
        .toList();
    final currentSku = state.treatments
        .firstWhere(
          (t) => t.id == currentTreatmentId,
          orElse: TreatmentListData.new,
        )
        .globalSku;

    return SkuUtils.validateGlobalSku(
      sku,
      existingSkus: existingSkus,
      currentSku: currentSku,
    );
  }

  void generateSku() {
    final existingSkus = state.treatments
        .map((t) => t.globalSku ?? '')
        .where((sku) => sku.isNotEmpty)
        .toList();

    globalSkuController.text = SkuUtils.generateSku(existingSkus: existingSkus);
  }

  // void updateTreatmentState({
  //   List<AreaViewModelEntry>? areas,
  //   String? status,
  //   String? gender,
  // }) {
  //   state = state.copyWith(areas: areas, status: status);
  // }

  List<int> _getDynamicSelectedAreaIds(List<AreaViewModelEntry> areas) {
    final List<int> ids = [];
    final dataState = ref.read(treatmentDataViewModelProvider);

    for (final areaEntry in areas) {
      if (areaEntry.areaController.text.isEmpty) continue;

      final dynamic areaModel = dataState.areas.cast<dynamic>().firstWhere(
        (a) => a?.name == areaEntry.areaController.text,
        orElse: () => null,
      );
      if (areaModel != null) {
        ids.add(areaModel.id);

        for (final subAreaConfig in areaEntry.subAreas) {
          final dynamic subAreaModel = areaModel.subAreas
              .cast<dynamic>()
              .firstWhere(
                (sa) =>
                    sa != null &&
                    (sa.id == subAreaConfig.id ||
                        sa.name == subAreaConfig.name),
                orElse: () => null,
              );
          if (subAreaModel != null) {
            ids.add(subAreaModel.id);

            for (final childConfig in subAreaConfig.children) {
              final dynamic childModel = subAreaModel.subAreas
                  .cast<dynamic>()
                  .firstWhere(
                    (ca) => ca?.name == childConfig.name,
                    orElse: () => null,
                  );
              if (childModel != null) {
                ids.add(childModel.id);
              }
            }
          }
        }
      }
    }
    return ids;
  }

  void updateAreas(List<AreaViewModelEntry> areas) {
    final dynamicIds = _getDynamicSelectedAreaIds(areas);
    state = state.copyWith(areas: areas, selectedTreatmentAreaIds: dynamicIds);
  }

  @override
  void onError(String message) {
    state = state.copyWith(loading: false);
    super.onError(message);
  }
}

class TreatmentState extends BaseStateModel {
  final List<TreatmentListData> treatments;
  final List<TreatmentListData> createTreatments;

  final List<TreatmentListData> filteredTreatments;
  final TreatmentListData? selectedTreatment;
  final int? selectedTreatmentId;
  final int? draftTreatmentID;
  final CategoryDetailDto? selectedCategoryDetail;
  final TreatmentDetailDto? selectedTreatmentDetail;
  final int treatmentStep;
  final int sessionStep;

  final String? treatmentImageUrl;
  final String? treatmentIconUrl;

  final List<AreaViewModelEntry> areas;
  final List<int> selectedCategoryPath;
  final String status; // draft | active | deactive
  final String gender; // both | male | female

  final bool useInAiSimulator;
  final bool enableByDefault;

  final List<int> selectedTreatmentAreaIds;

  TreatmentState({
    super.loading,
    super.currentPage,
    super.totalPages,
    super.totalResults,
    this.treatments = const [],
    this.createTreatments = const [],
    this.filteredTreatments = const [],
    this.selectedTreatment,
    this.selectedTreatmentId,
    this.selectedCategoryDetail,
    this.selectedTreatmentDetail,
    this.treatmentStep = 0,
    this.sessionStep = 3,
    this.selectedCategoryPath = const [],
    this.status = 'active',
    this.gender = 'both',
    this.treatmentImageUrl,
    this.treatmentIconUrl,
    this.draftTreatmentID,
    this.useInAiSimulator = false,
    this.enableByDefault = false,
    List<AreaViewModelEntry>? areas,
    this.selectedTreatmentAreaIds = const [],
  }) : areas = areas ?? [AreaViewModelEntry()];

  TreatmentState copyWith({
    bool? loading,
    int? currentPage,
    int? totalPages,
    int? totalResults,
    bool clearTreatmentImage = false,
    bool clearTreatmentIcon = false,
    List<TreatmentListData>? treatments,
    List<TreatmentListData>? createTreatments,
    List<TreatmentListData>? filteredTreatments,
    TreatmentListData? selectedTreatment,
    int? selectedTreatmentId,
    int? currentStep,
    int? sessionStep,
    int? draftTreatmentID,
    List<AreaViewModelEntry>? areas,
    List<int>? selectedCategoryPath,
    String? status,
    String? gender,
    bool? useInAiSimulator,
    bool? enableByDefault,
    CategoryDetailDto? selectedCategoryDetail,
    TreatmentDetailDto? selectedTreatmentDetail,
    List<int>? selectedTreatmentAreaIds,
    bool clearTreatmentImageUrl = false,
    bool clearTreatmentIconUrl = false,
    String? treatmentImageUrl,
    String? treatmentIconUrl,
  }) {
    return TreatmentState(
      selectedCategoryDetail:
          selectedCategoryDetail ?? this.selectedCategoryDetail,
      selectedTreatmentDetail:
          selectedTreatmentDetail ?? this.selectedTreatmentDetail,
      loading: loading ?? this.loading,
      draftTreatmentID: draftTreatmentID ?? this.draftTreatmentID,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalResults: totalResults ?? this.totalResults,
      treatments: treatments ?? this.treatments,
      createTreatments: createTreatments ?? this.createTreatments,
      filteredTreatments: filteredTreatments ?? this.filteredTreatments,
      selectedTreatment: selectedTreatment ?? this.selectedTreatment,
      selectedTreatmentId: selectedTreatmentId ?? this.selectedTreatmentId,
      treatmentStep: currentStep ?? treatmentStep,
      sessionStep: sessionStep ?? this.sessionStep,
      areas: areas ?? this.areas,
      selectedCategoryPath: selectedCategoryPath ?? this.selectedCategoryPath,
      status: status ?? this.status,
      gender: gender ?? this.gender,
      useInAiSimulator: useInAiSimulator ?? this.useInAiSimulator,
      enableByDefault: enableByDefault ?? this.enableByDefault,
      selectedTreatmentAreaIds:
          selectedTreatmentAreaIds ?? this.selectedTreatmentAreaIds,
      treatmentImageUrl: clearTreatmentImageUrl
          ? null
          : (treatmentImageUrl ?? this.treatmentImageUrl),
      treatmentIconUrl: clearTreatmentIconUrl
          ? null
          : (treatmentIconUrl ?? this.treatmentIconUrl),
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
  final int id;
  final basePriceController = TextEditingController(text: '0');
  final Map<String, TextEditingController> unitPriceControllers = {};
  List<SubAreaChildConfig> children = [];

  SubAreaConfig({
    required this.name,
    this.id = 0,
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
