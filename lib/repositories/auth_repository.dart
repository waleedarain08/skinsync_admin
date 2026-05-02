import 'package:skinsync_admin/models/responses/base_response_model.dart';

import '../models/requests/auth_req_models.dart';
import '../models/responses/login_response_model.dart';

abstract class AuthRepository {
  Future<LoginResponseModel> login({required LoginRequestModel req});
  Future<BaseApiResponseModel> forgotPassword({required String email});
  Future<String> verifyOtp({required String email, required String otp});
  Future<BaseApiResponseModel> reSendOtp({required String email});
  Future<BaseApiResponseModel> resetPassword({
    required ResetPasswordReqModel req,
  });
}
