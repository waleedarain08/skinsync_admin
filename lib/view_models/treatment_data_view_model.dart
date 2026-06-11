import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/treatment_data_models.dart';
import '../utils/dummy_data.dart';

final treatmentDataViewModelProvider = NotifierProvider<TreatmentDataViewModel, TreatmentDataState>(
  () => TreatmentDataViewModel(),
);

class TreatmentDataState {
  final List<CategoryItem> categories;
  final List<AreaItem> areas;
  final List<ProtocolItem> protocols;

  TreatmentDataState({
    required this.categories,
    required this.areas,
    this.protocols = const [],
  });

  TreatmentDataState copyWith({
    List<CategoryItem>? categories,
    List<AreaItem>? areas,
    List<ProtocolItem>? protocols,
  }) {
    return TreatmentDataState(
      categories: categories ?? this.categories,
      areas: areas ?? this.areas,
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

    final areas = [
      AreaItem(
        name: "Face",
        globalSku: "FACE-1000",
        subAreas: [
          SubAreaItem(
            name: "Upper Face",
            globalSku: "FACE-1100",
            children: [
              SubAreaChildItem(name: "Forehead", globalSku: "FACE-1110"),
              SubAreaChildItem(name: "Glabella", globalSku: "FACE-1120"),
            ],
          ),
          SubAreaItem(
            name: "Mid Face",
            globalSku: "FACE-1200",
            children: [
              SubAreaChildItem(name: "Cheeks", globalSku: "FACE-1210"),
              SubAreaChildItem(name: "Under Eyes", globalSku: "FACE-1220"),
            ],
          ),
          SubAreaItem(
            name: "Forehead",
            globalSku: "FORE-5000",
            children: [
              SubAreaChildItem(name: "Left Forehead", globalSku: "FORE-5100"),
              SubAreaChildItem(name: "Right Forehead", globalSku: "FORE-5200"),
              SubAreaChildItem(name: "Central Forehead", globalSku: "FORE-5300"),
            ],
          ),
        ],
      ),
      AreaItem(
        name: "Neck",
        globalSku: "NECK-2000",
        subAreas: [
          SubAreaItem(name: "Full Neck", globalSku: "NECK-2100"),
          SubAreaItem(name: "Neck Bands", globalSku: "NECK-2200"),
        ],
      ),
    ];

    return TreatmentDataState(
      categories: categories,
      areas: areas,
      protocols: [
        ProtocolItem(
          id: '1',
          title: 'Cleanse treatment area',
          type: ProtocolType.checkbox,
          descriptions: [
            ProtocolDescription(title: "Step 1", text: "Cleanse the skin surface with antiseptic agent.", order: 1),
            ProtocolDescription(title: "Step 2", text: "Pat dry with sterile gauze.", order: 2),
          ],
        ),
        ProtocolItem(
          id: '2',
          title: 'Review contraindications',
          type: ProtocolType.checkbox,
          descriptions: [
            ProtocolDescription(title: "Allergies", text: "Confirm patient has no lidocaine or product allergies.", order: 1),
            ProtocolDescription(title: "Pregnancy", text: "Verify patient is not pregnant or breastfeeding.", order: 2),
          ],
        ),
        ProtocolItem(
          id: '3',
          title: 'Mark injection sites',
          type: ProtocolType.checkbox,
          descriptions: [
            ProtocolDescription(title: "Mapping", text: "Use surgical marker to outline the target injection points.", order: 1),
          ],
        ),
        ProtocolItem(
          id: '4',
          title: 'Pre-Treatment Instructions',
          type: ProtocolType.text,
          descriptions: [
            ProtocolDescription(title: "Pre Care", text: "Avoid blood thinners and alcohol 24 hours before treatment.", order: 1),
          ],
        ),
        ProtocolItem(
          id: '5',
          title: 'Post-Treatment Notes',
          type: ProtocolType.text,
          descriptions: [
            ProtocolDescription(title: "Aftercare", text: "Apply cold compress to reduce swelling.", order: 1),
            ProtocolDescription(title: "Restrictions", text: "Do not touch or massage treated areas for 6 hours.", order: 2),
          ],
        ),
        ProtocolItem(
          id: '6',
          title: 'Recovery Instructions',
          type: ProtocolType.text,
          descriptions: [
            ProtocolDescription(title: "Follow-up", text: "Contact clinic if redness persists past 72 hours.", order: 1),
          ],
        ),
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

  void editProtocol(String id, String newTitle) {
    state = state.copyWith(
      protocols: state.protocols.map((p) {
        if (p.id == id) {
          return p.copyWith(title: newTitle);
        }
        return p;
      }).toList(),
    );
  }

  void saveProtocol(ProtocolItem updatedProtocol) {
    state = state.copyWith(
      protocols: state.protocols.map((p) {
        if (p.id == updatedProtocol.id) {
          return updatedProtocol;
        }
        return p;
      }).toList(),
    );
  }

  void deleteProtocol(String id) {
    state = state.copyWith(
      protocols: state.protocols.where((p) => p.id != id).toList(),
    );
  }

  // --- Category Actions (Supports Unlimited Nesting) ---

  void addCategory(
    String name, {
    String? icon,
    String? parentId,
    String? consentFormUrl,
    String? consentFormName,
    List<FollowUpConfig>? defaultFollowUps,
    List<SessionConfig>? defaultSessions,
    int? totalSessions,
    List<NotificationConfig>? preNotifications,
    List<NotificationConfig>? postNotifications,
    DowntimePresets? downtimePresets,
    List<String>? defaultRoles,
  }) {
    if (name.isEmpty) return;
    final newCategory = CategoryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      icon: icon,
      parentId: parentId,
      consentFormUrl: consentFormUrl,
      consentFormName: consentFormName,
      defaultFollowUps: defaultFollowUps,
      defaultSessions: defaultSessions,
      totalSessions: totalSessions ?? 1,
      preNotifications: preNotifications ?? const [],
      postNotifications: postNotifications ?? const [],
      downtimePresets: downtimePresets,
      defaultRoles: defaultRoles ?? [],
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

  void editCategory(
    String id,
    String newName, {
    String? icon,
    String? consentFormUrl,
    String? consentFormName,
    List<FollowUpConfig>? defaultFollowUps,
    List<SessionConfig>? defaultSessions,
    int? totalSessions,
    List<NotificationConfig>? preNotifications,
    List<NotificationConfig>? postNotifications,
    DowntimePresets? downtimePresets,
    List<String>? defaultRoles,
  }) {
    state = state.copyWith(
      categories: _updateInTree(
        state.categories,
        id,
        newName,
        icon,
        consentFormUrl,
        consentFormName,
        defaultFollowUps,
        defaultSessions,
        totalSessions,
        preNotifications,
        postNotifications,
        downtimePresets,
        defaultRoles,
      ),
    );
  }

  List<CategoryItem> _updateInTree(
    List<CategoryItem> items,
    String id,
    String newName,
    String? icon,
    String? consentFormUrl,
    String? consentFormName,
    List<FollowUpConfig>? defaultFollowUps,
    List<SessionConfig>? defaultSessions,
    int? totalSessions,
    List<NotificationConfig>? preNotifications,
    List<NotificationConfig>? postNotifications,
    DowntimePresets? downtimePresets,
    List<String>? defaultRoles,
  ) {
    return items.map((item) {
      if (item.id == id) {
        return item.copyWith(
          name: newName,
          icon: icon ?? item.icon,
          consentFormUrl: consentFormUrl,
          consentFormName: consentFormName,
          defaultFollowUps: defaultFollowUps ?? item.defaultFollowUps,
          defaultSessions: defaultSessions ?? item.defaultSessions,
          totalSessions: totalSessions ?? item.totalSessions,
          preNotifications: preNotifications ?? item.preNotifications,
          postNotifications: postNotifications ?? item.postNotifications,
          downtimePresets: downtimePresets ?? item.downtimePresets,
          defaultRoles: defaultRoles ?? item.defaultRoles,
        );
      } else if (item.children.isNotEmpty) {
        return item.copyWith(
          children: _updateInTree(
            item.children,
            id,
            newName,
            icon,
            consentFormUrl,
            consentFormName,
            defaultFollowUps,
            defaultSessions,
            totalSessions,
            preNotifications,
            postNotifications,
            downtimePresets,
            defaultRoles,
          ),
        );
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
  bool validateAreaSku(String sku) {
    final regex = RegExp(r'^[A-Z]{4}-[0-9]{4}$');
    return regex.hasMatch(sku);
  }

  bool isAreaSkuUnique(String sku) {
    for (var a in state.areas) {
      if (a.globalSku == sku) return false;
      for (var s in a.subAreas) {
        if (s.globalSku == sku) return false;
        for (var c in s.children) {
          if (c.globalSku == sku) return false;
        }
      }
    }
    return true;
  }

  String _generateUniqueAreaSku() {
    final rand = math.Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    String generated;
    do {
      final letters = String.fromCharCodes(Iterable.generate(4, (_) => chars.codeUnitAt(rand.nextInt(chars.length))));
      final digits = String.fromCharCodes(Iterable.generate(4, (_) => '0123456789'.codeUnitAt(rand.nextInt(10))));
      generated = '$letters-$digits';
    } while (!isAreaSkuUnique(generated));
    return generated;
  }

  void addArea(String name, {String? sku, String? icon}) {
    if (name.isEmpty) return;
    final finalSku = (sku == null || sku.isEmpty) ? _generateUniqueAreaSku() : sku;
    state = state.copyWith(
      areas: [...state.areas, AreaItem(name: name, globalSku: finalSku, icon: icon)],
    );
  }

  void editArea(String oldName, String newName, {String? sku, String? icon}) {
    state = state.copyWith(
      areas: state.areas.map((a) {
        if (a.name == oldName) {
          final finalSku = (sku == null || sku.isEmpty) ? (a.globalSku.isEmpty ? _generateUniqueAreaSku() : a.globalSku) : sku;
          return a.copyWith(name: newName, globalSku: finalSku, icon: icon ?? a.icon);
        }
        return a;
      }).toList(),
    );
  }

  void deleteArea(String name) {
    state = state.copyWith(areas: state.areas.where((a) => a.name != name).toList());
  }

  void addSubArea(String areaName, String name, {String? sku, String? icon}) {
    final finalSku = (sku == null || sku.isEmpty) ? _generateUniqueAreaSku() : sku;
    state = state.copyWith(
      areas: state.areas.map((a) {
        if (a.name == areaName) {
          return a.copyWith(subAreas: [...a.subAreas, SubAreaItem(name: name, globalSku: finalSku, icon: icon)]);
        }
        return a;
      }).toList(),
    );
  }

  void editSubArea(String areaName, String oldName, String newName, {String? sku, String? icon}) {
    state = state.copyWith(
      areas: state.areas.map((a) {
        if (a.name == areaName) {
          return a.copyWith(
            subAreas: a.subAreas.map((s) {
              if (s.name == oldName) {
                final finalSku = (sku == null || sku.isEmpty) ? (s.globalSku.isEmpty ? _generateUniqueAreaSku() : s.globalSku) : sku;
                return s.copyWith(name: newName, globalSku: finalSku, icon: icon ?? s.icon);
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

  void addSubAreaChild(String areaName, String subAreaName, String name, {String? sku, String? icon}) {
    final finalSku = (sku == null || sku.isEmpty) ? _generateUniqueAreaSku() : sku;
    state = state.copyWith(
      areas: state.areas.map((a) {
        if (a.name == areaName) {
          return a.copyWith(
            subAreas: a.subAreas.map((s) {
              if (s.name == subAreaName) {
                return s.copyWith(children: [...s.children, SubAreaChildItem(name: name, globalSku: finalSku, icon: icon)]);
              }
              return s;
            }).toList(),
          );
        }
        return a;
      }).toList(),
    );
  }

  void editSubAreaChild(String areaName, String subAreaName, String oldName, String newName, {String? sku, String? icon}) {
    state = state.copyWith(
      areas: state.areas.map((a) {
        if (a.name == areaName) {
          return a.copyWith(
            subAreas: a.subAreas.map((s) {
              if (s.name == subAreaName) {
                return s.copyWith(
                  children: s.children.map((c) {
                    if (c.name == oldName) {
                      final finalSku = (sku == null || sku.isEmpty) ? (c.globalSku.isEmpty ? _generateUniqueAreaSku() : c.globalSku) : sku;
                      return c.copyWith(name: newName, globalSku: finalSku, icon: icon ?? c.icon);
                    }
                    return c;
                  }).toList(),
                );
              }
              return s;
            }).toList(),
          );
        }
        return a;
      }).toList(),
    );
  }

  void deleteSubAreaChild(String areaName, String subAreaName, String name) {
    state = state.copyWith(
      areas: state.areas.map((a) {
        if (a.name == areaName) {
          return a.copyWith(
            subAreas: a.subAreas.map((s) {
              if (s.name == subAreaName) {
                return s.copyWith(children: s.children.where((c) => c.name != name).toList());
              }
              return s;
            }).toList(),
          );
        }
        return a;
      }).toList(),
    );
  }
}
