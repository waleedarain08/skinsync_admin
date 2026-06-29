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
  getClinics('clinics'),
  registerClinic('admin/clinic/register'),
  updateClinic('admin/clinic/update/{id}'),
  updateCustomerAppVersion('admin/app-version/customer'),
  updateClinicAppVersion('admin/app-version/clinicapp'),
  subscriptionPlans('admin/subscription-plans'),
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
  treatmentDetail('admin/treatments/{id}'),
  updateTreatment('admin/treatments/update'),
  manufacturersList('admin/manufacturers'),
  suppliers('admin/suppliers'),
  productsStatus('admin/products/status'),
  treatmentsStatus('admin/treatments/status');

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

enum BaseUrls {
  api('https://api.skinsyncai.com/api/'),
  apiQa('https://api-qa.skinsyncai.com/api/');

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
  businessLogic('business_logic');

  final String name;

  const CreateTreatmentSteps(this.name);
}

enum TreatmentStatus {
  all('All'),
  active('Active'),
  inactive('InActive'),
  darft('Draft');

  final String name;

  const TreatmentStatus(this.name);
}

enum ProductStatus {
  all('All'),
  active('Active'),
  inactive('InActive');

  final String name;

  const ProductStatus(this.name);
}

// enum UsageType {
//   treatment,
//   retailer,
//   both;
// }

// void test() {
//   const type = UsageType.treatment;
//   log('API: ${type.name}');
//   log('DISPLAY: ${type.name.capitalize}');
// }
