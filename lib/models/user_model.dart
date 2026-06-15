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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      roleId: json['role_id'],
      role: json['role'] != null ? RoleModel.fromJson(json['role']) : null,
      status: json['status'],
      lastLogin: json['last_login'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['role_id'] = roleId;
    if (role != null) {
      data['role'] = role!.toJson();
    }
    data['status'] = status;
    data['last_login'] = lastLogin;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
