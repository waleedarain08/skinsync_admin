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
  final List<ProtocolItem> protocols;

  TreatmentDataState({
    required this.categories,
    required this.areas,
    required this.materials,
    this.combinationGroups = const [],
    this.protocols = const [],
  });

  TreatmentDataState copyWith({
    List<CategoryItem>? categories,
    List<AreaItem>? areas,
    List<String>? materials,
    List<CombinationGroup>? combinationGroups,
    List<ProtocolItem>? protocols,
  }) {
    return TreatmentDataState(
      categories: categories ?? this.categories,
      areas: areas ?? this.areas,
      materials: materials ?? this.materials,
      combinationGroups: combinationGroups ?? this.combinationGroups,
      protocols: protocols ?? this.protocols,
    );
  }
}

class TreatmentDataViewModel extends Notifier<TreatmentDataState> {
  @override
  TreatmentDataState build() {
    // Initializing with hierarchical data based on dummy data
    int idCounter = 1;
    final List<CategoryItem> categories = [];

    TreatmentData.categoriesWithSubcategories.forEach((parentName, subList) {
      final parentId = (idCounter++).toString();
      final children = subList.map((subName) {
        return CategoryItem(
          id: (idCounter++).toString(),
          name: subName,
          parentId: parentId,
        );
      }).toList();

      categories.add(CategoryItem(
        id: parentId,
        name: parentName,
        children: children,
      ));
    });

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
      protocols: [
        ProtocolItem(id: '1', title: 'Cleanse treatment area', type: ProtocolType.checkbox),
        ProtocolItem(id: '2', title: 'Review contraindications', type: ProtocolType.checkbox),
        ProtocolItem(id: '3', title: 'Mark injection sites', type: ProtocolType.checkbox),
        ProtocolItem(id: '4', title: 'Pre-Treatment Instructions', type: ProtocolType.text),
        ProtocolItem(id: '5', title: 'Post-Treatment Notes', type: ProtocolType.text),
        ProtocolItem(id: '6', title: 'Recovery Instructions', type: ProtocolType.text),
      ],
    );
  }

  // --- Protocol Actions ---

  void addProtocol(String title, ProtocolType type) {
    if (title.isEmpty) return;
    final newProtocol = ProtocolItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      type: type,
    );
    state = state.copyWith(protocols: [...state.protocols, newProtocol]);
  }

  // --- Category Actions (Supports Unlimited Nesting) ---

  void addCategory(String name, {String? icon, String? parentId}) {
    if (name.isEmpty) return;
    final newCategory = CategoryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      icon: icon,
      parentId: parentId,
    );

    if (parentId == null) {
      state = state.copyWith(categories: [...state.categories, newCategory]);
    } else {
      state = state.copyWith(
        categories: _addChildToTree(state.categories, parentId, newCategory),
      );
    }
  }

  List<CategoryItem> _addChildToTree(List<CategoryItem> items, String parentId, CategoryItem newChild) {
    return items.map((item) {
      if (item.id == parentId) {
        return item.copyWith(children: [...item.children, newChild]);
      } else if (item.children.isNotEmpty) {
        return item.copyWith(children: _addChildToTree(item.children, parentId, newChild));
      }
      return item;
    }).toList();
  }

  void editCategory(String id, String newName, {String? icon}) {
    state = state.copyWith(
      categories: _updateInTree(state.categories, id, newName, icon),
    );
  }

  List<CategoryItem> _updateInTree(List<CategoryItem> items, String id, String newName, String? icon) {
    return items.map((item) {
      if (item.id == id) {
        return item.copyWith(name: newName, icon: icon ?? item.icon);
      } else if (item.children.isNotEmpty) {
        return item.copyWith(children: _updateInTree(item.children, id, newName, icon));
      }
      return item;
    }).toList();
  }

  void deleteCategory(String id) {
    state = state.copyWith(
      categories: _removeFromTree(state.categories, id),
    );
  }

  List<CategoryItem> _removeFromTree(List<CategoryItem> items, String id) {
    // Remove if matches ID at this level
    final filtered = items.where((item) => item.id != id).toList();
    // Recursively remove from children
    return filtered.map((item) {
      if (item.children.isNotEmpty) {
        return item.copyWith(children: _removeFromTree(item.children, id));
      }
      return item;
    }).toList();
  }

  // Legacy support for Subcategory (mapping to the tree logic)
  void addSubcategory(String parentId, String name, {String? icon}) {
    addCategory(name, icon: icon, parentId: parentId);
  }

  void editSubcategory(String parentId, String id, String newName, {String? icon}) {
    editCategory(id, newName, icon: icon);
  }

  void deleteSubcategory(String parentId, String id) {
    deleteCategory(id);
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
