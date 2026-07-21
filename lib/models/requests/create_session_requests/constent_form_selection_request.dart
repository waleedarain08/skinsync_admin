import 'package:skinsync_admin/utils/enums.dart';

class ConsentFormSelectionRequest {
  final int stepNumber;
  final PreTreatmentConsentForm? preTreatmentConsentForm;
  final bool isCatDefualt;

  ConsentFormSelectionRequest({
    required this.stepNumber,
    this.preTreatmentConsentForm,
    required this.isCatDefualt,
  });

  Map<String, dynamic> toJson() => {
    'step_number': stepNumber,
    'is_cat_default' : isCatDefualt,
    'keys': [CreateTreatmentSteps.patientConsent.name],
    'pre_treatment_consent_form': preTreatmentConsentForm?.toJson(),
  };
}

class PreTreatmentConsentForm {
  final String? name;
  final String? url;

  PreTreatmentConsentForm({this.name, this.url});

  Map<String, dynamic> toJson() => {'name': name, 'url': url};
}
