import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:todo_pimpaka/controller/todo_controller.dart';
import 'package:todo_pimpaka/model/todolist_model.dart';
import 'package:todo_pimpaka/widget/button_widget.dart';
import 'package:todo_pimpaka/widget/textfield_widget.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key, this.dataList});
  //เอาไว้รับก้อนข้อมูล
  final TodoList? dataList;

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  TextEditingController todo_title = TextEditingController();
  TextEditingController todo_description = TextEditingController();
  TextEditingController is_completed = TextEditingController();
  late int todo_id;
  //switch value default to false
  bool is_success = false;
  final _formkey = GlobalKey<FormState>();
  //ทำก่อนครั้งแรกและครั้งเดียวที่เปิดหน้านี้ขึ้นมา
  void initState() {
    // ถ้ามีข้อมูลอยู่จะ setState ให้ fill textField ไว้
    //จะดึงข้อมูลมาก่อนถึงลงไปรัน Build หน้า Todoขึ้นมา
    if (widget.dataList != null) {
      setState(() {
        //ใส่ .text เพราะ TextEditingController ต้องการทราบค่า
        todo_title.text = widget.dataList!.userTodoListTitle.toString();
        todo_description.text = widget.dataList!.userTodoListDesc.toString();
        is_completed.text = widget.dataList!.userTodoListCompleted.toString();
        todo_id = widget.dataList!.userTodoListId.toInt();
        is_success = is_completed.text == 'true' ? true : false;
      });
    }

    super.initState();
  }

  void addTodoItem() async {
    var addItem = await todoController()
        .addTodo(todo_title.text, todo_description.text, is_success, context);
    Navigator.pop(context);
  }

  void updateTodoItem() async {
    var updateItem = await todoController().updateTodo(
        todo_id, todo_title.text, todo_description.text, is_success, context);
    Navigator.pop(context);
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: SizedBox(
              child: IconButton(
                iconSize: 35,
                color: HexColor('##FFFFFF'),
                icon: ImageIcon(Svg('assets/icons/back.svg')),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            title:
                Text(widget.dataList != null ? 'Your Todo' : 'Add Your Todo'),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    HexColor('#4CC599'),
                    HexColor('#0D7A5C'),
                  ],
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  TextFieldWidget(
                    controller: todo_title,
                    text: 'Title',
                    obscureText: false,
                    maxLineTextField: 1,
                    horizontalSize: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFieldWidget(
                      controller: todo_description,
                      text: 'Description',
                      obscureText: false,
                      maxLineTextField: 7,
                      textFieldHeight: 170,
                      horizontalSize: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 0),
                            spreadRadius: -1,
                            blurRadius: 12,
                            color: Color.fromRGBO(155, 155, 155, 0.73),
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Success',
                              style: TextStyle(
                                  fontSize: 16, color: HexColor('#0D7A5C')),
                            ),
                            //Switch button
                            CupertinoSwitch(
                              // This bool value toggles the switch.
                              value: is_success,
                              activeColor: HexColor('#0D7A5C'),
                              onChanged: (value) {
                                setState(() {
                                  is_success = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 20, right: 20),
                    child: ButtonWidget(
                      textButton: widget.dataList != null ? 'Update' : 'Save',
                      press: () {
                        if (_formkey.currentState!.validate()) {
                          if (widget.dataList != null) {
                            updateTodoItem();
                          } else {
                            addTodoItem();
                          }
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
