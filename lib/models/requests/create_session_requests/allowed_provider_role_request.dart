import 'package:skinsync_admin/utils/enums.dart';

class AllowedProviderRolesRequest {
  final List<String>? allowedRoles;

  AllowedProviderRolesRequest({this.allowedRoles});

  Map<String, dynamic> toJson() => {
    'step_number': 10,
    'keys': [CreateTreatmentSteps.allowedProviderRoles.name],
    'allowed_roles': allowedRoles == null
        ? []
        : List<dynamic>.from(allowedRoles!.map((x) => x)),
  };
}
