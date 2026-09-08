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

  factory ProtocolRequest.fromJson(Map<String, dynamic> json) {
    return ProtocolRequest(
      stepNumber: json['step_number'] ?? 0,
      protocols: json['protocols'] != null
          ? List<ProtocolRequestItem>.from(
              json['protocols'].map(
                (x) => ProtocolRequestItem.fromJson(x),
              ),
            )
          : null,
      instrictions: json['instructions'] != null
          ? List<ProtocolInstructionItem>.from(
              json['instructions'].map(
                (x) => ProtocolInstructionItem.fromJson(x),
              ),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'step_number': stepNumber,
        'keys': [CreateTreatmentSteps.protocols.name],
        'protocols': protocols == null
            ? <dynamic>[]
            : List<dynamic>.from(
                protocols!.map((x) => x.toJson()),
              ),
        'instructions': instrictions == null
            ? <dynamic>[]
            : List<dynamic>.from(
                instrictions!.map((x) => x.toJson()),
              ),
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

  factory ProtocolRequestItem.fromJson(Map<String, dynamic> json) {
    return ProtocolRequestItem(
      fieldId: json['field_id'],
      title: json['title'],
      note: json['note'],
    );
  }

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

  factory ProtocolInstructionItem.fromJson(Map<String, dynamic> json) {
    return ProtocolInstructionItem(
      title: json['title'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'note': note,
      };
}