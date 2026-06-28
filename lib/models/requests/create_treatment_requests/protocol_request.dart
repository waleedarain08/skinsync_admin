import 'package:skinsync_admin/utils/enums.dart';

class ProtocolRequest {
  final int? stepNumber;
  final ClinicalProtocolPdf? clinicalProtocolPdf;

  ProtocolRequest({this.stepNumber, this.clinicalProtocolPdf});

  Map<String, dynamic> toJson() => {
    'keys': [CreateTreatmentSteps.protocols.name],
    'clinical_protocol_pdf': clinicalProtocolPdf?.toJson(),
  };
}

class ClinicalProtocolPdf {
  final String? name;
  final String? url;

  ClinicalProtocolPdf({this.name, this.url});

  Map<String, dynamic> toJson() => {"name": name, "url": url};
}
