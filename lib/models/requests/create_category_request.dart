import 'package:skinsync_admin/models/common_models.dart';

class CreateCategoryResquest {
  final String? name;
  final String? icon;
  final int? parentId;
  final String? imageUrl;
  final int? totalSessions;
  final String? consentFormUrl;
  final String? consentFormName;
  final List<CategorySessionModel>? defaultSessions;
  final List<NotificationConfig>? preNotifications;
  final List<NotificationConfig>? postNotifications;
  final CategoryDowntimePresetModel? downtimePresets;
  final List<String>? defaultRoles;

  CreateCategoryResquest({
    this.name,
    this.icon,
    this.parentId,
    this.totalSessions,
    this.consentFormUrl,
    this.consentFormName,
    this.defaultSessions,
    this.imageUrl,
    this.preNotifications,
    this.postNotifications,
    this.downtimePresets,
    this.defaultRoles,
  });

  Map<String, dynamic> toJson() => {

    "name": name,
    "icon": icon,
    "parent_id": parentId,
   // "imageUrl" : imageUrl,
    "total_sessions": totalSessions,
    "consent_form_url": consentFormUrl,
    "consent_form_name": consentFormName,
    "default_sessions": defaultSessions == null
        ? []
        : List<dynamic>.from(defaultSessions!.map((x) => x.toJson())),
    "pre_notifications": preNotifications == null
        ? []
        : List<dynamic>.from(preNotifications!.map((x) => x.toJson())),
    "post_notifications": postNotifications == null
        ? []
        : List<dynamic>.from(postNotifications!.map((x) => x.toJson())),
    "downtime_presets": downtimePresets?.toJson(),
    
    "default_roles": defaultRoles == null
        ? []
        : List<dynamic>.from(defaultRoles!.map((x) => x)),
  };
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
      followUps:
          (json['follow_ups'] as List?)
              ?.map(
                (e) =>
                    CategoryFollowUpModel.fromJson(e as Map<String, dynamic>),
              )
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
    return {'high': high, 'moderate': moderate, 'low': low, 'none': none};
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
