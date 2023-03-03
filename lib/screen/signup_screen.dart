import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:todo_pimpaka/controller/signin_controller.dart';
import 'package:todo_pimpaka/controller/signup_controller.dart';
import 'package:todo_pimpaka/widget/button_widget.dart';
import 'package:todo_pimpaka/widget/textfield_widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  TextEditingController user_firstname = TextEditingController();
  TextEditingController user_lastname = TextEditingController();
  TextEditingController user_email = TextEditingController();
  TextEditingController user_password = TextEditingController();
  signupController signup = signupController();
  final _formkey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
            child: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover),
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      // Make 3 column seperate like flex
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          iconSize: 35,
                          color: HexColor("#3CB189"),
                          icon: ImageIcon(Svg('assets/icons/back.svg')),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          'SIGN UP',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Please enter the information \nbelow to access.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 40),
                    child: Image(image: Svg('assets/icons/signup.svg')),
                  ),
                  TextFieldWidget(
                    text: 'First Name',
                    controller: user_firstname,
                    obscureText: false,
                    maxLineTextField: 1,
                    horizontalSize: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: TextFieldWidget(
                      text: 'Last Name',
                      controller: user_lastname,
                      obscureText: false,
                      maxLineTextField: 1,
                      horizontalSize: 25,
                    ),
                  ),
                  TextFieldWidget(
                    text: 'Email',
                    controller: user_email,
                    obscureText: false,
                    maxLineTextField: 1,
                    horizontalSize: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 45),
                    child: TextFieldWidget(
                      text: 'Password',
                      controller: user_password,
                      obscureText: true,
                      maxLineTextField: 1,
                      horizontalSize: 25,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 25, bottom: 20),
                    child: ButtonWidget(
                        textButton: 'SIGN UP',
                        press: () {
                          if (_formkey.currentState!.validate()) {
                            signup.signup(
                                user_email.text,
                                user_password.text,
                                user_firstname.text,
                                user_lastname.text,
                                context);
                          }
                        }),
                  )
                ]),
              ),
            ),
          ),
        )));
  }
}
