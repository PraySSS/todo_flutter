import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_pimpaka/controller/signin_controller.dart';
import 'package:todo_pimpaka/screen/signup_screen.dart';
import 'package:todo_pimpaka/screen/todolist_screen.dart';
import 'package:todo_pimpaka/widget/button_widget.dart';
import 'package:todo_pimpaka/widget/second_button_widget.dart';
import 'package:todo_pimpaka/widget/textfield_widget.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  @override
  TextEditingController user_email = TextEditingController();
  TextEditingController user_password = TextEditingController();
  signinController signin = signinController();
  final _formkey = GlobalKey<FormState>();
  String getUserEmail = '';
  String getUserPassword = '';

  void getfullname() async {
    final prefs = await SharedPreferences.getInstance();
    final getEmail = prefs.getString('userEmail')!;
    final getPassword = prefs.getString('userPassword')!;
    //ต้อง setState ค่าถึงเข้าไปเก็บก่อนทำงาน
    setState(() {
      getUserEmail = getEmail;
      getUserPassword = getPassword;
    });
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

  Widget build(BuildContext context) {
    return GestureDetector(
      // ใช้ Gesuture detector เพื่อซ่อน Key board เมื่อแตะส่วนใดก็ได้ที่เราหุ้มด้วย Gesuture detector
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      // แก้ปัญหา status bar ด้านบนและพวกปุ่มกดกลับด้านล่างให้ไม่ไปทับแอพของเรา
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: SafeArea(
          child: Scaffold(
            body: Container(
              //ทำให้ container ยืดไม่มีที่สิ้นสุดตามขนาด device
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                //ใส่พื้นหลัง
                image: DecorationImage(
                    image: AssetImage('assets/images/bg.png'),
                    //ทำให้รูปขยายพอดีกับ Device
                    fit: BoxFit.cover),
              ),
              //ทำให้แอพสามารถ scroll ได้เมื่อ content ของเรามันเกินหน้าจอ
              child: SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25, bottom: 20),
                      child: Text(
                        'SIGN IN',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Text(
                      'Please enter the information \nbelow to access.',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Image(image: Svg('assets/icons/signin.svg')),
                    ),
                    TextFieldWidget(
                      text: 'Email',
                      controller: user_email,
                      obscureText: false,
                      maxLineTextField: 1,
                      horizontalSize: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: TextFieldWidget(
                        text: 'Password',
                        controller: user_password,
                        obscureText: true,
                        maxLineTextField: 1,
                        horizontalSize: 20,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 180, bottom: 50),
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ButtonWidget(
                          textButton: 'SIGN IN',
                          press: () {
                            if (_formkey.currentState!.validate()) {
                              signin.signin(
                                  user_email.text, user_password.text, context);
                            }
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 40, left: 20, right: 20),
                      child: SecondButtonWidget(
                          textButton: 'SIGN UP',
                          press: () {
                            _formkey.currentState!.reset();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupScreen(),
                              ),
                            );
                          }),
                    )
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
