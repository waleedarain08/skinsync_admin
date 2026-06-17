class CategoryListResponse {
  final bool? status;
  final String? message;
  final List<CategoryModel>? data;

  CategoryListResponse({
    this.status,
    this.message,
    this.data,
  });

  factory CategoryListResponse.fromJson(Map<String, dynamic> json) {
    return CategoryListResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List?)
          ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class CategoryModel {
  final int id;
  final String name;
  final String icon;
  final int? parentId;
  final int totalSessions;
  final String? consentFormUrl;
  final String? consentFormName;
  final List<CategorySessionModel> defaultSessions;
  final List<CategoryNotificationModel> preNotifications;
  final List<CategoryNotificationModel> postNotifications;
  final CategoryDowntimePresetModel downtimePresets;
  final List<String> defaultRoles;
  final List<CategoryModel> subCategories;

  CategoryModel({
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

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      parentId: json['parent_id'] as int?,
      totalSessions: json['total_sessions'] ?? 1,
      consentFormUrl: json['consent_form_url'],
      consentFormName: json['consent_form_name'],
      defaultSessions: (json['default_sessions'] as List?)
              ?.map((e) =>
                  CategorySessionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      preNotifications: (json['pre_notifications'] as List?)
              ?.map((e) =>
                  CategoryNotificationModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      postNotifications: (json['post_notifications'] as List?)
              ?.map((e) =>
                  CategoryNotificationModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      downtimePresets: json['downtime_presets'] != null
          ? CategoryDowntimePresetModel.fromJson(
              json['downtime_presets'] as Map<String, dynamic>)
          : CategoryDowntimePresetModel(),
      defaultRoles: (json['default_roles'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      subCategories: (json['sub_categories'] as List?)
              ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
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
  
  CategoryModel copyWith({
    int? id,
    String? name,
    String? icon,
    int? parentId,
    int? totalSessions,
    String? consentFormUrl,
    String? consentFormName,
    List<CategorySessionModel>? defaultSessions,
    List<CategoryNotificationModel>? preNotifications,
    List<CategoryNotificationModel>? postNotifications,
    CategoryDowntimePresetModel? downtimePresets,
    List<String>? defaultRoles,
    List<CategoryModel>? subCategories,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      parentId: parentId ?? this.parentId,
      totalSessions: totalSessions ?? this.totalSessions,
      consentFormUrl: consentFormUrl ?? this.consentFormUrl,
      consentFormName: consentFormName ?? this.consentFormName,
      defaultSessions: defaultSessions ?? this.defaultSessions,
      preNotifications: preNotifications ?? this.preNotifications,
      postNotifications: postNotifications ?? this.postNotifications,
      downtimePresets: downtimePresets ?? this.downtimePresets,
      defaultRoles: defaultRoles ?? this.defaultRoles,
      subCategories: subCategories ?? this.subCategories,
    );
  }
}

class CategorySessionModel {
  final int sessionNumber;
  final List<CategoryFollowUpModel> followUps;

  CategorySessionModel({
    required this.sessionNumber,
    this.followUps = const [],
  });

  factory CategorySessionModel.fromJson(Map<String, dynamic> json) {
    return CategorySessionModel(
      sessionNumber: json['session_number'] ?? 1,
      followUps: (json['follow_ups'] as List?)
              ?.map((e) =>
                  CategoryFollowUpModel.fromJson(e as Map<String, dynamic>))
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

  CategorySessionModel copyWith({
    int? sessionNumber,
    List<CategoryFollowUpModel>? followUps,
  }) {
    return CategorySessionModel(
      sessionNumber: sessionNumber ?? this.sessionNumber,
      followUps: followUps ?? this.followUps,
    );
  }
}

class CategoryFollowUpModel {
  final String type;
  final int? durationValue;
  final String durationUnit;
  final int? intervalValue;
  final String? intervalUnit;
  final bool isImageRequired;
  final String? notes;

  CategoryFollowUpModel({
    required this.type,
    this.durationValue,
    this.durationUnit = 'minutes',
    this.intervalValue,
    this.intervalUnit = 'days',
    this.isImageRequired = false,
    this.notes,
  });

  factory CategoryFollowUpModel.fromJson(Map<String, dynamic> json) {
    return CategoryFollowUpModel(
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

  CategoryFollowUpModel copyWith({
    String? type,
    int? durationValue,
    String? durationUnit,
    int? intervalValue,
    String? intervalUnit,
    bool? isImageRequired,
    String? notes,
  }) {
    return CategoryFollowUpModel(
      type: type ?? this.type,
      durationValue: durationValue ?? this.durationValue,
      durationUnit: durationUnit ?? this.durationUnit,
      intervalValue: intervalValue ?? this.intervalValue,
      intervalUnit: intervalUnit ?? this.intervalUnit,
      isImageRequired: isImageRequired ?? this.isImageRequired,
      notes: notes ?? this.notes,
    );
  }
}

class CategoryNotificationModel {
  final String? title;
  final String? message;
  final int? timing;
  final String? timingUnit;
  final String? type;

  CategoryNotificationModel({
    this.title,
    this.message,
    this.timing,
    this.timingUnit,
    this.type,
  });

  factory CategoryNotificationModel.fromJson(Map<String, dynamic> json) {
    return CategoryNotificationModel(
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

  CategoryNotificationModel copyWith({
    String? title,
    String? message,
    int? timing,
    String? timingUnit,
    String? type,
  }) {
    return CategoryNotificationModel(
      title: title ?? this.title,
      message: message ?? this.message,
      timing: timing ?? this.timing,
      timingUnit: timingUnit ?? this.timingUnit,
      type: type ?? this.type,
    );
  }
}

class CategoryDowntimePresetModel {
  final int high;
  final int moderate;
  final int low;
  final int none;

  CategoryDowntimePresetModel({
    this.high = 10,
    this.moderate = 5,
    this.low = 2,
    this.none = 0,
  });

  factory CategoryDowntimePresetModel.fromJson(Map<String, dynamic> json) {
    return CategoryDowntimePresetModel(
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

  CategoryDowntimePresetModel copyWith({
    int? high,
    int? moderate,
    int? low,
    int? none,
  }) {
    return CategoryDowntimePresetModel(
      high: high ?? this.high,
      moderate: moderate ?? this.moderate,
      low: low ?? this.low,
      none: none ?? this.none,
    );
  }
}
