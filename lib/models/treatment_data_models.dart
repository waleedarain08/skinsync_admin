

class CategoryItem {
  final String name;
  final String? icon;
  final List<SubcategoryItem> subcategories;

  CategoryItem({
    required this.name,
    this.icon,
    this.subcategories = const [],
  });

  CategoryItem copyWith({
    String? name,
    String? icon,
    List<SubcategoryItem>? subcategories,
  }) {
    return CategoryItem(
      name: name ?? this.name,
      icon: icon ?? this.icon,
      subcategories: subcategories ?? this.subcategories,
    );
  }
}

class SubcategoryItem {
  final String name;
  final String? icon;

  SubcategoryItem({required this.name, this.icon});

  SubcategoryItem copyWith({String? name, String? icon}) {
    return SubcategoryItem(
      name: name ?? this.name,
      icon: icon ?? this.icon,
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
