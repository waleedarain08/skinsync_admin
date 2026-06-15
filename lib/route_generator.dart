import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/app_init.dart';
import 'package:skinsync_admin/models/free_system_plan_model.dart';
import 'package:skinsync_admin/models/invite_clinic_model.dart';
import 'package:skinsync_admin/models/subscription_plan_model.dart';
import 'package:skinsync_admin/screens/add_new_clinic_screen.dart';
import 'package:skinsync_admin/screens/appointment_detail_screen.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/appointment_management.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/clinic_management.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/dashboard_screen.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/home_page.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/patient_management.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/product_management.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/push_notification_screen.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/setting_screen.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/subscription_plans.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/user_management.dart';
import 'package:skinsync_admin/screens/clinic_detail_screen.dart';
import 'package:skinsync_admin/screens/create_subscription_plan_screen.dart';
import 'package:skinsync_admin/screens/create_treatment_screen.dart';
import 'package:skinsync_admin/screens/dispute_screen.dart';
import 'package:skinsync_admin/screens/edit_treatment_screen.dart';
import 'package:skinsync_admin/screens/invite_clinic_detail_screen.dart';
import 'package:skinsync_admin/screens/manage_treatment_data_screen.dart';
import 'package:skinsync_admin/screens/patient_detail_screen.dart';
import 'package:skinsync_admin/screens/payment_screen.dart';
import 'package:skinsync_admin/screens/product_detail_screen.dart';
import 'package:skinsync_admin/screens/sign_in_screen.dart';
import 'package:skinsync_admin/screens/splash_screen.dart';
import 'package:skinsync_admin/screens/treatment_detail_screen.dart';
import 'package:skinsync_admin/screens/treatment_management_screen.dart';

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
        name: SignInScreen.routeName,
        path: SignInScreen.routeName,
        builder: (context, state) => const SignInScreen(),
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
            name: InviteClinicDetailScreen.routeName,
            path: InviteClinicDetailScreen.routeName,
            builder: (context, state) => const InviteClinicDetailScreen(),
          ),
          GoRoute(
            name: ClinicDetailScreen.routeName,
            path: ClinicDetailScreen.routeName,
            builder: (context, state) => const ClinicDetailScreen(),
          ),
          GoRoute(
            name: AddNewClinicScreen.routeName,
            path: AddNewClinicScreen.routeName,
            builder: (context, state) => AddNewClinicScreen(invitedClinic: state.extra as InviteClinicModel?),
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
            name: TreatmentDetailScreen.routeName,
            path: TreatmentDetailScreen.routeName,
            builder: (_, _) => const TreatmentDetailScreen(),
          ),
          GoRoute(
            name: EditTreatmentScreen.routeName,
            path: EditTreatmentScreen.routeName,
            builder: (_, _) => const EditTreatmentScreen(),
          ),
          GoRoute(
            name: ManageTreatmentDataScreen.routeName,
            path: ManageTreatmentDataScreen.routeName,
            builder: (_, _) => const ManageTreatmentDataScreen(),
          ),
          GoRoute(
            name: CreateSubscriptionPlanScreen.routeName,
            path: CreateSubscriptionPlanScreen.routeName,
            builder: (context, state) {
              final extra = state.extra;
              if (extra is FreeSystemPlanModel) {
                return CreateSubscriptionPlanScreen(freePlanToEdit: extra);
              }
              return CreateSubscriptionPlanScreen(planToEdit: extra as SubscriptionPlanModel?);
            },
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
            name: SubscriptionPlansTab.routeName,
            path: SubscriptionPlansTab.routeName,
            builder: (_, _) => const SubscriptionPlansTab(),
          ),
          GoRoute(
            name: SettingScreen.routeName,
            path: SettingScreen.routeName,
            builder: (_, _) => const SettingScreen(),
          ),
          GoRoute(
            name: ProductDetailScreen.routeName,
            path: ProductDetailScreen.routeName,
            builder: (_, _) => const ProductDetailScreen(),
          ),
          GoRoute(
            name: AppointmentDetailScreen.routeName,
            path: AppointmentDetailScreen.routeName,
            builder: (_, _) => const AppointmentDetailScreen(),
          ),
          GoRoute(
            name: PatientDetailScreen.routeName,
            path: PatientDetailScreen.routeName,
            builder: (_, _) => const PatientDetailScreen(),
          ),
        ],
      ),
    ],
  );
}
