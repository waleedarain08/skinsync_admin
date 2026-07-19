import 'package:skinsync_admin/models/responses/provider_roles_response.dart';
import 'package:skinsync_admin/repositories/provider_role_repository.dart';
import 'package:skinsync_admin/services/api_base_helper.dart';
import 'package:skinsync_admin/utils/enums.dart';
import 'package:skinsync_admin/utils/exception.dart';

class ProviderRolesService implements ProviderRoleRepository {
  final ApiBaseHelper _api;

  ProviderRolesService({required ApiBaseHelper api}) : _api = api;

  @override
  Future<ProviderRolesResponse> providerRoles() async {
    final jsonResponse = await _api.get(Endpoint.providerRoles);
    final response = ProviderRolesResponse.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }
}
