import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/requests/appointment_type_request.dart';
import 'package:skinsync_admin/models/requests/booking_method_request.dart';
import 'package:skinsync_admin/models/responses/appointment_types_list_response.dart';
import 'package:skinsync_admin/models/responses/booking_methods_list_response.dart';
import 'package:skinsync_admin/repositories/booking_repository.dart';
import 'package:skinsync_admin/services/locator.dart';
import 'base_state_model.dart';
import 'base_view_model.dart';

final bookingConfigViewModelProvider = NotifierProvider<BookingConfigViewModel, BookingConfigState>(
  BookingConfigViewModel.new,
);

class BookingConfigState extends BaseStateModel {
  final List<BookingMethodModel>? bookingMethods;
  final List<AppointmentTypeModel>? appointmentTypes;
  final List<String>? appointmentTimings;
  final String? errorMessage;

  BookingConfigState({
    super.loading,
    this.bookingMethods,
    this.appointmentTypes,
    this.appointmentTimings,
    this.errorMessage,
  });

  BookingConfigState copyWith({
    bool? loading,
    List<BookingMethodModel>? bookingMethods,
    List<AppointmentTypeModel>? appointmentTypes,
    List<String>? appointmentTimings,
    String? errorMessage,
  }) {
    return BookingConfigState(
      loading: loading ?? this.loading,
      bookingMethods: bookingMethods ?? this.bookingMethods,
      appointmentTypes: appointmentTypes ?? this.appointmentTypes,
      appointmentTimings: appointmentTimings ?? this.appointmentTimings,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class BookingConfigViewModel extends BaseViewModel<BookingConfigState> {
  BookingConfigViewModel() : super(BookingConfigState());

  final BookingRepository _bookingRepository = locator<BookingRepository>();

  Future<void> fetchBookingMethods() async {
    await runSafely(
      onLoadingChange: (loading) => state = state.copyWith(loading: loading),
      () async {
        try {
          final response = await _bookingRepository.getBookingMethods();
          state = state.copyWith(
            bookingMethods: response.data,
            errorMessage: null,
          );
        } catch (e) {
          if (state.bookingMethods == null) {
            state = state.copyWith(errorMessage: e.toString());
          }
          rethrow;
        }
      },
    );
  }

  Future<void> fetchAppointmentTypes() async {
    await runSafely(
      onLoadingChange: (loading) => state = state.copyWith(loading: loading),
      () async {
        try {
          final response = await _bookingRepository.getAppointmentTypes();
          state = state.copyWith(
            appointmentTypes: response.data,
            errorMessage: null,
          );
        } catch (e) {
          if (state.appointmentTypes == null) {
            state = state.copyWith(errorMessage: e.toString());
          }
          rethrow;
        }
      },
    );
  }

  Future<void> fetchAppointmentTimings() async {
    await runSafely(
      onLoadingChange: (loading) => state = state.copyWith(loading: loading),
      () async {
        try {
          final response = await _bookingRepository.getAppointmentTimings();
          state = state.copyWith(
            appointmentTimings: response.data,
            errorMessage: null,
          );
        } catch (e) {
          rethrow;
        }
      },
    );
  }

  Future<bool> createBookingMethod({
    required String title,
    required String key,
    required String description,
    String? icon,
  }) async {
    return await runSafely<bool>(
      onLoadingChange: (loading) => state = state.copyWith(loading: loading),
      () async {
        await _bookingRepository.createBookingMethod(
          req: CreateBookingMethodRequest(
            title: title,
            key: key,
            description: description,
            icon: icon,
          ),
        );
        EasyLoading.showSuccess('Booking method created successfully');
        await fetchBookingMethods();
        return true;
      },
    ) ?? false;
  }

  Future<bool> updateBookingMethod({
    required int id,
    required String title,
    required String description,
    String? icon,
  }) async {
    return await runSafely<bool>(
      onLoadingChange: (loading) => state = state.copyWith(loading: loading),
      () async {
        await _bookingRepository.updateBookingMethod(
          id: id,
          title: title,
          description: description,
          icon: icon,
        );
        EasyLoading.showSuccess('Booking method updated successfully');
        await fetchBookingMethods();
        return true;
      },
    ) ?? false;
  }

  Future<bool> createAppointmentType({
    required String title,
    required String key,
    required String description,
    required String timing,
    required int maxDuration,
    required List<String> appointmentModes,
    String? icon,
    String? image,
  }) async {
    return await runSafely<bool>(
      onLoadingChange: (loading) => state = state.copyWith(loading: loading),
      () async {
        await _bookingRepository.createAppointmentType(
          req: CreateAppointmentTypeRequest(
            title: title,
            key: key,
            description: description,
            timing: timing,
            maxDuration: maxDuration,
            appointmentModes: appointmentModes,
            icon: icon,
            image: image,
          ),
        );
        EasyLoading.showSuccess('Appointment type created successfully');
        await fetchAppointmentTypes();
        return true;
      },
    ) ?? false;
  }

  Future<bool> updateAppointmentType({
    required int id,
    required String title,
    required String description,
    required String timing,
    required int maxDuration,
    required List<String> appointmentModes,
    String? icon,
    String? image,
  }) async {
    return await runSafely<bool>(
      onLoadingChange: (loading) => state = state.copyWith(loading: loading),
      () async {
        await _bookingRepository.updateAppointmentType(
          id: id,
          title: title,
          description: description,
          timing: timing,
          maxDuration: maxDuration,
          appointmentModes: appointmentModes,
          icon: icon,
          image: image,
        );
        EasyLoading.showSuccess('Appointment type updated successfully');
        await fetchAppointmentTypes();
        return true;
      },
    ) ?? false;
  }
}
