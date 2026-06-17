import 'base_response_model.dart';
import 'category_list_response.dart';

class CategoryDetailResponse extends BaseApiResponseModel<CategoryDetailDto> {
  const CategoryDetailResponse({
    required super.status,
    required super.message,
    super.data,
  });

  factory CategoryDetailResponse.fromJson(Map<String, dynamic> json) =>
      CategoryDetailResponse(
        status: json['status'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] == null
            ? null
            : CategoryDetailDto.fromJson(json['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}

class CategoryDetailDto {
  final int id;
  final String name;
  final String icon;
  final int? parentId;
  final int totalSessions;
  final String? consentFormUrl;
  final String? consentFormName;
  final List<CategorySessionDto> defaultSessions;
  final List<CategoryNotificationDto> preNotifications;
  final List<CategoryNotificationDto> postNotifications;
  final CategoryDowntimePresetDto downtimePresets;
  final List<String> defaultRoles;
  final List<CategoryDetailDto> subCategories;

  CategoryDetailDto({
    required this.id,
    required this.name,
    required this.icon,
    this.parentId,
    this.totalSessions = 1,
    this.consentFormUrl,
    this.consentFormName,
    this.defaultSessions = const [],
    this.preNotifications = const [],
    this.postNotifications = const [],
    required this.downtimePresets,
    this.defaultRoles = const [],
    this.subCategories = const [],
  });

  factory CategoryDetailDto.fromJson(Map<String, dynamic> json) {
    return CategoryDetailDto(
      id: json['id'] as int,
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      parentId: json['parent_id'] as int?,
      totalSessions: json['total_sessions'] ?? 1,
      consentFormUrl: json['consent_form_url'],
      consentFormName: json['consent_form_name'],
      defaultSessions: (json['default_sessions'] as List?)
              ?.map((e) => CategorySessionDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      preNotifications: (json['pre_notifications'] as List?)
              ?.map((e) => CategoryNotificationDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      postNotifications: (json['post_notifications'] as List?)
              ?.map((e) => CategoryNotificationDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      downtimePresets: json['downtime_presets'] != null
          ? CategoryDowntimePresetDto.fromJson(json['downtime_presets'] as Map<String, dynamic>)
          : CategoryDowntimePresetDto(),
      defaultRoles: (json['default_roles'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      subCategories: (json['sub_categories'] as List?)
              ?.map((e) => CategoryDetailDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'parent_id': parentId,
      'total_sessions': totalSessions,
      'consent_form_url': consentFormUrl,
      'consent_form_name': consentFormName,
      'default_sessions': defaultSessions.map((e) => e.toJson()).toList(),
      'pre_notifications': preNotifications.map((e) => e.toJson()).toList(),
      'post_notifications': postNotifications.map((e) => e.toJson()).toList(),
      'downtime_presets': downtimePresets.toJson(),
      'default_roles': defaultRoles,
      'sub_categories': subCategories.map((e) => e.toJson()).toList(),
    };
  }

  CategoryModel toCategoryModel() {
    return CategoryModel(
      id: id,
      name: name,
      icon: icon,
      parentId: parentId,
      totalSessions: totalSessions,
      consentFormUrl: consentFormUrl,
      consentFormName: consentFormName,
      defaultSessions: defaultSessions.map((s) => s.toCategorySessionModel()).toList(),
      preNotifications: preNotifications.map((n) => n.toCategoryNotificationModel()).toList(),
      postNotifications: postNotifications.map((n) => n.toCategoryNotificationModel()).toList(),
      downtimePresets: downtimePresets.toCategoryDowntimePresetModel(),
      defaultRoles: defaultRoles,
      subCategories: subCategories.map((s) => s.toCategoryModel()).toList(),
    );
  }
}

class CategorySessionDto {
  final int sessionNumber;
  final List<CategoryFollowUpDto> followUps;

  CategorySessionDto({
    required this.sessionNumber,
    this.followUps = const [],
  });

  factory CategorySessionDto.fromJson(Map<String, dynamic> json) {
    return CategorySessionDto(
      sessionNumber: json['session_number'] ?? 1,
      followUps: (json['follow_ups'] as List?)
              ?.map((e) => CategoryFollowUpDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_number': sessionNumber,
      'follow_ups': followUps.map((e) => e.toJson()).toList(),
    };
  }

  CategorySessionModel toCategorySessionModel() {
    return CategorySessionModel(
      sessionNumber: sessionNumber,
      followUps: followUps.map((f) => f.toCategoryFollowUpModel()).toList(),
    );
  }
}

class CategoryFollowUpDto {
  final String type;
  final int? durationValue;
  final String durationUnit;
  final int? intervalValue;
  final String? intervalUnit;
  final bool isImageRequired;
  final String? notes;

  CategoryFollowUpDto({
    required this.type,
    this.durationValue,
    this.durationUnit = 'minutes',
    this.intervalValue,
    this.intervalUnit = 'days',
    this.isImageRequired = false,
    this.notes,
  });

  factory CategoryFollowUpDto.fromJson(Map<String, dynamic> json) {
    return CategoryFollowUpDto(
      type: json['type'] ?? 'virtual',
      durationValue: json['duration_value'] as int?,
      durationUnit: json['duration_unit'] ?? 'minutes',
      intervalValue: json['interval_value'] as int?,
      intervalUnit: json['interval_unit'],
      isImageRequired: json['is_image_required'] ?? false,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'duration_value': durationValue,
      'duration_unit': durationUnit,
      'interval_value': intervalValue,
      'interval_unit': intervalUnit,
      'is_image_required': isImageRequired,
      'notes': notes,
    };
  }

  CategoryFollowUpModel toCategoryFollowUpModel() {
    return CategoryFollowUpModel(
      type: type,
      durationValue: durationValue,
      durationUnit: durationUnit,
      intervalValue: intervalValue,
      intervalUnit: intervalUnit,
      isImageRequired: isImageRequired,
      notes: notes,
    );
  }
}

class CategoryNotificationDto {
  final String? title;
  final String? message;
  final int? timing;
  final String? timingUnit;
  final String? type;

  CategoryNotificationDto({
    this.title,
    this.message,
    this.timing,
    this.timingUnit,
    this.type,
  });

  factory CategoryNotificationDto.fromJson(Map<String, dynamic> json) {
    return CategoryNotificationDto(
      title: json['title'],
      message: json['message'],
      timing: json['timing'] as int?,
      timingUnit: json['timing_unit'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
      'timing': timing,
      'timing_unit': timingUnit,
      'type': type,
    };
  }

  CategoryNotificationModel toCategoryNotificationModel() {
    return CategoryNotificationModel(
      title: title,
      message: message,
      timing: timing,
      timingUnit: timingUnit,
      type: type,
    );
  }
}

class CategoryDowntimePresetDto {
  final int high;
  final int moderate;
  final int low;
  final int none;

  CategoryDowntimePresetDto({
    this.high = 10,
    this.moderate = 5,
    this.low = 2,
    this.none = 0,
  });

  factory CategoryDowntimePresetDto.fromJson(Map<String, dynamic> json) {
    return CategoryDowntimePresetDto(
      high: json['high'] ?? 10,
      moderate: json['moderate'] ?? 5,
      low: json['low'] ?? 2,
      none: json['none'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'high': high,
      'moderate': moderate,
      'low': low,
      'none': none,
    };
  }

  CategoryDowntimePresetModel toCategoryDowntimePresetModel() {
    return CategoryDowntimePresetModel(
      high: high,
      moderate: moderate,
      low: low,
      none: none,
    );
  }
}
