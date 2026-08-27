import 'package:skinsync_admin/models/form_model.dart';
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
  Future<FormListResponse> getForms(String type) async {
    final jsonResponse = await _api.get(
      Endpoint.forms,
      queryParams: {'type': type},
    ) as Map<String, dynamic>;
    final response = FormListResponse.fromJson(jsonResponse);
    if (!response.isSuccess) throw BadRequestException(response.message);
    return response;
  }

  @override
  Future<BaseApiResponseModel<dynamic>> createForm(FormModel form) async {
    final jsonResponse = await _api.post(
      Endpoint.forms,
      body: form.toJson(),
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
