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
  refreshToken('clinic/auth/refresh'),
  forgotPassword('admin/forgot-password'),
  // resendOtp('admin/reset-password'),
  verifyResetOtp('admin/verify-reset-otp'),
  resetPassword('admin/reset-password'),
  //products
  products('admin/products'),
  updateProduct('admin/products/{id}'),
  //clinics
  getClinics('clinics'),
  registerClinic('admin/clinic/register'),
  updateClinic('admin/clinic/update/{id}'),
  updateCustomerAppVersion('admin/app-version/customer'),
  updateClinicAppVersion('admin/app-version/clinicapp'),
  subscriptionPlans('admin/subscription-plans'),
  categories('admin/categories'),
  categoryDetail('admin/categories/{id}'),
  createCategory('admin/categories');

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
  // api('http://3.128.27.193/api/');
  api('https://api.skinsyncai.com/api/'),
  apiQa('https://api-qa.skinsyncai.com/api/');
  // api('https://s21hn0m8-8084.asse.devtunnels.ms/api/');

  final String url;

  const BaseUrls(this.url);
}
