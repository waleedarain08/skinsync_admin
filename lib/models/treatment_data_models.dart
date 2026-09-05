export 'common_models.dart';
export 'responses/category_list_response.dart';
export 'treatment_model.dart';

// class SubAreaChildItem {
//   final String name;
//   final String globalSku;
//   final String? icon;
//
//   SubAreaChildItem({required this.name, required this.globalSku, this.icon});
//
//   SubAreaChildItem copyWith({String? name, String? globalSku, String? icon}) {
//     return SubAreaChildItem(
//       name: name ?? this.name,
//       globalSku: globalSku ?? this.globalSku,
//       icon: icon ?? this.icon,
//     );
//   }
// }

// class SubAreaItem {
//   final String name;
//   final String globalSku;
//   final String? icon;
//   final List<SubAreaChildItem> children;
//
//   SubAreaItem({
//     required this.name,
//     required this.globalSku,
//     this.icon,
//     this.children = const [],
//   });
//
//   SubAreaItem copyWith({
//     String? name,
//     String? globalSku,
//     String? icon,
//     List<SubAreaChildItem>? children,
//   }) {
//     return SubAreaItem(
//       name: name ?? this.name,
//       globalSku: globalSku ?? this.globalSku,
//       icon: icon ?? this.icon,
//       children: children ?? this.children,
//     );
//   }
// }

// class AreaItem {
//   final int id;
//   final String name;
//   final String globalSku;
//   final String? icon;
//   final List<AreaItem> subAreas;
//
//   const AreaItem({
//     required this.id,
//     required this.name,
//     required this.globalSku,
//     this.icon,
//     this.subAreas = const [],
//   });
//
//   AreaItem copyWith({
//     int? id,
//     String? name,
//     String? globalSku,
//     String? icon,
//     List<AreaItem>? subAreas,
//   }) {
//     return AreaItem(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       globalSku: globalSku ?? this.globalSku,
//       icon: icon ?? this.icon,
//       subAreas: subAreas ?? this.subAreas,
//     );
//   }
//
//   factory AreaItem.fromJson(Map<String, dynamic> json) {
//     return AreaItem(
//       id: json['id'] ?? 0,
//       name: json['name'] ?? '',
//       globalSku: json['globalSku'] ?? '',
//       icon: json['icon'],
//       subAreas: (json['subAreas'] as List?)
//               ?.map((e) => AreaItem.fromJson(e))
//               .toList() ??
//           [],
//     );
//   }
// }

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
  checkbox('checkbox'),
  textField('textField'),
  text('text');

  final String value;
  const ProtocolType(this.value);

  bool get isTextField =>
      this == ProtocolType.textField || this == ProtocolType.text;
  bool get isCheckbox => this == ProtocolType.checkbox;

  static ProtocolType fromString(String? type) {
    final lower = type?.toString().toLowerCase() ?? '';
    if (lower == 'textfield' || lower == 'text') {
      return ProtocolType.textField;
    }
    return ProtocolType.checkbox;
  }
}

class ProtocolDescription {
  final String? title;
  final String text;
  final int order;

  ProtocolDescription({this.title, required this.text, required this.order});

  factory ProtocolDescription.fromJson(Map<String, dynamic> json) =>
      ProtocolDescription(
        title: json['title'],
        text: json['text'] ?? '',
        order: json['order'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
    'title': title,
    'text': text,
    'order': order,
  };

  ProtocolDescription copyWith({String? title, String? text, int? order}) {
    return ProtocolDescription(
      title: title ?? this.title,
      text: text ?? this.text,
      order: order ?? this.order,
    );
  }
}

class ProtocolItem {
  final String id;
  final String title;
  final ProtocolType type;
  final String? status;
  final String? createdAt;
  final List<ProtocolDescription> descriptions;

  ProtocolItem({
    required this.id,
    required this.title,
    required this.type,
    this.status,
    this.createdAt,
    this.descriptions = const [],
  });

  ProtocolItem copyWith({
    String? id,
    String? title,
    ProtocolType? type,
    String? status,
    String? createdAt,
    List<ProtocolDescription>? descriptions,
  }) {
    return ProtocolItem(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      descriptions: descriptions ?? this.descriptions,
    );
  }

  factory ProtocolItem.fromJson(Map<String, dynamic> json) {
    List<ProtocolDescription> descs = [];
    if (json['descriptions'] != null) {
      descs = (json['descriptions'] as List)
          .map((e) => ProtocolDescription.fromJson(e))
          .toList();
    } else if (json['description'] != null &&
        (json['description'] as String).isNotEmpty) {
      descs = [
        ProtocolDescription(
          title: 'Description 1',
          text: json['description'],
          order: 1,
        ),
      ];
    }
    return ProtocolItem(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      type: ProtocolType.fromString(json['type']?.toString()),
      status: json['status']?.toString(),
      createdAt: json['created_at']?.toString(),
      descriptions: descs,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'type': type.value,
    'status': status,
    'created_at': createdAt,
    'descriptions': descriptions.map((e) => e.toJson()).toList(),
  };
}
