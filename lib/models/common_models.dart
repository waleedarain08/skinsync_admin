class FollowUpConfig {
  String type; // virtual | in_person
  int? durationValue;
  String durationUnit; // minutes | hours
  String? notes;
  int? intervalValue;
  String? intervalUnit; // days | weeks

  FollowUpConfig({
    required this.type,
    this.durationValue,
    this.durationUnit = 'minutes',
    this.notes,
    this.intervalValue,
    this.intervalUnit = 'days',
  });

  factory FollowUpConfig.fromJson(Map<String, dynamic> json) => FollowUpConfig(
    type: json['type'] ?? 'virtual',
    durationValue: json['duration_value'],
    durationUnit: json['duration_unit'] ?? 'minutes',
    notes: json['notes'],
    intervalValue: json['interval_value'],
    intervalUnit: json['interval_unit'],
  );

  Map<String, dynamic> toJson() => {
    'type': type,
    'duration_value': durationValue,
    'duration_unit': durationUnit,
    'notes': notes,
    'interval_value': intervalValue,
    'interval_unit': intervalUnit,
  };
}

class NotificationConfig {
  String? message;
  int? timing; // in minutes/hours/days - we should standardize to minutes internal

  NotificationConfig({this.message, this.timing});

  factory NotificationConfig.fromJson(Map<String, dynamic> json) => NotificationConfig(
    message: json['message'],
    timing: json['timing'],
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'timing': timing,
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
