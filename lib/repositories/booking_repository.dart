import '../models/responses/booking_configuration_response.dart';

abstract class BookingRepository {
  Future<BookingConfigurationResponse> getBookingConfiguration();
  Future<void> updateAppointmentType({
    required int id,
    required String patientDisplayName,
    required String description,
    required String timing,
    required int maxDuration,
    required List<String> appointmentModes,
    String? icon,
    String? image,
  });
}
