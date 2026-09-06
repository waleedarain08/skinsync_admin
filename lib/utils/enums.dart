import 'package:skinsync_admin/utils/string_utils.dart';

enum SharedPreferencesKeys {
  themeModeKey('theme-mode'),
  accessTokenKey('access-token'),
  refreshTokenKey('refresh-token'),
  accessTokenExpiryKey('access-token-expiry'),
  refreshTokenExpiryKey('refresh-token-expiry'),
  userKey('user-key');

  const SharedPreferencesKeys(this.keyText);

  final String keyText;
}

enum DoctorRole { doctor, injector }

enum AuthScreen { login, forgetPassword, verifyOtp, createNewPassword }

enum Endpoint {
  // auth
  login('admin/login'),
  refreshToken('admin/auth/refresh'),
  forgotPassword('admin/forgot-password'),
  // resendOtp('admin/reset-password'),
  verifyResetOtp('admin/verify-reset-otp'),
  resetPassword('admin/reset-password'),
  //products
  products('admin/products'),
  updateProduct('admin/products/{id}'),
  deleteProduct('admin/products/{id}'),

  //clinics
  getClinics('admin/cliniclist'),
  registerClinic('admin/clinic/register'),
  updateClinic('admin/clinic/update'),
  updateClinicStatus('admin/clinic/update-status/{id}'),
  updateAppVersion('admin/app-version'),
  subscriptionPlans('admin/patient-subscription-plans'),
  updateSubscriptionPlan('admin/subscription-plans/{id}'),
  deleteSubscriptionPlan('admin/subscription-plans/{id}'),
  patientPlans('admin/patient-subscription-plans'),
  updatePatientSubscriptionPlan('admin/patient-subscription-plans/{id}'),
  deletePatientSubscriptionPlan('admin/patient-subscription-plans/{id}'),
  categories('admin/categories'),
  categoryDetail('admin/categories/{id}'),
  createCategory('admin/categories'),
  areas('admin/areas'),
  subAreas('admin/areas/sub'),
  productsByTreatmentId('admin/products/by-treatment'),
  basicInfo('admin/treatments/create'),
  getBrands('admin/brands'),
  unitTypesList('admin/unit-types'),
  packageTypeList('admin/package-types'),
  usageType('admin/usage-types'),
  treatmentArea('admin/treatments/step'),
  adminTreatments('admin/treatments/list'),
  createSession('admin/sessions'),
  sessionsList('admin/sessions/list'),
  treatmentDetail('admin/treatments/{id}'),
  updateTreatment('admin/treatments/update'),
  manufacturersList('admin/manufacturers'),
  suppliers('admin/suppliers'),
  productsStatus('admin/products/status'),
  sessionUpdate('admin/sessions/update'),
  sessionDetail('admin/sessions/{id}'),
  deleteSession('admin/sessions/{id}'),
  inviteClinics('admin/invite-clinics'),
  sendInvitation('admin/invite-clinics/send-invitation'),
  clinicDetail('admin/clinic/detail'),
  inviteClinicDetail('admin/invite-clinics/detail'),
  updateCategory('admin/categories/{id}'),
  updateAreas('admin/areas/{id}'),
  sessionStatus('admin/sessions/status'),
  providerRoles('admin/provider-roles'),
  treatmentsStatus('admin/treatments/status'),
  bookingMethods('admin/booking-methods'),
  updateBookingMethod('admin/booking-methods/{id}'),
  appointmentTypes('admin/appointment-types'),
  updateAppointmentType('admin/appointment-types/{id}'),
  appointmentTimings('admin/appointment-timings'),
  downTimeLevel('admin/treatments/{id}/downtime-presets'),
  explorerReels('admin/reels'),
  updateReel('admin/reels/{id}'),
  explorerCommunity('admin/community-posts'),
  updatePost('admin/community-posts/{id}'),
  postCategories('admin/community-post/categories'),
  webRequests('admin/clinic-web-regiteration'),
  webRequestDetail('admin/clinic-web-registration/detail/{id}'),
  sendWebRequestNotes('admin/web-requests/{id}/notes'),
  founderClinics('admin/founder-clinic'),
  patients('admin/patients'),
  patientDetail('admin/patients/{id}'),
  patientTreatmentRequest('admin/patient-treatment-request'),
  updatePatientStatus('admin/patient/status/{id}'),
  founderClinicDetail('admin/founder-clinic/detail/{id}'),
  deductionTimings('admin/deduction-timings'),
  subscriptionDurations('admin/subscription-durations'),
  benefits('admin/benefits'),
  forms('admin/forms'),
  updateForm('admin/forms/{id}'),
  notification('admin/notifications'),
  deleteForm('admin/forms/{id}'),
  protocolFields('admin/protocol_fields');

  final String path;
  const Endpoint(this.path);

  String withParams(Map<String, String> params) {
    var updatedPath = path;
    params.forEach((key, value) {
      updatedPath = updatedPath.replaceAll('{$key}', value);
    });
    return updatedPath;
  }
}

enum Status { active, inactive }

enum BaseUrls {
  api('https://api.skinsyncai.com/api/'),
  // apiQa('https://api-dev.skinsyncai.com/api/');
  apiQa('http://localhost:8084/api/');

  // apiQa('https://bgzh46mj-8084.inc1.devtunnels.ms/api/');

  final String url;

  const BaseUrls(this.url);
}

enum CreateTreatmentSteps {
  allowedProviderRoles('allowed_provider_roles'),
  patientConsent('patient_consent'),
  phaseNotifications('phase_notifications'),
  postTreatmentInstructions('post_treatment_instructions'),
  preTreatmentInstructions('pre_treatment_instructions'),
  inventoryProducts('inventory_products'),
  protocols('protocols'),
  sessionsSetup('sessions_setup'),
  pricing('pricing'),
  categories('categories'),
  treatmentAreas('treatment_areas'),
  scheduling('scheduling'),
  postTreatmentPhotos('post_treatment_photos'),
  downtimeLevel('downtime_level'),
  followUpSetup('follow_up_setup'),
  businessLogic('business_logic'),
  basicInfo('basic_info'),
  status('status');

  final String name;

  const CreateTreatmentSteps(this.name);
}

enum TreatmentStatus {
  all('All'),
  active('Active'),
  inactive('In Active'),
  draft('Draft');

  final String label;

  const TreatmentStatus(this.label);
}

enum ProductStatus {
  all('All'),
  active('Active'),
  inactive('In Active');

  final String label;

  const ProductStatus(this.label);
}

enum PatientStatus {
  all('All'),
  active('Active'),
  inactive('In Active'),
  New('New'),
  archived('Archived');

  final String label;

  const PatientStatus(this.label);
}

enum PlanInterval {
  week,
  month,
  year;

  String get label {
    return name.capitalize;
  }
}
