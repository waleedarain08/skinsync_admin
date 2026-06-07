
class CategoryItem {
  final String id;
  final String name;
  final String? icon;
  final String? parentId;
  final List<CategoryItem> children;
  final int sortOrder;
  final String? consentFormUrl;
  final String? consentFormName;

  CategoryItem({
    required this.id,
    required this.name,
    this.icon,
    this.parentId,
    this.children = const [],
    this.sortOrder = 0,
    this.consentFormUrl,
    this.consentFormName,
  });

  CategoryItem copyWith({
    String? id,
    String? name,
    String? icon,
    String? parentId,
    List<CategoryItem>? children,
    int? sortOrder,
    String? consentFormUrl,
    String? consentFormName,
  }) {
    return CategoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      parentId: parentId ?? this.parentId,
      children: children ?? this.children,
      sortOrder: sortOrder ?? this.sortOrder,
      consentFormUrl: consentFormUrl ?? this.consentFormUrl,
      consentFormName: consentFormName ?? this.consentFormName,
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

enum ProtocolType {
  checkbox,
  text,
}

class ProtocolItem {
  final String id;
  final String title;
  final ProtocolType type;

  ProtocolItem({
    required this.id,
    required this.title,
    required this.type,
  });

  ProtocolItem copyWith({
    String? id,
    String? title,
    ProtocolType? type,
  }) {
    return ProtocolItem(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
    );
  }
}
