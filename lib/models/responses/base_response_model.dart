class BaseApiResponseModel<T> {
  final bool isSuccess;
  final String message;
  final T? data;

  const BaseApiResponseModel({
    required this.isSuccess,
    required this.message,
    this.data,
  });

  factory BaseApiResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return BaseApiResponseModel<T>(
      isSuccess: json['is_success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }

  /// For APIs that don’t wrap data
  factory BaseApiResponseModel.raw({
    required T data,
    String message = '',
    int statusCode = 400,
  }) {
    return BaseApiResponseModel<T>(
      isSuccess: true,
      message: message,
      data: data,
    );
  }
}
