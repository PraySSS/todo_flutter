import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hexcolor/hexcolor.dart';
import '../model/creatuser_model.dart';
import '../model/todolist_model.dart';

class todolistController {
  //สร้าง array มารับ data
  //
  final header = {
    'Authorization': '[YOUR_AUTH]',
    'Content-Type': 'application/json'
  };
  List<TodoList> dataList = [];
  Future<List<TodoList>> getTodoList() async {
    dataList.clear();
    final prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('userId');

    final response = await http.get(
      Uri.parse('[YOUR_APIs]'),
      headers: header,
    );

    final data = jsonDecode(response.body);
    for (var index in data) {
      dataList.add(TodoList.fromJson(index));
    }
    return dataList;
  }

  Future<void> deleteById(int todoListId) async {
    final response = await http.delete(
        Uri.parse('[YOUR_APIs]${todoListId}'),
        headers: header);
  }
}
