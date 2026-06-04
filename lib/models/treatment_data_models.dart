
class CategoryItem {
  final String id;
  final String name;
  final String? icon;
  final String? parentId;
  final List<CategoryItem> children;
  final int sortOrder;

  CategoryItem({
    required this.id,
    required this.name,
    this.icon,
    this.parentId,
    this.children = const [],
    this.sortOrder = 0,
  });

  CategoryItem copyWith({
    String? id,
    String? name,
    String? icon,
    String? parentId,
    List<CategoryItem>? children,
    int? sortOrder,
  }) {
    return CategoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      parentId: parentId ?? this.parentId,
      children: children ?? this.children,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

class AreaItem {
  final String name;
  final String? icon;
  final List<SubAreaItem> subAreas;

  AreaItem({
    required this.name,
    this.icon,
    this.subAreas = const [],
  });

  AreaItem copyWith({
    String? name,
    String? icon,
    List<SubAreaItem>? subAreas,
  }) {
    return AreaItem(
      name: name ?? this.name,
      icon: icon ?? this.icon,
      subAreas: subAreas ?? this.subAreas,
    );
  }
}

class SubAreaItem {
  final String name;
  final String? icon;

  SubAreaItem({required this.name, this.icon});

  SubAreaItem copyWith({String? name, String? icon}) {
    return SubAreaItem(
      name: name ?? this.name,
      icon: icon ?? this.icon,
    );
  }
}

class CombinationGroup {
  final String id;
  final String name;
  final List<String> treatmentNames;

  CombinationGroup({
    required this.id,
    required this.name,
    this.treatmentNames = const [],
  });

  CombinationGroup copyWith({
    String? id,
    String? name,
    List<String>? treatmentNames,
  }) {
    return CombinationGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      treatmentNames: treatmentNames ?? this.treatmentNames,
    );
  }
}

class ProtocolItem {
  final String id;
  final String name;

  ProtocolItem({required this.id, required this.name});

  ProtocolItem copyWith({String? id, String? name}) {
    return ProtocolItem(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
