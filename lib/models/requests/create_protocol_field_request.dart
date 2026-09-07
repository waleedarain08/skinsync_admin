import 'package:skinsync_admin/models/treatment_data_models.dart';

class CreateProtocolFieldRequest {
  final String title;
  final ProtocolType type;

  CreateProtocolFieldRequest({
    required this.title,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type.value,
    };
  }
}
