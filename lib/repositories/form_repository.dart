import '../models/form_model.dart';
import '../models/responses/base_response_model.dart';
import '../models/responses/form_list_response.dart';

abstract class FormRepository {
  Future<FormListResponse> getForms(String type);
  Future<BaseApiResponseModel<dynamic>> createForm(FormModel form);
  Future<BaseApiResponseModel<dynamic>> deleteForm(int id);
}
