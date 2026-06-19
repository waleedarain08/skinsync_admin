import 'dart:convert';

import 'responses/category_detail_response.dart';

class FollowUpModel {
  final String? type;
  final int? durationValue;
  final Unit? durationUnit;
  final int? intervalValue;
  final String? intervalUnit;
  final bool? isImageRequired;
  final String? notes;

  FollowUpModel({
    this.type,
    this.durationValue,
    this.durationUnit,
    this.intervalValue,
    this.intervalUnit,
    this.isImageRequired,
    this.notes,
  });

  factory FollowUpModel.fromRawJson(String str) =>
      FollowUpModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FollowUpModel.fromJson(Map<String, dynamic> json) =>
      FollowUpModel(
        type: json["type"],
        durationValue: json["duration_value"],
        durationUnit: json["duration_unit"] != null
            ? unitValues.map[json["duration_unit"]]
            : null,
        intervalValue: json["interval_value"],
        intervalUnit: json["interval_unit"],
        isImageRequired: json["is_image_required"],
        notes: json["notes"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "duration_value": durationValue,
        "duration_unit":
            durationUnit != null
                ? unitValues.reverse[durationUnit]
                : null,
        "interval_value": intervalValue,
        "interval_unit": intervalUnit,
        "is_image_required": isImageRequired,
        "notes": notes,
      };
}