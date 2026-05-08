import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/app_init.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/home_page.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/patient_management.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/product_management.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/push_notification_screen.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/setting_screen.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/user_management.dart';
import 'package:skinsync_admin/screens/create_treatment_screen.dart';
import 'package:skinsync_admin/screens/dispute_screen.dart';
import 'package:skinsync_admin/screens/sign_in_screen.dart';
import 'package:skinsync_admin/screens/signup_screen.dart';
import 'package:skinsync_admin/screens/treatment_management_screen.dart';

import 'screens/bottom_nav_screens/clinic_management.dart';
import 'screens/payment_screen.dart';
import 'screens/splash_screen.dart';

class RouteGenerator {
  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: SplashScreen.routeName,
    routes: [
      GoRoute(
        name: SplashScreen.routeName,
        path: SplashScreen.routeName,
        builder: (_, _) => SplashScreen(),
      ),
      GoRoute(
        name: SignUpScreen.routeName,
        path: SignUpScreen.routeName,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        name: SignInScreen.routeName,
        path: SignInScreen.routeName,
        builder: (context, state) => const SignInScreen(), // Create this screen
      ),
      ShellRoute(
        builder: (_, _, child) {
          return HomePage(child: child);
        },
        routes: [
          GoRoute(
            name: UserManagement.routeName,
            path: UserManagement.routeName,
            builder: (_, _) => UserManagement(),
          ),
          GoRoute(
            name: PatientManagement.routeName,
            path: PatientManagement.routeName,
            builder: (_, _) => PatientManagement(),
          ),
          GoRoute(
            name: ClinicManagement.routeName,
            path: ClinicManagement.routeName,
            builder: (_, _) => ClinicManagement(),
          ),
          GoRoute(
            name: DisputeScreen.routeName,
            path: DisputeScreen.routeName,
            builder: (_, _) => DisputeScreen(),
          ),
          GoRoute(
            name: TreatmentManagementScreen.routeName,
            path: TreatmentManagementScreen.routeName,
            builder: (_, _) => TreatmentManagementScreen(),
          ),
          GoRoute(
            name: CreateTreatmentScreen.routeName,
            path: CreateTreatmentScreen.routeName,
            builder: (_, _) => CreateTreatmentScreen(),
          ),
          GoRoute(
            name: PaymentScreen.routeName,
            path: PaymentScreen.routeName,
            builder: (_, _) => PaymentScreen(),
          ),
          GoRoute(
            name: PushNotificationScreen.routeName,
            path: PushNotificationScreen.routeName,
            builder: (_, _) => PushNotificationScreen(),
          ),
          GoRoute(
            name: ProductManagement.routeName,
            path: ProductManagement.routeName,
            builder: (_, _) => ProductManagement(),
          ),
          GoRoute(
            name: SettingScreen.routeName,
            path: SettingScreen.routeName,
            builder: (_, _) => SettingScreen(),
          ),
        ],
      ),
    ],
  );
}
