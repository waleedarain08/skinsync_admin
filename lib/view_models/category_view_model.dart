import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skinsync_admin/models/requests/create_category_request.dart';
import '../models/responses/category_list_response.dart';
import '../models/responses/category_detail_response.dart';
import '../repositories/category_repository.dart';
import '../services/locator.dart';
import '../services/media_service.dart';
import 'base_state_model.dart';
import 'base_view_model.dart';

final categoryViewModelProvider =
    NotifierProvider<CategoryViewModel, CategoryState>(CategoryViewModel.new);

class CategoryState extends BaseStateModel {
  final List<CategoryModel> categories;
  final List<CategoryModel> flattenedCategories;
  final CategoryDetailDto? selectedCategoryDetail;

  CategoryState({
    super.loading,
    this.categories = const [],
    this.flattenedCategories = const [],
    this.selectedCategoryDetail,
  });

  CategoryState copyWith({
    bool? loading,
    List<CategoryModel>? categories,
    List<CategoryModel>? flattenedCategories,
    CategoryDetailDto? selectedCategoryDetail,
  }) {
    return CategoryState(
      loading: loading ?? this.loading,
      categories: categories ?? this.categories,
      flattenedCategories: flattenedCategories ?? this.flattenedCategories,
      selectedCategoryDetail:
          selectedCategoryDetail ?? this.selectedCategoryDetail,
    );
  }
}

class CategoryViewModel extends BaseViewModel<CategoryState> {
  CategoryViewModel() : super(CategoryState());

  @override
  void init() {
    super.init();
    // fetchCategories(); // Can fetch here or in UI as per instructions
  }

  final CategoryRepository _categoryRepository = locator<CategoryRepository>();
  final MediaService _mediaService = MediaService();

  Future<String?> uploadCategoryIcon(
    XFile image, {
    bool showLoading = true,
    bool showError = true,
  }) async {
    final url = await runSafely<String?>(
      () => _mediaService.uploadImage('category/icon', image),
      showLoading: showLoading,
      showError: showError,
    );
    if (url != null) {
      log('Category icon uploaded: $url');
    }
    return url;
  }

  Future<String?> uploadConsentFile(
    PlatformFile file, {
    bool showLoading = true,
    bool showError = true,
  }) async {
    final url = await runSafely<String?>(
      () => _mediaService.uploadFile('category/pdf', file),
      showLoading: showLoading,
      showError: showError,
    );
    if (url != null) {
      log('Category consent PDF uploaded: $url');
    }
    return url;
  }

  Future<String?> uploadCategoryImage(
    XFile image, {
    bool showLoading = true,
    bool showError = true,
  }) async {
    final url = await runSafely<String?>(
      () => _mediaService.uploadImage('category/image', image),
      showLoading: showLoading,
      showError: showError,
    );
    if (url != null) {
      log('Category image uploaded: $url');
    }
    return url;
  }

  Future<void> fetchCategories({bool showLoading = true}) async {
    await runSafely(
      showLoading: showLoading,
      onLoadingChange: (loading) => state = state.copyWith(loading: loading),
      () async {
        final categories = await _categoryRepository.getCategories();
        final flattened = _flattenCategories(categories);
        state = state.copyWith(
          categories: categories,
          flattenedCategories: flattened,
        );
      },
    );
  }

  Future<bool?> createCategory({required CreateCategoryRequest request}) async {
    return await runSafely(
      onLoadingChange: (loading) => state = state.copyWith(loading: loading),
      () async {
        final response = await _categoryRepository.createCategory(request);
        if (response.isSuccess) {
          await fetchCategories();
        }
        return true;
      },
    );
  }

  Future<CategoryDetailDto?> getCategoryDetail(int categoryId) async {
    CategoryDetailDto? detailed;
    await runSafely(
      onLoadingChange: (loading) => state = state.copyWith(loading: loading),
      () async {
        detailed = await _categoryRepository.getCategoryDetail(categoryId);
        state = state.copyWith(selectedCategoryDetail: detailed);
      },
    );
    return detailed;
  }

  List<CategoryModel> _flattenCategories(List<CategoryModel> categories) {
    final List<CategoryModel> result = [];
    for (final cat in categories) {
      result.add(cat);
      if (cat.subCategories.isNotEmpty) {
        result.addAll(_flattenCategories(cat.subCategories));
      }
    }
    return result;
  }

