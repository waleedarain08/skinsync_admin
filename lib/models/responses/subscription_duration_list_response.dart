import '../duration_option_model.dart';
import 'base_response_model.dart';

class SubscriptionDurationListResponse extends BaseApiResponseModel<List<DurationOption>> {
  const SubscriptionDurationListResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory SubscriptionDurationListResponse.fromJson(Map<String, dynamic> json) =>
      SubscriptionDurationListResponse(
        isSuccess: (json['is_success'] as bool?) ?? false,
        message: json['message'] ?? '',
        data: json['data'] == null
            ? []
            : (json['data'] as List)
                .where((e) => e != null)
                .map((e) => DurationOption.fromJson(e as Map<String, dynamic>))
                .toList(),
      );
}
