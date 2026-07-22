import 'base_response_model.dart';

class BookingMethodsListResponse extends BaseApiResponseModel<List<BookingMethodModel>> {
  const BookingMethodsListResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory BookingMethodsListResponse.fromJson(Map<String, dynamic> json) {
    return BookingMethodsListResponse(
      isSuccess: json['is_success'] as bool? ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List?)
          ?.map((e) => BookingMethodModel.fromJson(e))
          .toList(),
    );
  }
}

class BookingMethodModel {
  final int id;
  final String key;
  final String title;
  final String description;
  final String? icon;

  const BookingMethodModel({
    required this.id,
    required this.key,
    required this.title,
    required this.description,
    this.icon,
  });

  factory BookingMethodModel.fromJson(Map<String, dynamic> json) {
    return BookingMethodModel(
      id: json['id'] ?? 0,
      key: json['key'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'],
    );
  }
}
