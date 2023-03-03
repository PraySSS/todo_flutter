// To parse this JSON data, do
//
//     final loginUser = loginUserFromJson(jsonString);

import 'dart:convert';

LoginUser loginUserFromJson(String str) => LoginUser.fromJson(json.decode(str));

String loginUserToJson(LoginUser data) => json.encode(data.toJson());

class LoginUser {
  LoginUser({
    required this.userEmail,
    required this.userPassword,
  });

  String userEmail;
  String userPassword;

  factory LoginUser.fromJson(Map<String, dynamic> json) => LoginUser(
        userEmail: json["user_email"],
        userPassword: json["user_password"],
      );

  Map<String, dynamic> toJson() => {
        "user_email": userEmail,
        "user_password": userPassword,
      };
}
