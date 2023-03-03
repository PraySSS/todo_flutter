import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_pimpaka/screen/signin_screen.dart';
import 'package:todo_pimpaka/screen/todo_screen.dart';
import 'package:todo_pimpaka/widget/bottomsheet_item_widget.dart';
import 'package:http/http.dart ' as http;
import '../controller/todolist_controller.dart';
import '../model/creatuser_model.dart';
import '../model/todolist_model.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({
    super.key,
  });
  // final CreateUser user;
  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  @override
  String search = '';
  String fullName = '';

  void initState() {
    // TODO: implement initState

    getfullname();

    super.initState();
  }

  todolistController _todoListController = todolistController();

  // h hours in am/pm m minutes in hours a am/pm marker d day M num month y year
  DateFormat datetime = DateFormat('hh:mm a - dd/MM/yyyy');

  //ส่งข้อมูล getTodoList มาทั้งก้อน
  Future<List<TodoList>> getDataList() {
    //Call list
    var getList = _todoListController.getTodoList();
    return getList;
  }

//ดึงชื่อมาจาก SharedPreferences
  void getfullname() async {
    final prefs = await SharedPreferences.getInstance();
    final getfullname = prefs.getString('fullname')!;

    //ต้อง setState ค่าถึงเข้าไปเก็บก่อนทำงาน
    setState(() {
      fullName = getfullname;
    });
  }

  Future<void> deleteById(int todoListId) async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text(
          'Do you want to delete this list? \n This process cannot be undone.',
          textAlign: TextAlign.center,
        ),
        actions: [
          //ปุ่ม x ไม่ delete
          IconButton(
              onPressed: () {
                //pop showDialog ออก
                Navigator.pop(context);
                //ต่มา pop bottomSheet ออก
                Navigator.pop(context);
              },
              icon: Icon(Icons.close_rounded)),
          //ปุ่ม ✓ เพื่อ confirm การ delete
          IconButton(
              onPressed: () async {
                var delete = await _todoListController
                    .deleteById(todoListId)
                    .then((value) => setState(
                          // after setstate ,the build section is rerun
                          () {},
                        ));
                Navigator.pop(context);
                Navigator.pop(context);
                // return todoList.clear();
              },
              icon: Icon(Icons.check))
        ],
      ),
    ));
  }

//clear SharedPreferences และออกจากแอพ
  Future<void> signout() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure'),
        content: Text(
          'Do you want to sign out? ',
          textAlign: TextAlign.center,
        ),
        actions: [
          //x
          IconButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              icon: Icon(Icons.close_rounded)),
          //✓
          IconButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.clear();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SigninScreen()),
                    (route) => false);
                // return todoList.clear();
              },
              icon: Icon(Icons.check))
        ],
      ),
    ));
  }

