import 'package:skinsync_admin/utils/enums.dart';

class PostTreatmentInstructionsRequest {
  final String? postTreatmentInstructions;
  final List<PostTreatmentAttachment>? postTreatmentAttachments;

  PostTreatmentInstructionsRequest({
    this.postTreatmentInstructions,
    this.postTreatmentAttachments,
  });

  Map<String, dynamic> toJson() => {
    'keys': [CreateTreatmentSteps.postTreatmentInstructions.name],
    'post_treatment_instructions': postTreatmentInstructions,
    'post_treatment_attachments': postTreatmentAttachments == null
        ? []
        : List<dynamic>.from(postTreatmentAttachments!.map((x) => x.toJson())),
  };
}

class PostTreatmentAttachment {
  final String? name;
  final String? url;
  final String? type;

  PostTreatmentAttachment({this.name, this.url, this.type});

  Map<String, dynamic> toJson() => {"name": name, "url": url, "type": type};
}
