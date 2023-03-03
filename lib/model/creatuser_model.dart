// To parse this JSON data, do
//
//     final createUser = createUserFromJson(jsonString);

import 'dart:convert';

CreateUser createUserFromJson(String str) =>
    CreateUser.fromJson(json.decode(str));

String createUserToJson(CreateUser data) => json.encode(data.toJson());

class CreateUser {
  CreateUser({
    required this.userId,
    required this.userEmail,
    required this.userPassword,
    required this.userFname,
    required this.userLname,
  });

  int userId;
  String userEmail;
  String userPassword;
  String userFname;
  String userLname;

  factory CreateUser.fromJson(Map<String, dynamic> json) => CreateUser(
        userId: json["user_id"],
        userEmail: json["user_email"],
        userPassword: json["user_password"],
        userFname: json["user_fname"],
        userLname: json["user_lname"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_email": userEmail,
        "user_password": userPassword,
        "user_fname": userFname,
        "user_lname": userLname,
      };
}
