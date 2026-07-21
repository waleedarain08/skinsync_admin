import '../models/requests/appointment_type_request.dart';
import '../models/requests/booking_method_request.dart';
import '../models/responses/booking_configuration_response.dart';
import '../repositories/booking_repository.dart';
import '../utils/enums.dart';
import '../utils/exception.dart';
import 'api_base_helper.dart';

class BookingServices implements BookingRepository {
  final ApiBaseHelper _api;

  BookingServices({required ApiBaseHelper api}) : _api = api;

  @override
  Future<BookingConfigurationResponse> getBookingConfiguration() async {
    final jsonResponse = await _api.get(Endpoint.bookingConfig);
    final response = BookingConfigurationResponse.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<void> createBookingMethod({required CreateBookingMethodRequest req}) async {
    // await _api.post(Endpoint.bookingConfig, body: req.toJson());
  }

  @override
  Future<void> updateBookingMethod({
    required int id,
    required String title,
    required String description,
    String? icon,
  }) async {
    // final body = {
    //   'title': title,
    //   'description': description,
    //   if (icon != null) 'icon': icon,
    // };
    // await _api.patch(Endpoint.bookingConfig, body: body, pathParams: {'id': id.toString()});
  }

  @override
  Future<void> createAppointmentType({required CreateAppointmentTypeRequest req}) async {
    // await _api.post(Endpoint.bookingConfig, body: req.toJson());
  }

  @override
  Future<void> updateAppointmentType({
    required int id,
    required String title,
    required String description,
    required String timing,
    required int maxDuration,
    required List<String> appointmentModes,
    String? icon,
    String? image,
  }) async {
    // final body = {
    //   'title': title,
    //   'description': description,
    //   'timing': timing,
    //   'max_duration': maxDuration,
    //   'appointment_modes': appointmentModes,
    //   if (icon != null) 'icon': icon,
    //   if (image != null) 'image': image,
    // };
    // await _api.patch(Endpoint.bookingConfig, body: body, pathParams: {'id': id.toString()});
  }
}
