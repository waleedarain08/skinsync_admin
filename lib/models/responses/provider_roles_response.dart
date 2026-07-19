import 'dart:convert';

import 'package:skinsync_admin/models/responses/base_response_model.dart';

class ProviderRolesResponse extends BaseApiResponseModel<List<ProviderRoles>> {
  ProviderRolesResponse({
    super.data,
    required super.isSuccess,
    required super.message,
  });

  factory ProviderRolesResponse.fromJson(Map<String, dynamic> json) =>
      ProviderRolesResponse(
        data: json["data"] == null
            ? []
            : List<ProviderRoles>.from(
                json["data"]!.map((x) => ProviderRoles.fromJson(x)),
              ),
        isSuccess: json["is_success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "is_success": isSuccess,
    "message": message,
  };
}

class ProviderRoles {
  final int? id;
  final String? name;

  ProviderRoles({this.id, this.name});

  factory ProviderRoles.fromRawJson(String str) =>
      ProviderRoles.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProviderRoles.fromJson(Map<String, dynamic> json) =>
      ProviderRoles(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
