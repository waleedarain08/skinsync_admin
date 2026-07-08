import '../session_model.dart';
import 'base_response_model.dart';

class SessionListResponse extends BaseApiResponseModel<List<SessionModel>> {
  const SessionListResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory SessionListResponse.fromJson(Map<String, dynamic> json) =>
      SessionListResponse(
        isSuccess: (json['is_success'] as bool?) ?? false,
        message: json['message'] ?? '',
        data: json['data'] == null
            ? null
            : (json['data'] as List)
                .map((e) => SessionModel.fromJson(e as Map<String, dynamic>))
                .toList(),
      );
}

