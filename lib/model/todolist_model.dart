// To parse this JSON data, do
//
//     final todoList = todoListFromJson(jsonString);

import 'dart:convert';

TodoList todoListFromJson(String str) => TodoList.fromJson(json.decode(str));

String todoListToJson(TodoList data) => json.encode(data.toJson());

class TodoList {
  TodoList({
    required this.userTodoListId,
    required this.userTodoListTitle,
    required this.userTodoListDesc,
    required this.userTodoListCompleted,
    required this.userTodoListLastUpdate,
    required this.userId,
  });

  int userTodoListId;
  String userTodoListTitle;
  String userTodoListDesc;
  String userTodoListCompleted;
  DateTime userTodoListLastUpdate;
  int userId;

  factory TodoList.fromJson(Map<String, dynamic> json) => TodoList(
        userTodoListId: json["user_todo_list_id"],
        userTodoListTitle: json["user_todo_list_title"],
        userTodoListDesc: json["user_todo_list_desc"],
        userTodoListCompleted: json["user_todo_list_completed"],
        userTodoListLastUpdate:
            DateTime.parse(json["user_todo_list_last_update"]),
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "user_todo_list_id": userTodoListId,
        "user_todo_list_title": userTodoListTitle,
        "user_todo_list_desc": userTodoListDesc,
        "user_todo_list_completed": userTodoListCompleted,
        "user_todo_list_last_update": userTodoListLastUpdate.toIso8601String(),
        "user_id": userId,
      };
}
