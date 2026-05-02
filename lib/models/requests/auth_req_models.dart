class LoginRequestModel {
  final String email;
  final String password;

  LoginRequestModel({required this.email, required this.password});

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel(
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}

class ResetPasswordReqModel {
  final String? email;
  final String? resetToken;
  final String? newPassword;

  ResetPasswordReqModel({
    required this.email,
    required this.resetToken,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'reset_token': resetToken,
      'new_password': newPassword,
    };
  }

  ResetPasswordReqModel copyWith({
    String? email,
    String? resetToken,
    String? newPassword,
  }) {
    return ResetPasswordReqModel(
      email: email ?? this.email,
      resetToken: resetToken ?? this.resetToken,
      newPassword: newPassword ?? this.newPassword,
    );
  }
}
