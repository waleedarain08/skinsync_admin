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
  Future<void> updateAppointmentType({
    required int id,
    required String patientDisplayName,
    required String description,
    required String timing,
    required int maxDuration,
    required List<String> appointmentModes,
    String? icon,
    String? image,
  }) async {
    // This is a placeholder for the actual update endpoint logic
    // final body = {
    //   'patient_display_name': patientDisplayName,
    //   'description': description,
    //   'timing': timing,
    //   'max_duration': maxDuration,
    //   'appointment_modes': appointmentModes,
    //   'icon': icon,
    //   'image': image,
    // };
    // await _api.patch(Endpoint.updateAppointmentType, body: body, pathParams: {'id': id.toString()});
  }
}
