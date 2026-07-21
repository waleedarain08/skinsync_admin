
import 'package:skinsync_admin/models/responses/base_response_model.dart';

class DownTimeLevelResponse extends BaseApiResponseModel<List<DownTimeLevel>> {
  DownTimeLevelResponse({
    super.data,
    required super.isSuccess,
    required super.message,
  });

  factory DownTimeLevelResponse.fromJson(Map<String, dynamic> json) =>
      DownTimeLevelResponse(
        data: json["data"] == null
            ? []
            : List<DownTimeLevel>.from(
                json["data"]!.map((x) => DownTimeLevel.fromJson(x)),
              ),
        isSuccess: json["is_success"],
        message: json["message"],
      );
}

class DownTimeLevel {
  final String? level;
  final int? days;

  DownTimeLevel({this.level, this.days});

  factory DownTimeLevel.fromJson(Map<String, dynamic> json) =>
      DownTimeLevel(level: json["level"], days: json["days"]);
}
