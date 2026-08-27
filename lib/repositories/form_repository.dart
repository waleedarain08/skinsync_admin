import '../models/requests/create_form_request.dart';
import '../models/responses/base_response_model.dart';
import '../models/responses/form_list_response.dart';

abstract class FormRepository {
  Future<FormListResponse> getForms({required String type, int page = 1, int limit = 10});
  Future<FormListResponse> createForm(CreateFormRequest request);
  Future<BaseApiResponseModel<dynamic>> deleteForm(int id);
}
