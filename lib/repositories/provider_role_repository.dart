import 'package:skinsync_admin/models/responses/provider_roles_response.dart';

abstract class ProviderRoleRepository {
  Future<ProviderRolesResponse> providerRoles();
}