import 'package:skinsync_admin/utils/enums.dart';

class AllowedProviderRolesRequest {
  final int stepNumber;
  final List<String>? allowedRoles;

  AllowedProviderRolesRequest({required this.stepNumber, this.allowedRoles});

  Map<String, dynamic> toJson() => {
    'step_number': stepNumber,
    'keys': [CreateTreatmentSteps.allowedProviderRoles.name],
    'allowed_roles': allowedRoles == null
        ? []
        : List<dynamic>.from(allowedRoles!.map((x) => x)),
  };
}
