import 'dart:convert';

import 'package:skinsync_admin/models/sessions_model.dart';

import '../common_models.dart';
import 'base_response_model.dart';
import '../notification_model.dart';

class CategoryDetailResponse extends BaseApiResponseModel<CategoryDetailDto> {
  const CategoryDetailResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory CategoryDetailResponse.fromJson(Map<String, dynamic> json) =>
      CategoryDetailResponse(
        isSuccess: json['is_success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] == null
            ? null
            : CategoryDetailDto.fromJson(json['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'is_success': isSuccess,
        'message': message,
        'data': data?.toJson(),
      };
}

class CategoryDetailDto {
  final int? id;
  final String? name;
  final String? icon;
  final String? image;
  final int? parentId;
  final int? totalSessions;
  final String? consentFormUrl;
  final String? consentFormName;
  final List<SessionsModel>? defaultSessions;
  final List<NotificationModel>? preNotifications;
  final List<NotificationModel>? postNotifications;
  final DowntimePresets? downtimePresets;
  final List<DefaultRole>? defaultRoles;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<CategoryDetailDto>? subCategories;

  CategoryDetailDto({
    this.id,
    this.name,
    this.icon,
    this.image,
    this.parentId,
    this.totalSessions,
    this.consentFormUrl,
    this.consentFormName,
    this.defaultSessions,
    this.preNotifications,
    this.postNotifications,
    this.downtimePresets,
    this.defaultRoles,
    this.createdAt,
    this.updatedAt,
    this.subCategories,
  });

  factory CategoryDetailDto.fromRawJson(String str) =>
      CategoryDetailDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoryDetailDto.fromJson(Map<String, dynamic> json) => CategoryDetailDto(
    id: json["id"],
    name: json["name"],
    icon: json["icon"],
    image: json["image"],
    parentId: json["parent_id"],
    totalSessions: json["total_sessions"],
    consentFormUrl: json["consent_form_url"],
    consentFormName: json["consent_form_name"],
    defaultSessions: json["default_sessions"] == null
        ? null
        : List<SessionsModel>.from(
            json["default_sessions"].map((x) => SessionsModel.fromJson(x))),
    preNotifications: json["pre_notifications"] == null
        ? null
        : List<NotificationModel>.from(
            json["pre_notifications"].map((x) => NotificationModel.fromJson(x))),
    postNotifications: json["post_notifications"] == null
        ? null
        : List<NotificationModel>.from(
            json["post_notifications"].map((x) => NotificationModel.fromJson(x))),
    downtimePresets: json["downtime_presets"] == null
        ? null
        : DowntimePresets.fromJson(json["downtime_presets"]),
    defaultRoles: json["default_roles"] == null
        ? null
        : List<DefaultRole>.from(
            json["default_roles"].map((x) => defaultRoleValues.map[x]!)),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    subCategories: json["sub_categories"] == null
        ? null
        : List<CategoryDetailDto>.from(
            json["sub_categories"].map((x) => CategoryDetailDto.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon": icon,
    "image": image,
    "parent_id": parentId,
    "total_sessions": totalSessions,
    "consent_form_url": consentFormUrl,
    "consent_form_name": consentFormName,
    "default_sessions": defaultSessions == null
        ? null
        : List<dynamic>.from(defaultSessions!.map((x) => x.toJson())),
    "pre_notifications": preNotifications == null
        ? null
        : List<dynamic>.from(preNotifications!.map((x) => x.toJson())),
    "post_notifications": postNotifications == null
        ? null
        : List<dynamic>.from(postNotifications!.map((x) => x.toJson())),
    "downtime_presets": downtimePresets?.toJson(),
    "default_roles": defaultRoles == null
        ? null
        : List<dynamic>.from(defaultRoles!.map((x) => defaultRoleValues.reverse[x])),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "sub_categories": subCategories == null
        ? null
        : List<dynamic>.from(subCategories!.map((x) => x.toJson())),
  };
}

enum DefaultRole {
  AESTHETICIAN,
  INJECTOR,
  MD,
  SPECIALIST,
  NURSE
}

final defaultRoleValues = EnumValues({
  "Aesthetician": DefaultRole.AESTHETICIAN,
  "Injector": DefaultRole.INJECTOR,
  "MD": DefaultRole.MD,
  "Specialist": DefaultRole.SPECIALIST,
  "Nurse": DefaultRole.NURSE
});



enum Unit {
  HOURS,
  MINUTES
}

final unitValues = EnumValues({
  "hours": Unit.HOURS,
  "minutes": Unit.MINUTES
});



enum Type {
  CARE,
  INSTRUCTION
}

final typeValues = EnumValues({
  "care": Type.CARE,
  "instruction": Type.INSTRUCTION
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}