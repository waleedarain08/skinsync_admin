import '../models/requests/booking_config_requests.dart';
import '../models/responses/booking_configuration_response.dart';

abstract class BookingRepository {
  Future<BookingConfigurationResponse> getBookingConfiguration();
  
  Future<void> createBookingMethod({required CreateBookingMethodRequest req});
  
  Future<void> updateBookingMethod({
    required int id,
    required String title,
    required String description,
    String? icon,
  });

  Future<void> createAppointmentType({required CreateAppointmentTypeRequest req});

  Future<void> updateAppointmentType({
    required int id,
    required String internalTitle,
    required String description,
    required String timing,
    required int maxDuration,
    required List<String> appointmentModes,
    String? icon,
    String? image,
  });
}
