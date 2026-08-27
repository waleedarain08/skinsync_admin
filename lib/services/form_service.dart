import 'package:skinsync_admin/models/requests/create_form_request.dart';
import 'package:skinsync_admin/models/responses/base_response_model.dart';
import 'package:skinsync_admin/models/responses/form_list_response.dart';
import 'package:skinsync_admin/repositories/form_repository.dart';
import 'package:skinsync_admin/services/api_base_helper.dart';
import 'package:skinsync_admin/utils/enums.dart';
import 'package:skinsync_admin/utils/exception.dart';

class FormService implements FormRepository {
  final ApiBaseHelper _api;

  FormService({required ApiBaseHelper api}) : _api = api;

  @override
  Future<FormListResponse> getForms({
    required String type,
    int page = 1,
    int limit = 10,
  }) async {
    final jsonResponse = await _api.get(
      Endpoint.forms,
      queryParams: {
        'type': type,
        'page': page.toString(),
        'limit': limit.toString(),
      },
    ) as Map<String, dynamic>;
    final response = FormListResponse.fromJson(jsonResponse);
    if (!response.isSuccess) throw BadRequestException(response.message);
    return response;
  }

  @override
  Future<BaseApiResponseModel<dynamic>> createForm(CreateFormRequest request) async {
    final jsonResponse = await _api.post(
      Endpoint.forms,
      body: request.toJson(),
    );
    final response = BaseApiResponseModel<dynamic>.fromJson(jsonResponse);
    if (!response.isSuccess) throw BadRequestException(response.message);
    return response;
  }

  @override
  Future<BaseApiResponseModel<dynamic>> deleteForm(int id) async {
    final jsonResponse = await _api.delete(
      Endpoint.deleteForm,
      pathParams: {'id': id.toString()},
    ) as Map<String, dynamic>;
    final response = BaseApiResponseModel<dynamic>.fromJson(jsonResponse);
    if (!response.isSuccess) throw BadRequestException(response.message);
    return response;
  }
}
