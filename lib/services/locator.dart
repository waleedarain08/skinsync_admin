import 'package:get_it/get_it.dart';
import 'package:skinsync_admin/repositories/area_repository.dart';
import 'package:skinsync_admin/repositories/booking_repository.dart';
import 'package:skinsync_admin/repositories/category_repository.dart';
import 'package:skinsync_admin/repositories/clinic_repository.dart';
import 'package:skinsync_admin/repositories/explore_repository.dart';
import 'package:skinsync_admin/repositories/form_repository.dart';
import 'package:skinsync_admin/repositories/notification_repository.dart';
import 'package:skinsync_admin/repositories/patient_repository.dart';
import 'package:skinsync_admin/repositories/product_repository.dart';
import 'package:skinsync_admin/repositories/provider_role_repository.dart';
import 'package:skinsync_admin/repositories/session_repository.dart';
import 'package:skinsync_admin/repositories/subscription_repository.dart';
import 'package:skinsync_admin/services/area_services.dart';
import 'package:skinsync_admin/services/booking_services.dart';
import 'package:skinsync_admin/services/category_services.dart';
import 'package:skinsync_admin/services/clinic_services.dart';
import 'package:skinsync_admin/services/explore_service.dart';
import 'package:skinsync_admin/services/form_service.dart';
import 'package:skinsync_admin/services/notification_service.dart';
import 'package:skinsync_admin/services/patient_service.dart';
import 'package:skinsync_admin/services/product_services.dart';
import 'package:skinsync_admin/services/provider_roles_service.dart';
import 'package:skinsync_admin/services/session_services.dart';
import 'package:skinsync_admin/services/subscription_services.dart';
import 'package:skinsync_admin/view_models/forms_controller.dart';

import '../repositories/auth_repository.dart';
import '../repositories/setting_repository.dart';
import '../repositories/treatment_repository.dart';
import 'api_base_helper.dart';
import 'auth_service.dart';
import 'setting_service.dart';
import 'storage_service.dart';
import 'treatment_services.dart';

final locator = GetIt.instance;

Future<void> initializeServices() async {
  await locator.reset();

  /// Services
  final apiBaseHelper = ApiBaseHelper();
  locator.registerLazySingleton<AuthRepository>(
    () => AuthService(api: apiBaseHelper),
  );
  locator.registerLazySingleton<CategoryRepository>(
    () => CategoryServices(api: apiBaseHelper),
  );
  locator.registerLazySingleton<AreaRepository>(
    () => AreaServices(api: apiBaseHelper),
  );
  locator.registerLazySingleton<ClinicRepository>(
    () => ClinicService(api: apiBaseHelper),
  );
  locator.registerLazySingleton<TreatmentRepository>(
    () => TreatmentServices(api: apiBaseHelper),
  );
  locator.registerLazySingleton<SettingRepository>(
    () => SettingService(api: apiBaseHelper),
  );
  locator.registerLazySingleton<ProductRepository>(
    () => ProductServices(api: apiBaseHelper),
  );
  locator.registerLazySingleton<SubscriptionRepository>(
    () => SubscriptionServices(api: apiBaseHelper),
  );
  locator.registerLazySingleton<SessionRepository>(
    () => SessionServices(api: apiBaseHelper),
  );
  locator.registerLazySingleton<ProviderRoleRepository>(
    () => ProviderRolesService(api: apiBaseHelper),
  );
  locator.registerLazySingleton<BookingRepository>(
    () => BookingServices(api: apiBaseHelper),
  );
  locator.registerLazySingleton<PatientRepository>(
    () => PatientService(api: apiBaseHelper),
  );
   locator.registerLazySingleton<NotificationRepository>(
    () => NotificationService(api: apiBaseHelper),
  );
  locator.registerLazySingleton<FormRepository>(
    () => FormService(api: apiBaseHelper),
  );
   final formsController = FormsController();
  await formsController.init();
  locator.registerSingleton(formsController);
  locator.registerLazySingleton<ExploreRepository>(ExploreService.new);
  final secureStorageService = SecureStorageService();
  await secureStorageService.init();
  locator.registerSingleton(secureStorageService);
  locator.registerSingleton(apiBaseHelper);
}
