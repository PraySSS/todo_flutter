import 'dart:convert';
import 'dart:developer';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;

import '../model/creatuser_model.dart';

class signupController {
  Future<void> signup(String user_email, String user_password,
      String user_firstname, String user_lastname, BuildContext context) async {
    final header = {
      'Authorization': '[YOUR_AUTH]',
      'Content-Type': 'application/json'
    };
    final json = {
      "user_email": user_email,
      "user_password": user_password,
      "user_fname": user_firstname,
      "user_lname": user_lastname
    };

    try {
      final response = await http.post(
          Uri.parse('[YOUR_APIs]'),
          body: jsonEncode(json),
          headers: header);

      if (response.statusCode == 200) {
        Navigator.pop(context);

        final snackBar = SnackBar(
          backgroundColor: HexColor('#0D7A5C'),
          content: const Text(
            'Create account success',
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (response.statusCode == 400) {
        final snackBar = SnackBar(
          backgroundColor: HexColor('#ce2b37'),
          content: const Text(
            'This e-mail has already been used...',
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      final snackBar = SnackBar(
        backgroundColor: HexColor('#ce2b37'),
        content: const Text(
          'Some thing went wrong plese come back later',
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
