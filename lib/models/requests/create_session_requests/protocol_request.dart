import 'package:skinsync_admin/utils/enums.dart';

class ProtocolRequest {
  final int stepNumber;
  final List<ProtocolRequestItem>? protocols;
  final List<ProtocolInstructionItem>? instrictions;

  ProtocolRequest({
    required this.stepNumber,
    this.protocols,
    this.instrictions,
  });

  Map<String, dynamic> toJson() => {
    'step_number': stepNumber,
    'keys': [CreateTreatmentSteps.protocols.name],
    'protocols': protocols == null
        ? <dynamic>[]
        : List<dynamic>.from(protocols!.map((x) => x.toJson())),
    'instrictions': instrictions == null
        ? <dynamic>[]
        : List<dynamic>.from(instrictions!.map((x) => x.toJson())),
  };
}

class ProtocolRequestItem {
  final int? fieldId;
  final String? title;
  final String? note;

  ProtocolRequestItem({
    this.fieldId,
    this.title,
    this.note,
  });

  Map<String, dynamic> toJson() => {
    'field_id': fieldId,
    'title': title,
    'note': note,
  };
}

class ProtocolInstructionItem {
  final String? title;
  final String? note;

  ProtocolInstructionItem({
    this.title,
    this.note,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'note': note,
  };
}
