import 'package:skinsync_admin/utils/enums.dart';

class ConsentFormSelectionRequest {
  final PreTreatmentConsentForm? preTreatmentConsentForm;

  ConsentFormSelectionRequest({this.preTreatmentConsentForm});

  Map<String, dynamic> toJson() => {
    'keys': [CreateTreatmentSteps.patientConsent.name],
    'pre_treatment_consent_form': preTreatmentConsentForm?.toJson(),
  };
}

class PreTreatmentConsentForm {
  final String? name;
  final String? url;

  PreTreatmentConsentForm({this.name, this.url});

  Map<String, dynamic> toJson() => {"name": name, "url": url};
}
