import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/app_init.dart';
import 'package:skinsync_admin/models/clinic_subscription_plan_model.dart';
import 'package:skinsync_admin/models/patient_subscription_plan_model.dart';
import 'package:skinsync_admin/models/responses/invite_clinic_detail_response.dart';
import 'package:skinsync_admin/models/responses/product_detail_response.dart';
import 'package:skinsync_admin/screens/add_new_clinic_screen.dart';
import 'package:skinsync_admin/screens/appointment_detail_screen.dart';
import 'package:skinsync_admin/screens/booking_config_screen.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/appointment_management.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/clinic_management.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/dashboard_screen.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/explore_screen.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/home_page.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/patient_management.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/product_management.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/push_notification_screen.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/setting_screen.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/subscription_plans.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/treatment_management_screen.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/user_management.dart';
import 'package:skinsync_admin/screens/clinic_detail_screen.dart';
import 'package:skinsync_admin/screens/clinic_web_request_detail_screen.dart';
import 'package:skinsync_admin/screens/create_clinics_subscription_plan_screen.dart';
import 'package:skinsync_admin/screens/create_patient_subscription_plan_screen.dart';
import 'package:skinsync_admin/screens/create_product_screen.dart';
import 'package:skinsync_admin/screens/create_session_screen.dart';
import 'package:skinsync_admin/screens/create_treatment_screen.dart';
import 'package:skinsync_admin/screens/dispute_screen.dart';
import 'package:skinsync_admin/screens/founder_clinic_detail_screen.dart';
import 'package:skinsync_admin/screens/invite_clinic_detail_screen.dart';
import 'package:skinsync_admin/screens/manage_inventory_data_screen.dart';
import 'package:skinsync_admin/screens/manage_treatment_data_screen.dart';
import 'package:skinsync_admin/screens/patient_detail_screen.dart';
import 'package:skinsync_admin/screens/payment_screen.dart';
import 'package:skinsync_admin/screens/product_detail_screen.dart';
import 'package:skinsync_admin/screens/sign_in_screen.dart';
import 'package:skinsync_admin/screens/splash_screen.dart';
import 'package:skinsync_admin/screens/treatment_detail_screen.dart';

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
            name: ExploreScreen.routeName,
            path: ExploreScreen.routeName,
            builder: (_, _) => const ExploreScreen(),
          ),
          GoRoute(
            name: AppointmentManagement.routeName,
            path: AppointmentManagement.routeName,
            builder: (_, _) => const AppointmentManagement(),
          ),
          GoRoute(
            name: BookingConfigScreen.routeName,
            path: BookingConfigScreen.routeName,
            builder: (_, _) => const BookingConfigScreen(),
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
            name: ClinicWebRequestDetailScreen.routeName,
            path: ClinicWebRequestDetailScreen.routeName,
            builder: (context, state) => const ClinicWebRequestDetailScreen(),
          ),
          GoRoute(
            name: FounderClinicDetailScreen.routeName,
            path: FounderClinicDetailScreen.routeName,
            builder: (context, state) => const FounderClinicDetailScreen(),
          ),
          GoRoute(
            name: AddNewClinicScreen.routeName,
            path: AddNewClinicScreen.routeName,
            builder: (context, state) {
              final extra =
                  state.extra
                      as ({
                        InviteClinicDetailData? clinic,
                        bool onBoardClinic,
                      })?;

              return AddNewClinicScreen(
                invitedClinic: extra?.clinic,
                onBoardClinic: extra?.onBoardClinic ?? false,
              );
            },
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
            name: CreateSessionScreen.routeName,
            path: CreateSessionScreen.routeName,
            builder: (_, _) => const CreateSessionScreen(),
          ),
          GoRoute(
            name: TreatmentDetailScreen.routeName,
            path: TreatmentDetailScreen.routeName,
            builder: (_, _) => const TreatmentDetailScreen(),
          ),
          GoRoute(
            name: ManageTreatmentDataScreen.routeName,
            path: ManageTreatmentDataScreen.routeName,
            builder: (_, _) => const ManageTreatmentDataScreen(),
          ),
          GoRoute(
            name: CreateClinicsSubscriptionPlanScreen.routeName,
            path: CreateClinicsSubscriptionPlanScreen.routeName,
            builder: (context, state) {
              return CreateClinicsSubscriptionPlanScreen(
                planToEdit: state.extra as ClinicSubscriptionPlanModel?,
              );
            },
          ),
          GoRoute(
            name: CreatePatientSubscriptionPlanScreen.routeName,
            path: CreatePatientSubscriptionPlanScreen.routeName,
            builder: (context, state) {
              return CreatePatientSubscriptionPlanScreen(
                planToEdit: state.extra as PatientSubscriptionPlanModel?,
              );
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
            name: CreateProductScreen.routeName,
            path: CreateProductScreen.routeName,
            builder: (context, state) => CreateProductScreen(
              productToEdit: state.extra as ProductDetailModel?,
            ),
          ),
          GoRoute(
            name: ManageInventoryDataScreen.routeName,
            path: ManageInventoryDataScreen.routeName,
            builder: (_, _) => const ManageInventoryDataScreen(),
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
