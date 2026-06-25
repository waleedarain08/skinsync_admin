class AllowedProviderRolesRequest {
  final int? stepNumber;
  final List<String>? allowedRoles;

  AllowedProviderRolesRequest({this.stepNumber, this.allowedRoles});

  Map<String, dynamic> toJson() => {
    "step_number": stepNumber,
    "allowed_roles": allowedRoles == null
        ? []
        : List<dynamic>.from(allowedRoles!.map((x) => x)),
  };
}
