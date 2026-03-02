import '../models/requests/login_request_model.dart';
import '../models/responses/login_response_model.dart';

abstract class AuthRepository {
  Future<LoginResponseModel> login({required LoginRequestModel req});
}
