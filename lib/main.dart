import 'package:flutter/material.dart';
import 'package:todo_pimpaka/screen/signin_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //remove banner debug top right
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',

      theme: ThemeData(
        //เรียกใช้ font-family
        fontFamily: 'Outfit',
        primarySwatch: Colors.blue,
      ),
      home: SigninScreen(),
    );
  }
}