//detect user swipe screen
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), //<-- SEE HERE
                child: new Text(
                  'No',
                  style: TextStyle(color: HexColor("#0D7A5C")),
                ),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                // Navigator.of(context).po // <-- SEE HERE
                child: new Text(
                  'Yes',
                  style: TextStyle(
                    color: HexColor("#0D7A5C"),
                  ),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

//setstate จะมาเริ่มที่ตรงนี้ที่เริ่ม build
  Widget build(BuildContext context) {
    print('build');
    return WillPopScope(
      onWillPop: _onWillPop,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              //ปิดตัว Back icon ไม่ให้ขึ้นมา Auto
              automaticallyImplyLeading: false,
              //เพื่อเปลี่ยนสี Appbar แบบ linear gardient
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  //การไล่ระดับสีจากสีที่กำหนด
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
              leading: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Container(
                  child: InkWell(
                    child: CircleAvatar(
                      backgroundColor: HexColor('#FBFBFB'),
                      child: Text(
                        //ดึง index ที่ 0 มาและตัดด้านหลังออกตั้งแต่ index ที่ 1
                        fullName.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                            fontSize: 20,
                            color: HexColor('#53CD9F'),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    onTap: () {
                      //Start bottomsheet
                      showModalBottomSheet<void>(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25.0),
                          ),
                        ),
                        context: context,
                        builder: (BuildContext context) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            //ทำให้พื้นที่ว่างลดลงและขยับลงมาให้ใกล้กับ widget ข้างใน
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Container(
                                  width: 60,
                                  height: 3,
                                  child: Image(
                                    image:
                                        Svg('assets/icons/thick-divider.svg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(
                                'SIGN OUT',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 30),
                                child: Text(
                                  'Do you want to sign out?',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                ),
                              ),
                              BottomSheetItemWidget(
                                uriSvg: 'assets/icons/signout.svg',
                                text: 'Sign Out',
                                press: () {
                                  signout();
                                },
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 25, bottom: 45),
                                child: Divider(
                                  indent: 20,
                                  endIndent: 20,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              title: Column(
                //ทำให้ Column ชิดซ้ายทั้งหมด
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello!',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: HexColor('#FFFFFF')),
                  ),
                  Text(
                    fullName.toString(),
                    //กันไม่ให้ Text overflow
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
            //------------------------------------------------------
            body: Container(
              child: Column(
                children: [
                  //Search Bar
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 10, top: 10),
                    child: CupertinoSearchTextField(
                      onChanged: (value) {
                        setState(() {
                          search = value;
                        });
                      },
                      padding: EdgeInsets.all(15),
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
                    ),
                  ),
                  //-----------End Search Bar --------------

                  Expanded(
                    child: FutureBuilder<List<TodoList>>(
                        future: getDataList(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.isEmpty) {
                              return Center(
                                child: Text(
                                  'LIST EMPTY',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                              );
                            } else {
                              return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: ((context, index) {
                                  return snapshot.data![index].userTodoListTitle
                                          .toLowerCase()
                                          .contains(search.toLowerCase())
                                      ? listCard(snapshot.data![index], context)
                                      : Container();
                                }),
                              );
                            }
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                  )
                  /* ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context,index)) */
                ],
              ),
            ),

            //ปุ่มวงกลมล่างขวา
            floatingActionButton: FloatingActionButton(
              backgroundColor: HexColor('#0D7A5C'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TodoScreen(),
                  ),
                  //ทำหลังpopกลับมา
                ).then((value) {
                  setState(() {});
                });
              },
              child: ImageIcon(
                Svg('assets/icons/add.svg'),
                size: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }

  listCard(TodoList getlist, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, left: 20, right: 20, top: 10),
      child: Container(
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
        child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          leading: getlist.userTodoListCompleted == 'true'
              ? Icon(
                  Icons.check_circle,
                  color: HexColor('#1DC9A0'),
                )
              : Icon(
                  Icons.radio_button_unchecked,
                ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(
                  width: 100,
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    getlist.userTodoListTitle,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(
                                (math.Random().nextDouble() * 0xFFFFFF).toInt())
                            .withOpacity(1.0)),
                  ),
                ),
              ),
              IconButton(
                iconSize: 25,
                icon: const Icon(Icons.more_horiz),
                onPressed: () {
                  showModalBottomSheet<void>(
                    shape: const RoundedRectangleBorder(
                      // <-- SEE HERE
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25.0),
                      ),
                    ),
                    context: context,
                    //constraints: BoxConstraints(maxHeight: 200),
                    builder: (BuildContext context) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Container(
                              width: 60,
                              height: 3,
                              child: Image(
                                image: Svg('assets/icons/thick-divider.svg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          //Sign out
                          BottomSheetItemWidget(
                            uriSvg: 'assets/icons/edit.svg',
                            text: 'Edit',
                            press: () {
                              //pop ทำให้ BottomSheet หายไป
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TodoScreen(
                                    //

                                    dataList: getlist,
                                  ),
                                ),
                              ).then((value) {
                                setState(() {});
                              });
                            },
                          ),
                          Divider(
                            indent: 20,
                            endIndent: 20,
                          ),
                          BottomSheetItemWidget(
                            uriSvg: 'assets/icons/delete.svg',
                            text: 'Delete',
                            press: () {
                              deleteById(getlist.userTodoListId);
                            },
                          ),
                          //End Signout
                          SizedBox(
                            height: 50,
                          )
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  //add duratoin +7 ให้เวลาเป็น time zone ของไทย
                  ' ${datetime.format(getlist.userTodoListLastUpdate.add(Duration(hours: 7)))}',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: HexColor('#BFBFBF')),
                ),
              ),
              Text(
                '${getlist.userTodoListDesc}',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: HexColor('#808080')),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
          isThreeLine: true,
        ),
      ),
    );
  }
}
