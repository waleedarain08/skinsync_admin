import '../models/responses/notification_response.dart';
import '../repositories/notification_repository.dart';
import '../utils/enums.dart';
import 'api_base_helper.dart';

class NotificationService implements NotificationRepository {
  final ApiBaseHelper _api;

  NotificationService({required ApiBaseHelper api}) : _api = api;
  @override
  Future<NotificationResponse> fetchNotification({
    int page = 1,
    int limit = 20,
  }) async {
    final response =  await _api.get(
       Endpoint.notification,
    
      queryParams: {'page': page.toString(), 'limit': limit.toString()},
    );

    final model = NotificationResponse.fromJson(response);

    return model;
  }
}
