enum SharedPreferencesKeys {
  themeModeKey("theme-mode"),
  accessTokenKey("access-token"),
  userKey('user-key');

  const SharedPreferencesKeys(this.keyText);

  final String keyText;
}

enum DoctorRole { doctor, injector }

enum Endpoint {
  login('admin/login'),
  // getAdminTreatmentsSideAreas('clinic/side-areas/treatment/{treatmentId}'),
  //clinics
  getClinics('clinics'),
  registerClinic('admin/clinic/register');

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
  api('https://api.skinsyncai.com/api/');
  // api('https://s21hn0m8-8084.asse.devtunnels.ms/api/');

  final String url;

  const BaseUrls(this.url);
}
