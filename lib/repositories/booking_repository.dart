import '../models/requests/appointment_type_request.dart';
import '../models/requests/booking_method_request.dart';
import '../models/responses/appointment_timing_list_response.dart';
import '../models/responses/appointment_types_list_response.dart';
import '../models/responses/booking_methods_list_response.dart';

abstract class BookingRepository {
  Future<BookingMethodsListResponse> getBookingMethods();
  Future<AppointmentTypesListResponse> getAppointmentTypes();
  Future<AppointmentTimingListResponse> getAppointmentTimings();
  
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
    required String title,
    required String description,
    required String timing,
    required int maxDuration,
    required List<String> appointmentModes,
    String? icon,
    String? image,
  });
}