  // --- Helper Methods ---

  List<CategoryModel> getAllCategories() => state.flattenedCategories;

  CategoryModel? findCategoryById(int id) {
    try {
      return state.flattenedCategories.firstWhere((cat) => cat.id == id);
    } catch (_) {
      return null;
    }
  }

  List<CategoryModel> getSubCategories(int parentId) {
    final parent = findCategoryById(parentId);
    return parent?.subCategories ?? [];
  }

  List<DropdownMenuItem<int>> getCategoryDropdownItems({int? parentId}) {
    final list = parentId == null
        ? state.categories
        : getSubCategories(parentId);

    return list
        .map((cat) => DropdownMenuItem(value: cat.id, child: Text(cat.name)))
        .toList();
  }

  // Recursive search for a category by ID in the tree
  CategoryModel? findInTree(List<CategoryModel> items, int id) {
    for (final item in items) {
      if (item.id == id) return item;
      if (item.subCategories.isNotEmpty) {
        final found = findInTree(item.subCategories, id);
        if (found != null) return found;
      }
    }
    return null;
  }

  // --- CRUD Actions (In-Memory for now as per instructions) ---

  void addCategory(
    String name, {
    String? icon,
    String? image,
    int? parentId,
    String? consentFormUrl,
    String? consentFormName,
    List<dynamic>? defaultSessions,
    int? totalSessions,
    List<dynamic>? preNotifications,
    List<dynamic>? postNotifications,
    dynamic downtimePresets,
    List<String>? defaultRoles,
  }) {
    if (name.isEmpty) return;
    final newCategory = CategoryModel(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      icon: icon ?? '',
      image: image ?? '',
      parentId: parentId,
      subCategories: [],
    );

    if (parentId == null) {
      state = state.copyWith(categories: [...state.categories, newCategory]);
    } else {
      state = state.copyWith(
        categories: _addChildToTree(state.categories, parentId, newCategory),
      );
    }
    state = state.copyWith(
      flattenedCategories: _flattenCategories(state.categories),
    );
  }

  List<CategoryModel> _addChildToTree(
    List<CategoryModel> items,
    int parentId,
    CategoryModel newChild,
  ) {
    return items.map((item) {
      if (item.id == parentId) {
        return item.copyWith(subCategories: [...item.subCategories, newChild]);
      } else if (item.subCategories.isNotEmpty) {
        return item.copyWith(
          subCategories: _addChildToTree(
            item.subCategories,
            parentId,
            newChild,
          ),
        );
      }
      return item;
    }).toList();
  }

  void editCategory(
    int id,
    String newName, {
    String? icon,
    String? image,
    String? consentFormUrl,
    String? consentFormName,
    List<dynamic>? defaultSessions,
    int? totalSessions,
    List<dynamic>? preNotifications,
    List<dynamic>? postNotifications,
    dynamic downtimePresets,
    List<String>? defaultRoles,
  }) {
    state = state.copyWith(
      categories: _updateInTree(state.categories, id, newName, icon, image),
    );
    state = state.copyWith(
      flattenedCategories: _flattenCategories(state.categories),
    );
  }

  List<CategoryModel> _updateInTree(
    List<CategoryModel> items,
    int id,
    String newName,
    String? icon,
    String? image,
  ) {
    return items.map((item) {
      if (item.id == id) {
        return item.copyWith(
          name: newName,
          icon: icon ?? item.icon,
          image: image ?? item.image,
        );
      } else if (item.subCategories.isNotEmpty) {
        return item.copyWith(
          subCategories: _updateInTree(
            item.subCategories,
            id,
            newName,
            icon,
            image,
          ),
        );
      }
      return item;
    }).toList();
  }

  void deleteCategory(int id) {
    state = state.copyWith(categories: _removeFromTree(state.categories, id));
    state = state.copyWith(
      flattenedCategories: _flattenCategories(state.categories),
    );
  }

  List<CategoryModel> _removeFromTree(List<CategoryModel> items, int id) {
    final filtered = items.where((item) => item.id != id).toList();
    return filtered.map((item) {
      if (item.subCategories.isNotEmpty) {
        return item.copyWith(
          subCategories: _removeFromTree(item.subCategories, id),
        );
      }
      return item;
    }).toList();
  }
}
