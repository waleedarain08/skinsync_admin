import 'package:get_it/get_it.dart';
import 'package:skinsync_admin/repositories/clinic_repository.dart';
import 'package:skinsync_admin/services/clinic_services.dart';
import '../repositories/auth_repository.dart';
import 'api_base_helper.dart';
import 'auth_service.dart';
import 'storage_service.dart';

final locator = GetIt.instance;

Future<void> initializeServices() async {
  await locator.reset();

  /// Services
  final apiBaseHelper = ApiBaseHelper();
  locator.registerLazySingleton<AuthRepository>(
    () => AuthService(api: apiBaseHelper),
  );
  locator.registerLazySingleton<ClinicRepository>(
    () => ClinicService(api: apiBaseHelper),
  );
  final secureStorageService = SecureStorageService();
  await secureStorageService.init();
  locator.registerSingleton(secureStorageService);
  locator.registerSingleton(apiBaseHelper);
}
