import 'package:skinsync_admin/models/requests/update_form_request.dart';
import 'package:skinsync_admin/utils/enums.dart';

import '../models/requests/create_form_request.dart';
import '../models/responses/base_response_model.dart';
import '../models/responses/form_list_response.dart';

abstract class FormRepository {
  Future<FormListResponse> getForms({required String type, int page = 1, int limit = 10});
   Future<BaseApiResponseModel<dynamic>> updateFormsStatus({required Status status, required int id});
  Future<BaseApiResponseModel<dynamic>> createForm(CreateFormRequest request);
  Future<BaseApiResponseModel<dynamic>> updateForm(UpdateFormRequest request,int id);
  Future<BaseApiResponseModel<dynamic>> deleteForm(int id);
}
