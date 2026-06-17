import 'dart:convert';

import 'follow_up_model.dart';

class SessionsModel {
  final int sessionNumber;
  final List<FollowUpModel> followUps;

  SessionsModel({
    required this.sessionNumber,
    required this.followUps,
  });

  factory SessionsModel.fromRawJson(String str) => SessionsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SessionsModel.fromJson(Map<String, dynamic> json) => SessionsModel(
    sessionNumber: json["session_number"],
    followUps: List<FollowUpModel>.from(json["follow_ups"].map((x) => FollowUpModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "session_number": sessionNumber,
    "follow_ups": List<dynamic>.from(followUps.map((x) => x.toJson())),
  };
}
