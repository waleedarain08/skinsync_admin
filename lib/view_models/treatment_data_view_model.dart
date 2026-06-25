import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/view_models/area_view_model.dart';

import '../models/responses/area_list_response.dart';
import '../models/treatment_data_models.dart';

final treatmentDataViewModelProvider =
    NotifierProvider<TreatmentDataViewModel, TreatmentDataState>(
      TreatmentDataViewModel.new,
    );

class TreatmentDataState {
  final List<AreaModel> areas;
  final List<ProtocolItem> protocols;

  TreatmentDataState({required this.areas, this.protocols = const []});

  TreatmentDataState copyWith({
    List<AreaModel>? areas,
    List<ProtocolItem>? protocols,
  }) {
    return TreatmentDataState(
      areas: areas ?? this.areas,
      protocols: protocols ?? this.protocols,
    );
  }
}

class TreatmentDataViewModel extends Notifier<TreatmentDataState> {
  @override
  TreatmentDataState build() {
    // final areas = [
    //   AreaModel(
    //     name: 'Face',
    //     globalSku: 'FACE-1000',
    //     subAreas: [
    //       SubAreaItem(
    //         name: 'Upper Face',
    //         globalSku: 'FACE-1100',
    //         children: [
    //           SubAreaChildItem(name: 'Forehead', globalSku: 'FACE-1110'),
    //           SubAreaChildItem(name: 'Glabella', globalSku: 'FACE-1120'),
    //         ],
    //       ),
    //       SubAreaItem(
    //         name: 'Mid Face',
    //         globalSku: 'FACE-1200',
    //         children: [
    //           SubAreaChildItem(name: 'Cheeks', globalSku: 'FACE-1210'),
    //           SubAreaChildItem(name: 'Under Eyes', globalSku: 'FACE-1220'),
    //         ],
    //       ),
    //       SubAreaItem(
    //         name: 'Forehead',
    //         globalSku: 'FORE-5000',
    //         children: [
    //           SubAreaChildItem(name: 'Left Forehead', globalSku: 'FORE-5100'),
    //           SubAreaChildItem(name: 'Right Forehead', globalSku: 'FORE-5200'),
    //           SubAreaChildItem(
    //             name: 'Central Forehead',
    //             globalSku: 'FORE-5300',
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    //   AreaModel(
    //     name: 'Neck',
    //     globalSku: 'NECK-2000',
    //     subAreas: [
    //       SubAreaItem(name: 'Full Neck', globalSku: 'NECK-2100'),
    //       SubAreaItem(name: 'Neck Bands', globalSku: 'NECK-2200'),
    //     ],
    //   ),
    // ];

    return TreatmentDataState(
      areas: [],
      protocols: [
        ProtocolItem(
          id: '1',
          title: 'Cleanse treatment area',
          type: ProtocolType.checkbox,
          descriptions: [
            ProtocolDescription(
              title: 'Step 1',
              text: 'Cleanse the skin surface with antiseptic agent.',
              order: 1,
            ),
            ProtocolDescription(
              title: 'Step 2',
              text: 'Pat dry with sterile gauze.',
              order: 2,
            ),
          ],
        ),
        ProtocolItem(
          id: '2',
          title: 'Review contraindications',
          type: ProtocolType.checkbox,
          descriptions: [
            ProtocolDescription(
              title: 'Allergies',
              text: 'Confirm patient has no lidocaine or product allergies.',
              order: 1,
            ),
            ProtocolDescription(
              title: 'Pregnancy',
              text: 'Verify patient is not pregnant or breastfeeding.',
              order: 2,
            ),
          ],
        ),
        ProtocolItem(
          id: '3',
          title: 'Mark injection sites',
          type: ProtocolType.checkbox,
          descriptions: [
            ProtocolDescription(
              title: 'Mapping',
              text:
                  'Use surgical marker to outline the target injection points.',
              order: 1,
            ),
          ],
        ),
        ProtocolItem(
          id: '4',
          title: 'Pre-Treatment Instructions',
          type: ProtocolType.text,
          descriptions: [
            ProtocolDescription(
              title: 'Pre Care',
              text:
                  'Avoid blood thinners and alcohol 24 hours before treatment.',
              order: 1,
            ),
          ],
        ),
        ProtocolItem(
          id: '5',
          title: 'Post-Treatment Notes',
          type: ProtocolType.text,
          descriptions: [
            ProtocolDescription(
              title: 'Aftercare',
              text: 'Apply cold compress to reduce swelling.',
              order: 1,
            ),
            ProtocolDescription(
              title: 'Restrictions',
              text: 'Do not touch or massage treated areas for 6 hours.',
              order: 2,
            ),
          ],
        ),
        ProtocolItem(
          id: '6',
          title: 'Recovery Instructions',
          type: ProtocolType.text,
          descriptions: [
            ProtocolDescription(
              title: 'Follow-up',
              text: 'Contact clinic if redness persists past 72 hours.',
              order: 1,
            ),
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

  // --- Area Actions ---
  bool validateAreaSku(String sku) {
    final regex = RegExp(r'^[A-Z]{4}-[0-9]{4}$');
    return regex.hasMatch(sku);
  }

  bool isAreaSkuUnique(String sku) {
    for (final a in state.areas) {
      if (a.globalSku == sku) return false;
      for (final s in a.subAreas) {
        if (s.globalSku == sku) return false;
        for (final c in s.subAreas) {
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
      final letters = String.fromCharCodes(
        Iterable.generate(
          4,
          (_) => chars.codeUnitAt(rand.nextInt(chars.length)),
        ),
      );
      final digits = String.fromCharCodes(
        Iterable.generate(4, (_) => '0123456789'.codeUnitAt(rand.nextInt(10))),
      );
      generated = '$letters-$digits';
    } while (!isAreaSkuUnique(generated));
    return generated;
  }

  Future<void> addArea(String name, {String? sku, required String icon}) async {
    if (name.isEmpty) return;
    final finalSku = (sku == null || sku.isEmpty)
        ? _generateUniqueAreaSku()
        : sku;
    final newArea = await ref
        .read(areaViewModelProvider.notifier)
        .createArea(name: name, globalSku: finalSku, icon: icon);
    state = state.copyWith(areas: [...state.areas, ?newArea]);
  }

  void editArea(String oldName, String newName, {String? sku, String? icon}) {
    state = state.copyWith(
      areas: state.areas.map((a) {
        if (a.name == oldName) {
          final finalSku = (sku == null || sku.isEmpty)
              ? (a.globalSku.isEmpty ? _generateUniqueAreaSku() : a.globalSku)
              : sku;
          return a.copyWith(
            name: newName,
            globalSku: finalSku,
            icon: icon ?? a.icon,
          );
        }
        return a;
      }).toList(),
    );
  }

  void deleteArea(String name) {
    state = state.copyWith(
      areas: state.areas.where((a) => a.name != name).toList(),
    );
  }

  Future<void> addSubArea({
    required int parentAreaId,
    required String parentAreaName,
    required String name,
    String? sku,
    String? icon,
  }) async {
   final value =  await ref
        .read(areaViewModelProvider.notifier)
        .createSubArea(
      name: name,
      globalSku: sku!,
      icon: icon!,
      parentId:parentAreaId,
    );

    if (value == true) {
    await  ref
          .read(areaViewModelProvider.notifier)
          .refreshAreas();
    }
  }

  void editSubArea(
    String areaName,
    String oldName,
    String newName, {
    String? sku,
    String? icon,
  }) {
    state = state.copyWith(
      areas: state.areas.map((a) {
        if (a.name == areaName) {
          return a.copyWith(
            subAreas: a.subAreas.map((s) {
              if (s.name == oldName) {
                final finalSku = (sku == null || sku.isEmpty)
                    ? (s.globalSku.isEmpty
                          ? _generateUniqueAreaSku()
                          : s.globalSku)
                    : sku;
                return s.copyWith(
                  name: newName,
                  globalSku: finalSku,
                  icon: icon ?? s.icon,
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

  void deleteSubArea(String areaName, String name) {
    state = state.copyWith(
      areas: state.areas.map((a) {
        if (a.name == areaName) {
          return a.copyWith(
            subAreas: a.subAreas.where((s) => s.name != name).toList(),
          );
        }
        return a;
      }).toList(),
    );
  }

  void addSubAreaChild(
    String areaName,
    String subAreaName,
    String name, {
    String? sku,
    String? icon,
  }) {
    // final finalSku = (sku == null || sku.isEmpty)
    //     ? _generateUniqueAreaSku()
    //     : sku;
    // state = state.copyWith(
    //   areas: state.areas.map((a) {
    //     if (a.name == areaName) {
    //       return a.copyWith(
    //         subAreas: a.subAreas.map((s) {
    //           if (s.name == subAreaName) {
    //             return s.copyWith(
    //               subAreas: [
    //                 ...s.subAreas,
    //                 AreaModel(
    //                   id: 0,
    //                   name: name,
    //                   globalSku: finalSku,
    //                   icon: icon,
    //                 ),
    //               ],
    //             );
    //           }
    //           return s;
    //         }).toList(),
    //       );
    //     }
    //     return a;
    //   }).toList(),
    // );
  }

  void editSubAreaChild(
    String areaName,
    String subAreaName,
    String oldName,
    String newName, {
    String? sku,
    String? icon,
  }) {
    state = state.copyWith(
      areas: state.areas.map((a) {
        if (a.name == areaName) {
          return a.copyWith(
            subAreas: a.subAreas.map((s) {
              if (s.name == subAreaName) {
                return s.copyWith(
                  subAreas: s.subAreas.map((c) {
                    if (c.name == oldName) {
                      final finalSku = (sku == null || sku.isEmpty)
                          ? (c.globalSku.isEmpty
                                ? _generateUniqueAreaSku()
                                : c.globalSku)
                          : sku;
                      return c.copyWith(
                        name: newName,
                        globalSku: finalSku,
                        icon: icon ?? c.icon,
                      );
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
                return s.copyWith(
                  subAreas: s.subAreas.where((c) => c.name != name).toList(),
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

  void setAreasFromBackend(List<AreaModel> apiAreas) {
    state = state.copyWith(areas: apiAreas);
  }
}
