// ignore_for_file: unnecessary_this

import 'package:skinsync_admin/models/user_model.dart';

class LoginResponseModel {
  String? accessToken;
  String? refreshToken;
  int? accessExpiresAt;
  int? refreshExpiresAt;
  UserModel? user;

  LoginResponseModel({
    this.accessToken,
    this.refreshToken,
    this.accessExpiresAt,
    this.refreshExpiresAt,
    this.user,
  });

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    accessExpiresAt = json['access_expires_at'];
    refreshExpiresAt = json['refresh_expires_at'];
    user = json['admin_user'] != null
        ? UserModel.fromJson(json['admin_user'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = this.accessToken;
    data['refresh_token'] = this.refreshToken;
    data['access_expires_at'] = this.accessExpiresAt;
    data['refresh_expires_at'] = this.refreshExpiresAt;
    if (this.user != null) {
      data['admin_user'] = this.user!.toJson();
    }
    return data;
  }
}
