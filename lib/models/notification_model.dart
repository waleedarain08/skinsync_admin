import 'dart:convert';
import 'responses/category_detail_response.dart';

class NotificationModel {
  final String title;
  final String message;
  final int timing;
  final Unit? timingUnit;
  final Type? type;

  NotificationModel({
    required this.title,
    required this.message,
    required this.timing,
    this.timingUnit,
    this.type,
  });

  factory NotificationModel.fromRawJson(String str) =>
      NotificationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        title: json["title"],
        message: json["message"],
        timing: json["timing"],
        timingUnit: unitValues.map[json["timing_unit"]],
        type: typeValues.map[json["type"]],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "message": message,
        "timing": timing,
        "timing_unit": unitValues.reverse[timingUnit],
        "type": typeValues.reverse[type],
      };
}