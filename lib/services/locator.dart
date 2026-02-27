import 'package:get_it/get_it.dart';
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
  final secureStorageService = SecureStorageService();
  await secureStorageService.init();
  locator.registerSingleton(secureStorageService);
  locator.registerSingleton(apiBaseHelper);
}
