class FollowUpConfig {
  String type; // virtual | in_person
  int? durationValue;
  String durationUnit; // minutes | hours
  String? notes;
  int? intervalValue;
  String? intervalUnit; // days | weeks
  bool isImageRequired;

  FollowUpConfig({
    required this.type,
    this.durationValue,
    this.durationUnit = 'minutes',
    this.notes,
    this.intervalValue,
    this.intervalUnit = 'days',
    this.isImageRequired = false,
  });

  factory FollowUpConfig.fromJson(Map<String, dynamic> json) => FollowUpConfig(
    type: json['type'] ?? 'virtual',
    durationValue: json['duration_value'],
    durationUnit: json['duration_unit'] ?? 'minutes',
    notes: json['notes'],
    intervalValue: json['interval_value'],
    intervalUnit: json['interval_unit'],
    isImageRequired: json['is_image_required'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'type': type,
    'duration_value': durationValue,
    'duration_unit': durationUnit,
    'notes': notes,
    'interval_value': intervalValue,
    'interval_unit': intervalUnit,
    'is_image_required': isImageRequired,
  };
}

class SessionConfig {
  final int sessionNumber;
  final List<FollowUpConfig> followUps;

  SessionConfig({required this.sessionNumber, this.followUps = const []});

  factory SessionConfig.fromJson(Map<String, dynamic> json) => SessionConfig(
    sessionNumber: json['session_number'] ?? 1,
    followUps: (json['follow_ups'] as List?)?.map((e) => FollowUpConfig.fromJson(e)).toList() ?? [],
  );

  Map<String, dynamic> toJson() => {
    'session_number': sessionNumber,
    'follow_ups': followUps.map((e) => e.toJson()).toList(),
  };
}

class NotificationConfig {
  String? title;
  String? message;
  int? timing; // in minutes/hours/days - we should standardize to minutes internal
  String? timingUnit;
  String? type;

  NotificationConfig({this.title, this.message, this.timing, this.timingUnit, this.type});

  factory NotificationConfig.fromJson(Map<String, dynamic> json) => NotificationConfig(
    title: json['title'],
    message: json['message'],
    timing: json['timing'],
    timingUnit: json['timing_unit'],
    type: json['type'],
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'message': message,
    'timing': timing,
    'timing_unit': timingUnit,
    'type': type,
  };
}

class DowntimePresets {
  int none;
  int low;
  int moderate;
  int high;

  DowntimePresets({
    this.none = 0,
    this.low = 2,
    this.moderate = 5,
    this.high = 10,
  });

  factory DowntimePresets.fromJson(Map<String, dynamic> json) => DowntimePresets(
    none: json['none'] ?? 0,
    low: json['low'] ?? 2,
    moderate: json['moderate'] ?? 5,
    high: json['high'] ?? 10,
  );

  Map<String, dynamic> toJson() => {
    'none': none,
    'low': low,
    'moderate': moderate,
    'high': high,
  };
}

class SubAreaConsumption {
  String subAreaName;
  double minQuantity;
  double maxQuantity;

  SubAreaConsumption({
    required this.subAreaName,
    this.minQuantity = 0.0,
    this.maxQuantity = 0.0,
  });

  factory SubAreaConsumption.fromJson(Map<String, dynamic> json) => SubAreaConsumption(
    subAreaName: json['sub_area_name'] ?? '',
    minQuantity: (json['min_quantity'] as num?)?.toDouble() ?? 0.0,
    maxQuantity: (json['max_quantity'] as num?)?.toDouble() ?? 0.0,
  );

  Map<String, dynamic> toJson() => {
    'sub_area_name': subAreaName,
    'min_quantity': minQuantity,
    'max_quantity': maxQuantity,
  };
}

class ProductUsageModel {
  int productId;
  String productName;
  String usageType; // Required | Optional | Variable | Setup | Post_Care | Device
  double? minQuantity;
  double? maxQuantity;
  String deductionTiming; // On_Completion | Manual | Post_Confirmation
  bool allowSubstitution;
  String? notes;
  String unit;
  double? perUnitDuration;
  List<SubAreaConsumption>? subAreaConsumptions;

  ProductUsageModel({
    required this.productId,
    required this.productName,
    required this.usageType,
    this.minQuantity,
    this.maxQuantity,
    required this.deductionTiming,
    this.allowSubstitution = false,
    this.notes,
    this.unit = 'Units',
    this.perUnitDuration,
    this.subAreaConsumptions,
  });

  factory ProductUsageModel.fromJson(Map<String, dynamic> json) => ProductUsageModel(
    productId: json['product_id'],
    productName: json['product_name'],
    usageType: json['usage_type'] ?? 'Required',
    minQuantity: json['min_quantity']?.toDouble(),
    maxQuantity: json['max_quantity']?.toDouble(),
    deductionTiming: json['deduction_timing'] ?? 'On_Completion',
    allowSubstitution: json['allow_substitution'] ?? false,
    notes: json['notes'],
    unit: json['unit'] ?? 'Units',
    perUnitDuration: json['per_unit_duration']?.toDouble(),
    subAreaConsumptions: json['sub_area_consumptions'] != null
        ? (json['sub_area_consumptions'] as List)
            .map((e) => SubAreaConsumption.fromJson(e))
            .toList()
        : null,
  );

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'product_name': productName,
    'usage_type': usageType,
    'min_quantity': minQuantity,
    'max_quantity': maxQuantity,
    'deduction_timing': deductionTiming,
    'allow_substitution': allowSubstitution,
    'notes': notes,
    'unit': unit,
    'per_unit_duration': perUnitDuration,
    if (subAreaConsumptions != null)
      'sub_area_consumptions': subAreaConsumptions!.map((e) => e.toJson()).toList(),
  };
}

class Attachment {
  String url;
  String type; // image | video | pdf
  String name;

  Attachment({required this.url, required this.type, required this.name});

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
    url: json['url'],
    type: json['type'],
    name: json['name'],
  );

  Map<String, dynamic> toJson() => {
    'url': url,
    'type': type,
    'name': name,
  };
}
