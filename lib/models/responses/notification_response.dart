
import 'base_response_model.dart';

class NotificationResponse
    extends BaseApiResponseModel<List<NotificationData>?> {
  final int? limit;
  final int? page;
  final int? totalPages;

  NotificationResponse({
    super.data,
    required super.isSuccess,
    this.limit,
    required super.message,
    this.page,
    this.totalPages,
  });

 

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      NotificationResponse(
        data: json["data"] == null
            ? []
            : List<NotificationData>.from(
                json["data"]!.map((x) => NotificationData.fromJson(x)),
              ),
        isSuccess: json["is_success"],
        limit: json["limit"],
        message: json["message"],
        page: json["page"],
        totalPages: json["total_pages"],
      );

 
}

class NotificationData {
  final String? body;
  final DateTime? createdAt;
  final int? id;
  final String? status;
  final String? title;

  NotificationData({
    this.body,
    this.createdAt,
    this.id,
    this.status,
    this.title,
  });

 

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        body: json["body"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        id: json["id"],
        status: json["status"],
        title: json["title"],
      );

 
}
