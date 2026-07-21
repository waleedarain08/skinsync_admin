import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/requests/appointment_type_request.dart';
import 'package:skinsync_admin/models/requests/booking_method_request.dart';
import 'package:skinsync_admin/models/responses/booking_configuration_response.dart';
import 'package:skinsync_admin/repositories/booking_repository.dart';
import 'package:skinsync_admin/services/locator.dart';
import 'package:skinsync_admin/utils/dummy_data.dart';
import 'base_state_model.dart';
import 'base_view_model.dart';

final bookingConfigViewModelProvider = NotifierProvider<BookingConfigViewModel, BookingConfigState>(
  BookingConfigViewModel.new,
);

class BookingConfigState extends BaseStateModel {
  final BookingConfigurationData? config;
  final String? errorMessage;

  BookingConfigState({
    super.loading,
    this.config,
    this.errorMessage,
  });

  BookingConfigState copyWith({
    bool? loading,
    BookingConfigurationData? config,
    String? errorMessage,
  }) {
    return BookingConfigState(
      loading: loading ?? this.loading,
      config: config ?? this.config,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class BookingConfigViewModel extends BaseViewModel<BookingConfigState> {
  BookingConfigViewModel() : super(BookingConfigState());

  final BookingRepository _bookingRepository = locator<BookingRepository>();

  Future<void> fetchBookingConfig() async {
    await runSafely(
      onLoadingChange: (loading) => state = state.copyWith(loading: loading),
      () async {
        try {
          // Use dummy data for now
          await Future<void>.delayed(const Duration(seconds: 1));
          const dummyData = BookingConfigurationData(
            bookingMethods: BookingConfigData.dummyBookingMethods,
            appointmentTypes: BookingConfigData.dummyAppointmentTypes,
          );
          state = state.copyWith(config: dummyData, errorMessage: null);
          
          // Re-enable this when API is live
          // final response = await _bookingRepository.getBookingConfiguration();
          // state = state.copyWith(config: response.data, errorMessage: null);
        } catch (e) {
          state = state.copyWith(errorMessage: e.toString());
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
        await fetchBookingConfig();
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
        await fetchBookingConfig();
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
        await fetchBookingConfig();
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
        await fetchBookingConfig();
        return true;
      },
    ) ?? false;
  }
}
