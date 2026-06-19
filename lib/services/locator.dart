import 'package:get_it/get_it.dart';
import 'package:skinsync_admin/repositories/area_repository.dart';
import 'package:skinsync_admin/repositories/category_repository.dart';
import 'package:skinsync_admin/repositories/clinic_repository.dart';
import 'package:skinsync_admin/repositories/product_repository.dart';
import 'package:skinsync_admin/repositories/subscription_repository.dart';
import 'package:skinsync_admin/services/area_services.dart';
import 'package:skinsync_admin/services/category_services.dart';
import 'package:skinsync_admin/services/clinic_services.dart';
import 'package:skinsync_admin/services/product_services.dart';
import 'package:skinsync_admin/services/subscription_services.dart';

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
  final secureStorageService = SecureStorageService();
  await secureStorageService.init();
  locator.registerSingleton(secureStorageService);
  locator.registerSingleton(apiBaseHelper);
}
