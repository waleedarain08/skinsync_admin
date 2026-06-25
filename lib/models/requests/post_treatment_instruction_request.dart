class PostTreatmentInstructionsRequest {
  final int? stepNumber;
  final String? postTreatmentInstructions;
  final List<PostTreatmentAttachment>? postTreatmentAttachments;

  PostTreatmentInstructionsRequest({
    this.stepNumber,
    this.postTreatmentInstructions,
    this.postTreatmentAttachments,
  });

  Map<String, dynamic> toJson() => {
    "step_number": stepNumber,
    "post_treatment_instructions": postTreatmentInstructions,
    "post_treatment_attachments": postTreatmentAttachments == null
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
