class ConsentFormSelectionRequest {
  final int? stepNumber;
  final PreTreatmentConsentForm? preTreatmentConsentForm;

  ConsentFormSelectionRequest({this.stepNumber, this.preTreatmentConsentForm});

  Map<String, dynamic> toJson() => {
    "step_number": stepNumber,
    "pre_treatment_consent_form": preTreatmentConsentForm?.toJson(),
  };
}

class PreTreatmentConsentForm {
  final String? name;
  final String? url;

  PreTreatmentConsentForm({this.name, this.url});

  Map<String, dynamic> toJson() => {"name": name, "url": url};
}
