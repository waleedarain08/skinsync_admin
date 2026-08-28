import '../subscription_duration_model.dart';
import 'base_response_model.dart';

class SubscriptionDurationResponse extends BaseApiResponseModel<SubscriptionDuration> {
  const SubscriptionDurationResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory SubscriptionDurationResponse.fromJson(Map<String, dynamic> json) =>
      SubscriptionDurationResponse(
        isSuccess: (json['is_success'] as bool?) ?? false,
        message: json['message'] ?? '',
        data: json['data'] == null
            ? null
            : SubscriptionDuration.fromJson(json['data'] as Map<String, dynamic>),
      );
}
