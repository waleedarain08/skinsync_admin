import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/app_init.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/appointment_management.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/clinic_management.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/dashboard_screen.dart';
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
import 'package:skinsync_admin/screens/payment_screen.dart';
import 'package:skinsync_admin/screens/splash_screen.dart';

class RouteGenerator {
  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: SplashScreen.routeName,
    routes: [
      GoRoute(
        name: SplashScreen.routeName,
        path: SplashScreen.routeName,
        builder: (_, _) => const SplashScreen(),
      ),
      GoRoute(
        name: SignUpScreen.routeName,
        path: SignUpScreen.routeName,
        builder: (_, _) => const SignUpScreen(),
      ),
      GoRoute(
        name: SignInScreen.routeName,
        path: SignInScreen.routeName,
        builder: (_, _) => const SignInScreen(),
      ),
      ShellRoute(
        builder: (_, _, child) {
          return HomePage(child: child);
        },
        routes: [
          GoRoute(
            name: DashboardScreen.routeName,
            path: DashboardScreen.routeName,
            builder: (_, _) => const DashboardScreen(),
          ),
          GoRoute(
            name: AppointmentManagement.routeName,
            path: AppointmentManagement.routeName,
            builder: (_, _) => const AppointmentManagement(),
          ),
          GoRoute(
            name: UserManagement.routeName,
            path: UserManagement.routeName,
            builder: (_, _) => const UserManagement(),
          ),
          GoRoute(
            name: PatientManagement.routeName,
            path: PatientManagement.routeName,
            builder: (_, _) => const PatientManagement(),
          ),
          GoRoute(
            name: ClinicManagement.routeName,
            path: ClinicManagement.routeName,
            builder: (_, _) => const ClinicManagement(),
          ),
          GoRoute(
            name: DisputeScreen.routeName,
            path: DisputeScreen.routeName,
            builder: (_, _) => const DisputeScreen(),
          ),
          GoRoute(
            name: TreatmentManagementScreen.routeName,
            path: TreatmentManagementScreen.routeName,
            builder: (_, _) => const TreatmentManagementScreen(),
          ),
          GoRoute(
            name: CreateTreatmentScreen.routeName,
            path: CreateTreatmentScreen.routeName,
            builder: (_, _) => const CreateTreatmentScreen(),
          ),
          GoRoute(
            name: PaymentScreen.routeName,
            path: PaymentScreen.routeName,
            builder: (_, _) => const PaymentScreen(),
          ),
          GoRoute(
            name: PushNotificationScreen.routeName,
            path: PushNotificationScreen.routeName,
            builder: (_, _) => const PushNotificationScreen(),
          ),
          GoRoute(
            name: ProductManagement.routeName,
            path: ProductManagement.routeName,
            builder: (_, _) => const ProductManagement(),
          ),
          GoRoute(
            name: SettingScreen.routeName,
            path: SettingScreen.routeName,
            builder: (_, _) => const SettingScreen(),
          ),
        ],
      ),
    ],
  );
}
