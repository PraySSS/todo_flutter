import 'dart:convert';
import 'dart:developer';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;
import 'package:shared_preferences/shared_preferences.dart';

class todoController {
  //ประกาศ header ส่ง token เพื่อเข้าถึง backend
  final header = {
    'Authorization': '[YOUR_AUTH]',
    'Content-Type': 'application/json'
  };
  Future<void> addTodo(String todo_title, String todo_description,
      bool is_success, BuildContext context) async {
    //Shared preferrence ดึงข้อมูลมาจากก้อน api ทีละตัว
    final prefs = await SharedPreferences.getInstance();
    final int? send_user_id = prefs.getInt('userId');
    //ค่าที่เราจะส่งลง Database
    final json = {
      "user_id": send_user_id,
      "user_todo_list_title": todo_title,
      "user_todo_list_desc": todo_description,
      //ใส่ tostring เพราะตอนแรกค่าที่ส่งไปเป็น 01 ไม่ใช่ true false
      "user_todo_list_completed": is_success.toString()
    };
    try {
      //ส่งข้อมูลผ่านตัว response
      final response = await http.post(
          Uri.parse('[YOUR_APIs]'),
          //Encode แปลงค่าที่จะส่งไปให้ json อ่านได้
          body: jsonEncode(json),
          //ส่ง Token เข้าไปด้วย
          headers: header);
      //ถ้าส่งเข้าสำเร็จ status code คือ 200 จะเข้าไปทำต่อใน if
      if (response.statusCode == 200) {
        final snackBar = SnackBar(
          backgroundColor: HexColor('#0D7A5C'),
          content: const Text(
            'Add Success',
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (response.statusCode == 400) {
        final snackBar = SnackBar(
          backgroundColor: HexColor('#ce2b37'),
          content: const Text(
            'Some thing went wrong plese come back later',
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

  /* Future<void> updateTodo(String update_Todo,String update) */
  Future<void> updateTodo(int todo_id, String todo_title,
      String todo_description, bool is_success, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final int? send_user_id = prefs.getInt('userId');
    final json = {
      "user_id": send_user_id,
      "user_todo_list_title": todo_title,
      "user_todo_list_desc": todo_description,
      "user_todo_list_completed": is_success.toString(),
      "user_todo_list_id": todo_id,
    };
    try {
      final response = await http.post(
          Uri.parse('http://bms.dyndns.tv:6004/api/update_todo'),
          body: jsonEncode(json),
          headers: header);
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        final snackBar = SnackBar(
          backgroundColor: HexColor('#0D7A5C'),
          content: const Text(
            'Update Success',
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (response.statusCode == 400) {
        final snackBar = SnackBar(
          backgroundColor: HexColor('#ce2b37'),
          content: const Text(
            'Some thing went wrong plese come back later',
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
