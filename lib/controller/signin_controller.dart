import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart ' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_pimpaka/screen/todolist_screen.dart';

import '../model/creatuser_model.dart';

class signinController {
  Future<void> signin(
      String user_email, String user_password, BuildContext context) async {
    //authen เข้าไปใช้ api จาก backend
    final header = {
      'Authorization': 'Bearer 950b88051dc87fe3fcb0b4df25eee676',
      'Content-Type': 'application/json'
    };

    final json = {
      "user_email": user_email,
      "user_password": user_password,
    };
//send path

    try {
      final response = await http.post(
          Uri.parse('http://bms.dyndns.tv:6004/api/login'),
          body: jsonEncode(json),
          headers: header);
      //Change body data to object แกะ json ให้เป็นข้อมูลที่สามารถอ่านได้
      final data = jsonDecode(response.body);
      //log(response.statusCode.toString());
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        //shared preferences เก็บค่าไว้ใน session ในเครื่อง
        //set ค่า data['user_id'] คือค่าที่เราดึงมาจาก rest api ให้กลายเป็น 'userId' โดยต้อง set ค่าที่จะส่งไปว่าเป็นค่าแบบไหนด้วย
        await prefs.setInt('userId', data['user_id']);
        await prefs.setString('userEmail', data['user_email']);
        await prefs.setString('userPassword', data['user_password']);
        //concat data ใส่กันได้เลย
        await prefs.setString(
            'fullname', data['user_fname'] + ' ' + data['user_lname']);
        //pushAndRemoveUntil ทำให้ user กลับไปหน้าเดิมไม่ได้

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => TodoListScreen()),
            (route) => false);
      } else if (response.statusCode == 400) {
        final snackBar = SnackBar(
          backgroundColor: HexColor('#ce2b37'),
          content: const Text(
            'Your Email or Password is invalid',
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
