class BaseApiResponseModel<T> {
  final bool status;
  final String message;
  final T? data;

  const BaseApiResponseModel({required this.status, required this.message, this.data});

  factory BaseApiResponseModel.fromJson(
      Map<String, dynamic> json,
      T Function(Object? json) fromJsonT,
      ) {
    return BaseApiResponseModel<T>(
      status: json['status'] ?? false,
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
    return BaseApiResponseModel<T>(status: true, message: message, data: data);
  }
}

