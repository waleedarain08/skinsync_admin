import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skinsync_admin/models/requests/create_area_request.dart';
import 'package:skinsync_admin/models/requests/update_area_request.dart';
import 'package:skinsync_admin/services/media_service.dart';
import 'package:skinsync_admin/utils/exception.dart';
import '../models/responses/area_list_response.dart';
import '../repositories/area_repository.dart';
import '../services/locator.dart';
import 'base_state_model.dart';
import 'base_view_model.dart';
import 'treatment_data_view_model.dart';

final areaViewModelProvider = NotifierProvider<AreaViewModel, AreaState>(
  AreaViewModel.new,
);

class AreaState extends BaseStateModel {
  final List<AreaModel> areas;
  final List<AreaModel> flattenedAreas;
  final String? errorMessage;
  final String? areaIconUrl;
  final String? areaImageUrl;

  AreaState({
    super.loading,
    this.areas = const [],
    this.flattenedAreas = const [],
    this.errorMessage,
    this.areaIconUrl,
    this.areaImageUrl,
  });

  AreaState copyWith({
    bool? loading,
    List<AreaModel>? areas,
    List<AreaModel>? flattenedAreas,
    String? errorMessage,
    String? areaIconUrl,
    String? areaImageUrl,
  }) {
    return AreaState(
      loading: loading ?? this.loading,
      areas: areas ?? this.areas,
      flattenedAreas: flattenedAreas ?? this.flattenedAreas,
      errorMessage: errorMessage ?? this.errorMessage,
      areaIconUrl: areaIconUrl ?? this.areaIconUrl,
      areaImageUrl: areaImageUrl ?? this.areaImageUrl,
    );
  }
}

class AreaViewModel extends BaseViewModel<AreaState> {
  AreaViewModel() : super(AreaState());

  final AreaRepository _areaRepository = locator<AreaRepository>();
  final ImagePicker _picker = ImagePicker();
  Future<void> fetchAreas() async {
    state = state.copyWith(errorMessage: null);
    await runSafely(
      onLoadingChange: (loading) => state = state.copyWith(loading: loading),
      () async {
        try {
          final fetched = await _areaRepository.getAreas();
          final flattened = _flattenAreas(fetched);
          state = state.copyWith(areas: fetched, flattenedAreas: flattened);
          ref
              .read(treatmentDataViewModelProvider.notifier)
              .setAreasFromBackend(fetched);
        } catch (e) {
          state = state.copyWith(errorMessage: e.toString());
          rethrow;
        }
      },
    );
  }

  // Future<AreaModel?> createArea({
  //   required String name,
  //   required String globalSku,
  //   required String icon,
  // }) async {
  //   return await runSafely<AreaModel?>(() async {
  //     final String? imageUrl = await MediaService().uploadImage(
  //       'areas/icons/',
  //       XFile(icon),
  //     );
  //     if (imageUrl == null) {
  //       throw const UnknownException('Failed to upload image');
  //     }
  //     return await _areaRepository.createArea(
  //       AreaRequest(name: name, globalSku: globalSku, icon: imageUrl),
  //     );
  //   });
  // }

  Future<bool?> createArea({
    required String name,
    required String globalSku,
    required String icon,
    required int? parentId,
    required String imageUrl,
  }) async {
    return await runSafely<bool>(() async {
      await _areaRepository.createArea(
        CreateAreaRequest(
          parentId: parentId,
          name: name,
          globalSku: globalSku,
          icon: icon,
          image: imageUrl,
        ),
      );
      await refreshAreas();
      return true;
    });
  }

  Future<bool?> callUpdateArea({
    required String name,
    required String globalSku,
    required String icon,
    required String imageUrl,
    required int id,
  }) async {
    return await runSafely<bool>(() async {
      final response = await _areaRepository.updateArea(
        request: UpdateAreaRequest(
          name: name,
          globalSku: globalSku,
          icon: icon,
          image: imageUrl,
        ),
        id: id,
      );

      if (response.isSuccess) {
        await refreshAreas();
      }
      return true;
    });
  }

  Future<bool?> callDeletArea({required int id}) async {
    return await runSafely<bool>(() async {
      final response = await _areaRepository.deleteArea(id: id);
      if (response.isSuccess) {
        await refreshAreas();
      }

      return true;
    });
  }

  Future<void> refreshAreas() async {
    await fetchAreas();
  }

  List<AreaModel> _flattenAreas(List<AreaModel> list) {
    final List<AreaModel> result = [];
    for (final area in list) {
      result.add(area);
      if (area.subAreas.isNotEmpty) {
        result.addAll(_flattenAreas(area.subAreas));
      }
    }
    return result;
  }

  // --- Helper Methods ---

  List<AreaModel> getAllAreas() => state.flattenedAreas;

  AreaModel? findAreaById(int id) {
    try {
      return state.flattenedAreas.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  List<AreaModel> getSubAreas(int parentId) {
    final parent = findAreaById(parentId);
    return parent?.subAreas ?? [];
  }

  Future<void> pickImage(bool isIcon) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    await runSafely(() async {
      final path = isIcon ? 'area/icon/' : 'area/image/';
      final String? url = await MediaService().uploadImage(path, image);
      if (url == null) {
        throw const UnknownException('Failed to upload image');
      }
      if (isIcon) {
        state = state.copyWith(areaIconUrl: url);
      } else {
        state = state.copyWith(areaImageUrl: url);
      }
    });
  }

  List<DropdownMenuItem<int>> getAreaDropdownItems({int? parentId}) {
    final list = parentId == null ? state.areas : getSubAreas(parentId);

    return list
        .map((area) => DropdownMenuItem(value: area.id, child: Text(area.name)))
        .toList();
  }

  // Recursive search for an area by ID in the tree
  AreaModel? findInTree(List<AreaModel> items, int id) {
    for (final item in items) {
      if (item.id == id) return item;
      if (item.subAreas.isNotEmpty) {
        final found = findInTree(item.subAreas, id);
        if (found != null) return found;
      }
    }
    return null;
  }
}
