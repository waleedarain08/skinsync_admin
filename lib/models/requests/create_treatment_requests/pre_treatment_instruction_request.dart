import 'package:skinsync_admin/utils/enums.dart';

class PreTreatmentInstructionsRequest {
  final String? preTreatmentInstructions;
  final List<PreTreatmentAttachment>? preTreatmentAttachments;

  PreTreatmentInstructionsRequest({
    this.preTreatmentInstructions,
    this.preTreatmentAttachments,
  });

  Map<String, dynamic> toJson() => {
    'keys': [CreateTreatmentSteps.preTreatmentInstructions.name],
    'pre_treatment_instructions': preTreatmentInstructions,
    'pre_treatment_attachments': preTreatmentAttachments == null
        ? []
        : List<dynamic>.from(preTreatmentAttachments!.map((x) => x.toJson())),
  };
}

class PreTreatmentAttachment {
  final String? name;
  final String? url;
  final String? type;

  PreTreatmentAttachment({this.name, this.url, this.type});

  Map<String, dynamic> toJson() => {"name": name, "url": url, "type": type};
}
