import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/treatment_data_models.dart';
import '../utils/dummy_data.dart';

final treatmentDataViewModelProvider = NotifierProvider<TreatmentDataViewModel, TreatmentDataState>(
  () => TreatmentDataViewModel(),
);

class TreatmentDataState {
  final List<CategoryItem> categories;
  final List<AreaItem> areas;
  final List<String> materials;
  final List<CombinationGroup> combinationGroups;

  TreatmentDataState({
    required this.categories,
    required this.areas,
    required this.materials,
    this.combinationGroups = const [],
  });

  TreatmentDataState copyWith({
    List<CategoryItem>? categories,
    List<AreaItem>? areas,
    List<String>? materials,
    List<CombinationGroup>? combinationGroups,
  }) {
    return TreatmentDataState(
      categories: categories ?? this.categories,
      areas: areas ?? this.areas,
      materials: materials ?? this.materials,
      combinationGroups: combinationGroups ?? this.combinationGroups,
    );
  }
}

class TreatmentDataViewModel extends Notifier<TreatmentDataState> {
  @override
  TreatmentDataState build() {
    // Transform dummy data to models
    final categories = TreatmentData.categoriesWithSubcategories.entries.map((e) {
      return CategoryItem(
        name: e.key,
        subcategories: e.value.map((s) => SubcategoryItem(name: s)).toList(),
      );
    }).toList();

    final areas = TreatmentData.areasWithSubAreas.entries.map((e) {
      return AreaItem(
        name: e.key,
        subAreas: e.value.map((s) => SubAreaItem(name: s)).toList(),
      );
    }).toList();

    return TreatmentDataState(
      categories: categories,
      areas: areas,
      materials: List.from(TreatmentData.consumableTypes),
      combinationGroups: [
        CombinationGroup(id: '1', name: 'Full Face Rejuvenation', treatmentNames: ['Botox', 'Dermal Fillers', 'Skin Tightening']),
        CombinationGroup(id: '2', name: 'Skin Glow Package', treatmentNames: ['Hydra Facial', 'Chemical Peel', 'PRP']),
      ],
    );
  }

  // --- Category Actions ---
  void addCategory(String name, {String? icon}) {
    if (name.isEmpty) return;
    state = state.copyWith(categories: [...state.categories, CategoryItem(name: name, icon: icon)]);
  }

  void editCategory(String oldName, String newName, {String? icon}) {
    state = state.copyWith(
      categories: state.categories.map((c) {
        if (c.name == oldName) {
          return c.copyWith(name: newName, icon: icon ?? c.icon);
        }
        return c;
      }).toList(),
    );
  }

  void deleteCategory(String name) {
    state = state.copyWith(categories: state.categories.where((c) => c.name != name).toList());
  }

  void addSubcategory(String categoryName, String name, {String? icon}) {
    state = state.copyWith(
      categories: state.categories.map((c) {
        if (c.name == categoryName) {
          return c.copyWith(subcategories: [...c.subcategories, SubcategoryItem(name: name, icon: icon)]);
        }
        return c;
      }).toList(),
    );
  }

  void editSubcategory(String categoryName, String oldName, String newName, {String? icon}) {
    state = state.copyWith(
      categories: state.categories.map((c) {
        if (c.name == categoryName) {
          return c.copyWith(
            subcategories: c.subcategories.map((s) {
              if (s.name == oldName) {
                return s.copyWith(name: newName, icon: icon ?? s.icon);
              }
              return s;
            }).toList(),
          );
        }
        return c;
      }).toList(),
    );
  }

  void deleteSubcategory(String categoryName, String name) {
    state = state.copyWith(
      categories: state.categories.map((c) {
        if (c.name == categoryName) {
          return c.copyWith(subcategories: c.subcategories.where((s) => s.name != name).toList());
        }
        return c;
      }).toList(),
    );
  }

  // --- Area Actions ---
  void addArea(String name, {String? icon}) {
    if (name.isEmpty) return;
    state = state.copyWith(areas: [...state.areas, AreaItem(name: name, icon: icon)]);
  }

  void editArea(String oldName, String newName, {String? icon}) {
    state = state.copyWith(
      areas: state.areas.map((a) {
        if (a.name == oldName) {
          return a.copyWith(name: newName, icon: icon ?? a.icon);
        }
        return a;
      }).toList(),
    );
  }

  void deleteArea(String name) {
    state = state.copyWith(areas: state.areas.where((a) => a.name != name).toList());
  }

  void addSubArea(String areaName, String name, {String? icon}) {
    state = state.copyWith(
      areas: state.areas.map((a) {
        if (a.name == areaName) {
          return a.copyWith(subAreas: [...a.subAreas, SubAreaItem(name: name, icon: icon)]);
        }
        return a;
      }).toList(),
    );
  }

  void editSubArea(String areaName, String oldName, String newName, {String? icon}) {
    state = state.copyWith(
      areas: state.areas.map((a) {
        if (a.name == areaName) {
          return a.copyWith(
            subAreas: a.subAreas.map((s) {
              if (s.name == oldName) {
                return s.copyWith(name: newName, icon: icon ?? s.icon);
              }
              return s;
            }).toList(),
          );
        }
        return a;
      }).toList(),
    );
  }

  void deleteSubArea(String areaName, String name) {
    state = state.copyWith(
      areas: state.areas.map((a) {
        if (a.name == areaName) {
          return a.copyWith(subAreas: a.subAreas.where((s) => s.name != name).toList());
        }
        return a;
      }).toList(),
    );
  }

  // --- Material Actions ---
  void addMaterial(String name) {
    if (name.isEmpty || state.materials.contains(name)) return;
    state = state.copyWith(materials: [...state.materials, name]);
  }

  void editMaterial(String oldName, String newName) {
    state = state.copyWith(
      materials: state.materials.map((m) => m == oldName ? newName : m).toList(),
    );
  }

  void deleteMaterial(String name) {
    state = state.copyWith(materials: state.materials.where((m) => m != name).toList());
  }

  // --- Combination Group Actions ---
  void addCombinationGroup(String name, List<String> treatments) {
    state = state.copyWith(
      combinationGroups: [
        ...state.combinationGroups,
        CombinationGroup(id: DateTime.now().toString(), name: name, treatmentNames: treatments),
      ],
    );
  }

  void editCombinationGroup(String id, String name, List<String> treatments) {
    state = state.copyWith(
      combinationGroups: state.combinationGroups.map((g) {
        if (g.id == id) {
          return g.copyWith(name: name, treatmentNames: treatments);
        }
        return g;
      }).toList(),
    );
  }

  void deleteCombinationGroup(String id) {
    state = state.copyWith(
      combinationGroups: state.combinationGroups.where((g) => g.id != id).toList(),
    );
  }
}
