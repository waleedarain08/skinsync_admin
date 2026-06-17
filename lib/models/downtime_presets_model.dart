import 'dart:convert';

class DowntimePresetsModel {
  final int high;
  final int low;
  final int moderate;
  final int none;

  DowntimePresetsModel({
    required this.high,
    required this.low,
    required this.moderate,
    required this.none,
  });

  factory DowntimePresetsModel.fromRawJson(String str) => DowntimePresetsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DowntimePresetsModel.fromJson(Map<String, dynamic> json) => DowntimePresetsModel(
    high: json["high"],
    low: json["low"],
    moderate: json["moderate"],
    none: json["none"],
  );

  Map<String, dynamic> toJson() => {
    "high": high,
    "low": low,
    "moderate": moderate,
    "none": none,
  };
}
