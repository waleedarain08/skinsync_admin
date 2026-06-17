import 'dart:convert';

import 'responses/category_detail_response.dart';

class FollowUpModel {
  final String type;
  final int durationValue;
  final Unit durationUnit;
  final int intervalValue;
  final String intervalUnit;
  final bool isImageRequired;
  final String notes;

  FollowUpModel({
    required this.type,
    required this.durationValue,
    required this.durationUnit,
    required this.intervalValue,
    required this.intervalUnit,
    required this.isImageRequired,
    required this.notes,
  });

  factory FollowUpModel.fromRawJson(String str) => FollowUpModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FollowUpModel.fromJson(Map<String, dynamic> json) => FollowUpModel(
    type: json["type"],
    durationValue: json["duration_value"],
    durationUnit: unitValues.map[json["duration_unit"]]!,
    intervalValue: json["interval_value"],
    intervalUnit: json["interval_unit"],
    isImageRequired: json["is_image_required"],
    notes: json["notes"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "duration_value": durationValue,
    "duration_unit": unitValues.reverse[durationUnit],
    "interval_value": intervalValue,
    "interval_unit": intervalUnit,
    "is_image_required": isImageRequired,
    "notes": notes,
  };
}
