import 'package:skinsync_admin/models/role.dart';

class UserModel {
  int? id;
  String? email;
  String? name;
  int? roleId;
  RoleModel? role;
  String? status;
  String? lastLogin;
  String? createdAt;
  String? updatedAt;

  UserModel({
    this.id,
    this.email,
    this.name,
    this.roleId,
    this.role,
    this.status,
    this.lastLogin,
    this.createdAt,
    this.updatedAt,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    roleId = json['role_id'];
    role = json['role'] != null ? new RoleModel.fromJson(json['role']) : null;
    status = json['status'];
    lastLogin = json['last_login'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['name'] = this.name;
    data['role_id'] = this.roleId;
    if (this.role != null) {
      data['role'] = this.role!.toJson();
    }
    data['status'] = this.status;
    data['last_login'] = this.lastLogin;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
