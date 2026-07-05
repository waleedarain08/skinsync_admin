import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/responses/area_list_response.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/treatment_data_view_model.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/widgets/nested_area_selector.dart';

class AreasStep extends ConsumerWidget {
  const AreasStep({super.key});

  Widget _sectionTitle(BuildContext context, String title, {double? fontSize}) {
    return Text(
      title,
      style: context.fonts.black18w600.copyWith(
        fontSize: fontSize != null ? context.sp(fontSize) : null,
      ),
    );
  }

  void _handleAreaToggle(
    AreaModel area,
    TreatmentState state,
    TreatmentViewModel viewModel,
  ) {
    final cleanAreas = state.areas
        .where((a) => a.areaController.text.isNotEmpty)
        .toList();
    final index = cleanAreas.indexWhere(
      (a) => a.areaController.text == area.name,
    );
    if (index == -1) {
      // New area selected. Dispose any previously selected areas.
      for (final a in cleanAreas) {
        a.dispose();
      }
      final newEntry = AreaViewModelEntry();
      newEntry.areaController.text = area.name;
      viewModel.updateAreas([newEntry]);
    } else {
      // Same area deselected.
      final updated = [...cleanAreas];
      updated[index].dispose();
      updated.removeAt(index);
      viewModel.updateAreas([AreaViewModelEntry()]);
    }
  }

  void _handleSubAreaToggle(
    AreaModel area,
    AreaModel subArea,
    TreatmentState state,
    TreatmentViewModel viewModel,
  ) {
    final cleanAreas = state.areas
        .where((a) => a.areaController.text.isNotEmpty)
        .toList();
    final index = cleanAreas.indexWhere(
      (a) => a.areaController.text == area.name,
    );
    if (index == -1) {
      // Subarea of a different area selected. Clear others.
      for (final a in cleanAreas) {
        a.dispose();
      }
      final newEntry = AreaViewModelEntry();
      newEntry.areaController.text = area.name;
      newEntry.subAreas = [SubAreaConfig(name: subArea.name, id: subArea.id)];
      viewModel.updateAreas([newEntry]);
    } else {
      final areaEntry = cleanAreas[index];
      final subIndex = areaEntry.subAreas.indexWhere(
        (s) => s.name == subArea.name,
      );
      if (subIndex == -1) {
        areaEntry.subAreas = [
          ...areaEntry.subAreas,
          SubAreaConfig(name: subArea.name, id: subArea.id),
        ];
      } else {
        areaEntry.subAreas = areaEntry.subAreas
            .where((s) => s.name != subArea.name)
            .toList();
      }
      viewModel.updateAreas(cleanAreas);
    }
  }

  void _handleSubAreaChildToggle(
    AreaModel area,
    AreaModel subArea,
    AreaModel child,
    TreatmentState state,
    TreatmentViewModel viewModel,
  ) {
    final cleanAreas = state.areas
        .where((a) => a.areaController.text.isNotEmpty)
        .toList();
    final index = cleanAreas.indexWhere(
      (a) => a.areaController.text == area.name,
    );
    if (index == -1) {
      // Child of a subarea of a different area selected. Clear others.
      for (final a in cleanAreas) {
        a.dispose();
      }
      final newEntry = AreaViewModelEntry();
      newEntry.areaController.text = area.name;
      newEntry.subAreas = [
        SubAreaConfig(
          name: subArea.name,
          id: subArea.id,
          children: [SubAreaChildConfig(name: child.name)],
        ),
      ];
      viewModel.updateAreas([newEntry]);
    } else {
      final areaEntry = cleanAreas[index];
      final subIndex = areaEntry.subAreas.indexWhere(
        (s) => s.name == subArea.name,
      );
      if (subIndex == -1) {
        areaEntry.subAreas = [
          ...areaEntry.subAreas,
          SubAreaConfig(
            name: subArea.name,
            id: subArea.id,
            children: [SubAreaChildConfig(name: child.name)],
          ),
        ];
      } else {
        final subConfig = areaEntry.subAreas[subIndex];
        final childIndex = subConfig.children.indexWhere(
          (c) => c.name == child.name,
        );
        if (childIndex == -1) {
          subConfig.children = [
            ...subConfig.children,
            SubAreaChildConfig(name: child.name),
          ];
        } else {
          subConfig.children = subConfig.children
              .where((c) => c.name != child.name)
              .toList();
        }
      }
      viewModel.updateAreas(cleanAreas);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(treatmentViewModelProvider);
    final viewModel = ref.read(treatmentViewModelProvider.notifier);
    final dataState = ref.watch(treatmentDataViewModelProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Body Areas Selection'),
        context.verticalSpace(8),
        Text(
          'Select body areas and sub-areas for this treatment journey.',
          style: context.fonts.grey14w400,
        ),
        context.verticalSpace(32),
        NestedAreaSelector(
          areas: dataState.areas,
          selectedAreas: state.areas,
          onAreaToggle: (AreaModel area) =>
              _handleAreaToggle(area, state, viewModel),
          onSubAreaToggle: (AreaModel area, AreaModel subArea) =>
              _handleSubAreaToggle(area, subArea, state, viewModel),
          onSubAreaChildToggle:
              (AreaModel area, AreaModel subArea, AreaModel child) =>
                  _handleSubAreaChildToggle(
                    area,
                    subArea,
                    child,
                    state,
                    viewModel,
                  ),
          onAddArea: (String name, String sku, String icon) async {
            await ref
                .read(treatmentDataViewModelProvider.notifier)
                .addArea(name, sku: sku, icon: icon);
          },
          onAddSubArea: ({required int parentAreaId, required String parentAreaName, required String name, String? sku, String? icon}) =>
              ref.read(treatmentDataViewModelProvider.notifier).addSubArea(
                    parentAreaId: parentAreaId,
                    parentAreaName: parentAreaName,
                    name: name,
                    sku: sku,
                    icon: icon,
                  ),
          onAddSubAreaChild: (parentArea, parentSubArea, name, sku, icon) {
            ref
                .read(treatmentDataViewModelProvider.notifier)
                .addSubAreaChild(
                  parentArea,
                  parentSubArea,
                  name,
                  sku: sku,
                  icon: icon,
                );
          },
        ),
      ],
    );
  }
}